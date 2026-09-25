import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart' as fbp;
import 'package:margnetra_super_app/core/app_services/bluetooth_service/bluetooth_service.dart';
import 'package:margnetra_super_app/core/utils/app_colors.dart';
import 'package:margnetra_super_app/core/utils/app_text_style.dart';
import 'package:margnetra_super_app/pages/all_nav_pages/bluetooth_connect_cab_page/widgets/bt_communication_panel.dart';
import 'package:margnetra_super_app/pages/all_nav_pages/bluetooth_connect_cab_page/widgets/bt_device_tile.dart';

/// Full-screen BLE Scan → Connect → Communicate page.
///
/// Flow:
///   1. Check permissions on init
///   2. Show adapter state — turn-on button if OFF
///   3. Scan button → live list of discovered devices
///   4. Tap Connect on a device → connect + show communication panel
class BluetoothScanPage extends StatefulWidget {
  const BluetoothScanPage({super.key});

  @override
  State<BluetoothScanPage> createState() => _BluetoothScanPageState();
}

class _BluetoothScanPageState extends State<BluetoothScanPage>
    with TickerProviderStateMixin {
  final BluetoothService _btService = BluetoothService();
  late AnimationController _scanPulseController;
  late Animation<double> _scanPulse;

  @override
  void initState() {
    super.initState();
    _btService.init();
    _scanPulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
    _scanPulse = Tween<double>(begin: 0.9, end: 1.1).animate(
      CurvedAnimation(parent: _scanPulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _scanPulseController.dispose();
    super.dispose();
  }

  // ─── Helpers ──────────────────────────────────────────────────────────────

  Future<void> _toggleScan() async {
    if (_btService.isScanning) {
      await _btService.stopScan();
    } else {
      await _btService.startScan();
    }
  }

  void _showSnack(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg, style: const TextStyle(color: Colors.white)),
        backgroundColor: AppColors.surface,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  // ─── Build ────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF010A12),
      appBar: _buildAppBar(context),
      body: AnimatedBuilder(
        animation: _btService,
        builder: (context, _) {
          return Column(
            children: [
              // 1. Adapter state + permission banner
              _AdapterStateBanner(
                btService: _btService,
                onTurnOn: () async {
                  await _btService.turnOnBluetooth();
                },
              ),

              // 2. Scan controls
              _ScanControls(
                btService: _btService,
                scanPulse: _scanPulse,
                onToggleScan: _toggleScan,
              ),

              // 3. Content: device list OR communication panel
              Expanded(
                child: _btService.isDeviceConnected
                    ? _connectedView()
                    : _scanResultsView(),
              ),
            ],
          );
        },
      ),
    );
  }

  // ─── App Bar ──────────────────────────────────────────────────────────────

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFF010A12),
      elevation: 0,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios_new,
          color: AppColors.primaryHudCyan,
          size: 18,
        ),
        onPressed: () => Navigator.pop(context),
      ),
      title: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.primaryHudCyan, width: 1),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryHudCyan.withOpacity(0.3),
                  blurRadius: 8,
                ),
              ],
            ),
            child: const Icon(
              Icons.bluetooth_searching,
              color: AppColors.primaryHudCyan,
              size: 14,
            ),
          ),
          const SizedBox(width: 10),
          Text(
            'Bluetooth Connect',
            style: AppTextStyle.customGilroyFontMedium(
              fontSize: 16,
              color: AppColors.primaryText,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
      actions: [
        if (_btService.isDeviceConnected)
          TextButton.icon(
            onPressed: () async {
              await _btService.disconnectDevice();
              _showSnack('Disconnected');
            },
            icon: const Icon(
              Icons.link_off,
              color: AppColors.errorDangerRed,
              size: 16,
            ),
            label: const Text(
              'Disconnect',
              style: TextStyle(color: AppColors.errorDangerRed, fontSize: 12),
            ),
          ),
      ],
    );
  }

  // ─── Scan results list ────────────────────────────────────────────────────

  Widget _scanResultsView() {
    final results = _btService.scanResults;
    if (results.isEmpty) {
      return _EmptyState(isScanning: _btService.isScanning);
    }
    return ListView.builder(
      padding: const EdgeInsets.only(top: 8, bottom: 20),
      itemCount: results.length,
      itemBuilder: (context, index) {
        return AnimatedBuilder(
          animation: _btService,
          builder: (context, _) =>
              BtDeviceTile(scanResult: results[index], btService: _btService),
        );
      },
    );
  }

  // ─── Connected view ───────────────────────────────────────────────────────

  Widget _connectedView() {
    final device = _btService.connectedDevice!;
    final name = device.platformName.isNotEmpty
        ? device.platformName
        : device.remoteId.str;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Connected device info card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.green.withOpacity(0.07),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.green.withOpacity(0.4)),
              boxShadow: [
                BoxShadow(
                  color: AppColors.green.withOpacity(0.12),
                  blurRadius: 14,
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.green.withOpacity(0.12),
                    border: Border.all(color: AppColors.green, width: 1.5),
                  ),
                  child: const Icon(
                    Icons.bluetooth_connected,
                    color: AppColors.green,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: AppTextStyle.customGilroyFontMedium(
                          fontSize: 15,
                          color: AppColors.green,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        device.remoteId.str,
                        style: AppTextStyle.customGilroyFontLight(
                          fontSize: 11,
                          color: Colors.white38,
                        ),
                      ),
                    ],
                  ),
                ),
                // Live pulse dot
                _LiveDot(),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Communication panel
          AnimatedBuilder(
            animation: _btService,
            builder: (context, _) =>
                BtCommunicationPanel(btService: _btService),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Adapter State Banner
// ─────────────────────────────────────────────────────────────────────────────
class _AdapterStateBanner extends StatelessWidget {
  final BluetoothService btService;
  final VoidCallback onTurnOn;

  const _AdapterStateBanner({required this.btService, required this.onTurnOn});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<fbp.BluetoothAdapterState>(
      stream: btService.adapterStateStream,
      initialData: btService.adapterState,
      builder: (context, snapshot) {
        final state = snapshot.data ?? fbp.BluetoothAdapterState.unknown;
        final isOn = state == fbp.BluetoothAdapterState.on;
        final stateColor = isOn ? AppColors.green : AppColors.errorDangerRed;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: stateColor.withOpacity(0.07),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: stateColor.withOpacity(0.35)),
          ),
          child: Row(
            children: [
              Icon(
                isOn ? Icons.bluetooth : Icons.bluetooth_disabled,
                color: stateColor,
                size: 18,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Adapter State',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.white38,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      btService.adapterStateLabel,
                      style: TextStyle(
                        fontSize: 13,
                        color: stateColor,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
              if (!isOn)
                GestureDetector(
                  onTap: onTurnOn,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primaryHudCyan.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppColors.primaryHudCyan.withOpacity(0.6),
                      ),
                    ),
                    child: Text(
                      'Turn On',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.primaryHudCyan,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Scan Controls
// ─────────────────────────────────────────────────────────────────────────────
class _ScanControls extends StatelessWidget {
  final BluetoothService btService;
  final Animation<double> scanPulse;
  final VoidCallback onToggleScan;

  const _ScanControls({
    required this.btService,
    required this.scanPulse,
    required this.onToggleScan,
  });

  @override
  Widget build(BuildContext context) {
    final isScanning = btService.isScanning;
    final deviceCount = btService.scanResults.length;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      child: Row(
        children: [
          // Device count badge
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isScanning ? 'Scanning for devices…' : 'Nearby BLE Devices',
                  style: AppTextStyle.customGilroyFontMedium(
                    fontSize: 14,
                    color: AppColors.primaryText,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (deviceCount > 0)
                  Text(
                    '$deviceCount device${deviceCount == 1 ? '' : 's'} found',
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.primaryHudCyan,
                    ),
                  ),
              ],
            ),
          ),

          // Scan button
          GestureDetector(
            onTap: btService.isAdapterOn ? onToggleScan : null,
            child: AnimatedBuilder(
              animation: scanPulse,
              builder: (_, child) => Transform.scale(
                scale: isScanning ? scanPulse.value : 1.0,
                child: child,
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: isScanning
                      ? AppColors.accentSaffron.withOpacity(0.15)
                      : AppColors.primaryHudCyan.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: isScanning
                        ? AppColors.accentSaffron
                        : AppColors.primaryHudCyan,
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: isScanning
                          ? AppColors.accentSaffron.withOpacity(0.25)
                          : AppColors.primaryHudCyan.withOpacity(0.2),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isScanning ? Icons.stop_circle_outlined : Icons.radar,
                      color: isScanning
                          ? AppColors.accentSaffron
                          : AppColors.primaryHudCyan,
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      isScanning ? 'Stop' : 'Scan',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: isScanning
                            ? AppColors.accentSaffron
                            : AppColors.primaryHudCyan,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Empty state
// ─────────────────────────────────────────────────────────────────────────────
class _EmptyState extends StatelessWidget {
  final bool isScanning;
  const _EmptyState({required this.isScanning});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isScanning
                ? Icons.bluetooth_searching
                : Icons.bluetooth_disabled_outlined,
            color: Colors.white12,
            size: 72,
          ),
          const SizedBox(height: 16),
          Text(
            isScanning
                ? 'Looking for devices…'
                : 'Press Scan to discover\nnearby BLE devices',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white30,
              fontSize: 14,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Live pulse dot (for connected card)
// ─────────────────────────────────────────────────────────────────────────────
class _LiveDot extends StatefulWidget {
  @override
  State<_LiveDot> createState() => _LiveDotState();
}

class _LiveDotState extends State<_LiveDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _c;
  late Animation<double> _a;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..repeat(reverse: true);
    _a = Tween<double>(
      begin: 0.4,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _c, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _a,
      builder: (_, __) => Opacity(
        opacity: _a.value,
        child: Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.green,
            boxShadow: [
              BoxShadow(color: AppColors.green.withOpacity(0.6), blurRadius: 6),
            ],
          ),
        ),
      ),
    );
  }
}
