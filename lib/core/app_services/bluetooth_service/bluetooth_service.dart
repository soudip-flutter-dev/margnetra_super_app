import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

/// Central service for all BLE operations.
/// Exposes streams for adapter state, scan results, and data communication.
/// Usage: create one instance and share via InheritedWidget / constructor injection.
class BluetoothService extends ChangeNotifier {
  // ─── Singleton ────────────────────────────────────────────────────────────
  static final BluetoothService _instance = BluetoothService._internal();
  factory BluetoothService() => _instance;
  BluetoothService._internal();

  // ─── Public state ─────────────────────────────────────────────────────────
  BluetoothAdapterState adapterState = BluetoothAdapterState.unknown;
  List<ScanResult> scanResults = [];
  BluetoothDevice? connectedDevice;
  bool isScanning = false;
  bool isConnecting = false;
  String? connectionError;

  /// Log of received data messages (for the communication panel).
  final List<String> receivedDataLog = [];

  // ─── Private internals ────────────────────────────────────────────────────
  StreamSubscription<BluetoothAdapterState>? _adapterSub;
  StreamSubscription<List<ScanResult>>? _scanSub;
  StreamSubscription<BluetoothConnectionState>? _connectionSub;
  StreamSubscription<List<int>>? _notifySub;

  BluetoothCharacteristic? _writeCharacteristic;
  BluetoothCharacteristic? _notifyCharacteristic;

  // ─── Initialise — call once from app root ─────────────────────────────────
  void init() {
    _adapterSub = FlutterBluePlus.adapterState.listen((state) {
      adapterState = state;
      notifyListeners();
    });
  }

  // ─── Adapter ──────────────────────────────────────────────────────────────

  /// Stream version of adapter state (convenient for StreamBuilder).
  Stream<BluetoothAdapterState> get adapterStateStream =>
      FlutterBluePlus.adapterState;

  /// Request the system to turn Bluetooth on (Android only).
  Future<void> turnOnBluetooth() async {
    try {
      await FlutterBluePlus.turnOn();
    } catch (e) {
      debugPrint('[BT] turnOn failed: $e');
    }
  }

  // ─── Scan ─────────────────────────────────────────────────────────────────

  Future<void> startScan({Duration timeout = const Duration(seconds: 10)}) async {
    if (isScanning) return;
    scanResults = [];
    notifyListeners();

    _scanSub?.cancel();
    _scanSub = FlutterBluePlus.scanResults.listen((results) {
      scanResults = results;
      notifyListeners();
    });

    try {
      await FlutterBluePlus.startScan(timeout: timeout);
      isScanning = true;
      notifyListeners();
    } catch (e) {
      debugPrint('[BT] startScan error: $e');
    }

    // When scan ends (timeout or manual stop), update flag
    FlutterBluePlus.isScanning.listen((scanning) {
      isScanning = scanning;
      notifyListeners();
    });
  }

  Future<void> stopScan() async {
    await FlutterBluePlus.stopScan();
    isScanning = false;
    notifyListeners();
  }

  // ─── Connect ──────────────────────────────────────────────────────────────

  Future<bool> connectToDevice(BluetoothDevice device) async {
    if (connectedDevice != null) {
      await disconnectDevice();
    }

    isConnecting = true;
    connectionError = null;
    notifyListeners();

    try {
      await device.connect(
          license: License.free, timeout: const Duration(seconds: 15));
      connectedDevice = device;

      // Listen for disconnection
      _connectionSub = device.connectionState.listen((state) {
        if (state == BluetoothConnectionState.disconnected) {
          connectedDevice = null;
          _writeCharacteristic = null;
          _notifyCharacteristic = null;
          notifyListeners();
        }
      });

      await _discoverServicesAndSetup(device);

      isConnecting = false;
      notifyListeners();
      return true;
    } catch (e) {
      connectionError = e.toString();
      isConnecting = false;
      connectedDevice = null;
      notifyListeners();
      debugPrint('[BT] connect error: $e');
      return false;
    }
  }

  Future<void> disconnectDevice() async {
    await _notifySub?.cancel();
    _notifySub = null;
    await _connectionSub?.cancel();
    _connectionSub = null;
    await connectedDevice?.disconnect();
    connectedDevice = null;
    _writeCharacteristic = null;
    _notifyCharacteristic = null;
    notifyListeners();
  }

  // ─── Discover services ────────────────────────────────────────────────────

  Future<void> _discoverServicesAndSetup(BluetoothDevice device) async {
    final services = await device.discoverServices();
    for (final service in services) {
      for (final char in service.characteristics) {
        final props = char.properties;
        // Prefer the first writable characteristic
        if (props.write || props.writeWithoutResponse) {
          _writeCharacteristic ??= char;
        }
        // Prefer the first notifiable characteristic
        if (props.notify || props.indicate) {
          _notifyCharacteristic ??= char;
        }
      }
    }

    // Subscribe to notifications
    if (_notifyCharacteristic != null) {
      await _notifyCharacteristic!.setNotifyValue(true);
      _notifySub = _notifyCharacteristic!.lastValueStream.listen((data) {
        if (data.isNotEmpty) {
          final hex = data.map((b) => b.toRadixString(16).padLeft(2, '0')).join(' ');
          final text = String.fromCharCodes(data);
          receivedDataLog.add('[RX] hex: $hex  |  ascii: $text');
          if (receivedDataLog.length > 100) receivedDataLog.removeAt(0);
          notifyListeners();
        }
      });
    }
  }

  // ─── Communicate ──────────────────────────────────────────────────────────

  /// Send a UTF-8 string to the connected device.
  Future<bool> sendString(String text) async {
    return sendBytes(text.codeUnits);
  }

  /// Send raw bytes to the connected device.
  Future<bool> sendBytes(List<int> bytes) async {
    if (_writeCharacteristic == null) {
      debugPrint('[BT] No writable characteristic found.');
      return false;
    }
    try {
      await _writeCharacteristic!.write(bytes, withoutResponse: false);
      receivedDataLog.add(
          '[TX] ${String.fromCharCodes(bytes)}  |  hex: ${bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join(' ')}');
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('[BT] write error: $e');
      return false;
    }
  }

  // ─── Helpers ──────────────────────────────────────────────────────────────

  String get adapterStateLabel {
    switch (adapterState) {
      case BluetoothAdapterState.on:
        return 'ON';
      case BluetoothAdapterState.off:
        return 'OFF';
      case BluetoothAdapterState.unauthorized:
        return 'UNAUTHORIZED';
      case BluetoothAdapterState.unavailable:
        return 'UNAVAILABLE';
      case BluetoothAdapterState.turningOn:
        return 'TURNING ON…';
      case BluetoothAdapterState.turningOff:
        return 'TURNING OFF…';
      default:
        return 'UNKNOWN';
    }
  }

  bool get isAdapterOn => adapterState == BluetoothAdapterState.on;
  bool get isDeviceConnected => connectedDevice != null;

  // ─── Dispose ──────────────────────────────────────────────────────────────
  @override
  void dispose() {
    _adapterSub?.cancel();
    _scanSub?.cancel();
    _connectionSub?.cancel();
    _notifySub?.cancel();
    super.dispose();
  }
}
