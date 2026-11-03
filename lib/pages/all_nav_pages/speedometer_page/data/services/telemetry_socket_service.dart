import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:io';

import 'package:margnetra_super_app/core/app_services/api_services/api_urls.dart';
import 'package:margnetra_super_app/pages/all_nav_pages/speedometer_page/data/models/telemetry_socket_model.dart';

/// Connection states for the telemetry socket.
enum SocketConnectionStatus {
  disconnected,
  connecting,
  connected,
  error,
}

/// Service handling raw WebSocket connection, reconnection,
/// incoming telemetry parsing, and JSON transmission.
class TelemetrySocketService {
  WebSocket? _socket;
  StreamSubscription<dynamic>? _socketSubscription;

  SocketConnectionStatus _status = SocketConnectionStatus.disconnected;
  String? _lastError;
  String? _activeUrl;

  final StreamController<SocketConnectionStatus> _statusController =
      StreamController<SocketConnectionStatus>.broadcast();
  final StreamController<TelemetrySocketModel> _telemetryController =
      StreamController<TelemetrySocketModel>.broadcast();
  final StreamController<Map<String, dynamic>> _rawMessageController =
      StreamController<Map<String, dynamic>>.broadcast();

  /// Stream of connection status changes.
  Stream<SocketConnectionStatus> get statusStream => _statusController.stream;

  /// Stream of parsed incoming telemetry payloads.
  Stream<TelemetrySocketModel> get telemetryStream => _telemetryController.stream;

  /// Stream of all valid incoming JSON messages.
  Stream<Map<String, dynamic>> get rawMessageStream =>
      _rawMessageController.stream;

  /// Current connection status.
  SocketConnectionStatus get currentStatus => _status;

  /// Last error message, if any.
  String? get lastError => _lastError;

  /// Active connection URL.
  String? get activeUrl => _activeUrl;

  /// Whether the socket is currently open and ready to transmit.
  bool get isConnected =>
      _status == SocketConnectionStatus.connected && _socket != null;

  void _updateStatus(SocketConnectionStatus status, [String? error]) {
    _status = status;
    _lastError = error;
    if (!_statusController.isClosed) {
      _statusController.add(status);
    }
  }

  /// Connects to the telemetry WebSocket endpoint.
  /// If [url] is omitted, [ApiUrls.getTelemetrySocketUrl(token: token)] is used.
  Future<bool> connect({
    String? url,
    String? token,
    Duration timeout = const Duration(seconds: 8),
  }) async {
    final targetUrl = url ?? ApiUrls.getTelemetrySocketUrl(token: token);
    _activeUrl = targetUrl;

    if (isConnected && _activeUrl == targetUrl) {
      developer.log('Socket already connected to: $targetUrl',
          name: 'TelemetrySocket');
      return true;
    }

    await disconnect();
    _updateStatus(SocketConnectionStatus.connecting);

    developer.log('Connecting to WebSocket: $targetUrl',
        name: 'TelemetrySocket');

    try {
      _socket = await WebSocket.connect(targetUrl).timeout(timeout);
      _updateStatus(SocketConnectionStatus.connected);

      developer.log('Connected to WebSocket successfully.',
          name: 'TelemetrySocket');

      _socketSubscription = _socket!.listen(
        (dynamic rawData) {
          _handleIncomingMessage(rawData);
        },
        onError: (dynamic error) {
          developer.log('WebSocket stream error: $error',
              name: 'TelemetrySocket', error: error);
          _updateStatus(SocketConnectionStatus.error, error.toString());
        },
        onDone: () {
          developer.log('WebSocket closed by remote peer.',
              name: 'TelemetrySocket');
          _updateStatus(SocketConnectionStatus.disconnected);
        },
        cancelOnError: false,
      );

      return true;
    } catch (e) {
      developer.log('WebSocket connection failed: $e',
          name: 'TelemetrySocket', error: e);
      _updateStatus(SocketConnectionStatus.error, e.toString());
      return false;
    }
  }

  /// Dispatches a [TelemetrySocketModel] as a JSON string over the WebSocket.
  bool sendTelemetry(TelemetrySocketModel telemetry) {
    return sendJson(telemetry.toJson());
  }

  /// Dispatches any JSON payload over the WebSocket.
  bool sendJson(Map<String, dynamic> jsonMap) {
    if (!isConnected || _socket == null) {
      developer.log('Cannot send message: WebSocket is not connected.',
          name: 'TelemetrySocket');
      return false;
    }

    try {
      final jsonString = jsonEncode(jsonMap);
      _socket!.add(jsonString);
      developer.log('Sent WebSocket payload: $jsonString',
          name: 'TelemetrySocket');
      return true;
    } catch (e) {
      developer.log('Error sending WebSocket payload: $e',
          name: 'TelemetrySocket', error: e);
      _updateStatus(SocketConnectionStatus.error, e.toString());
      return false;
    }
  }

  void _handleIncomingMessage(dynamic rawData) {
    try {
      String text;
      if (rawData is String) {
        text = rawData;
      } else if (rawData is List<int>) {
        text = utf8.decode(rawData);
      } else {
        text = rawData.toString();
      }

      developer.log('Received WebSocket message: $text',
          name: 'TelemetrySocket');

      final decoded = jsonDecode(text);
      if (decoded is Map<String, dynamic>) {
        if (!_rawMessageController.isClosed) {
          _rawMessageController.add(decoded);
        }

        // If the payload contains telemetry fields, parse and emit
        if (decoded.containsKey('gps') ||
            decoded.containsKey('vehicle') ||
            decoded.containsKey('vehicleId') ||
            decoded.containsKey('speedKmh')) {
          final telemetry = TelemetrySocketModel.fromJson(decoded);
          if (!_telemetryController.isClosed) {
            _telemetryController.add(telemetry);
          }
        }
      }
    } catch (e) {
      developer.log('Error parsing incoming WebSocket message: $e',
          name: 'TelemetrySocket', error: e);
    }
  }

  /// Disconnects from the WebSocket.
  Future<void> disconnect() async {
    try {
      await _socketSubscription?.cancel();
      _socketSubscription = null;
      if (_socket != null) {
        await _socket?.close(WebSocketStatus.normalClosure, 'Client disconnect');
        _socket = null;
      }
    } catch (_) {}
    _updateStatus(SocketConnectionStatus.disconnected);
  }

  /// Cleans up all resources.
  void dispose() {
    disconnect();
    _statusController.close();
    _telemetryController.close();
    _rawMessageController.close();
  }
}

