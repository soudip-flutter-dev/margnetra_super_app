import 'package:flutter/material.dart';
import 'package:margnetra_super_app/core/app_services/bluetooth_service/bluetooth_service.dart';
import 'package:margnetra_super_app/core/utils/app_colors.dart';
import 'package:margnetra_super_app/core/utils/app_text_style.dart';

/// Panel shown after a BLE device is connected.
/// Allows sending a string/hex to the device and displays a scrollable log
/// of all TX (sent) and RX (received) data.
class BtCommunicationPanel extends StatefulWidget {
  final BluetoothService btService;

  const BtCommunicationPanel({super.key, required this.btService});

  @override
  State<BtCommunicationPanel> createState() => _BtCommunicationPanelState();
}

class _BtCommunicationPanelState extends State<BtCommunicationPanel> {
  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isSending = false;

  Future<void> _send() async {
    final text = _inputController.text.trim();
    if (text.isEmpty) return;

    setState(() => _isSending = true);
    await widget.btService.sendString(text);
    _inputController.clear();
    setState(() => _isSending = false);
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final log = widget.btService.receivedDataLog;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primaryHudCyan.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ─── Header ─────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
            child: Row(
              children: [
                Icon(
                  Icons.terminal,
                  color: AppColors.primaryHudCyan,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Text(
                  'Communication Log',
                  style: AppTextStyle.customGilroyFontMedium(
                    fontSize: 13,
                    color: AppColors.primaryHudCyan,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                // Clear log button
                GestureDetector(
                  onTap: () {
                    setState(() {
                      widget.btService.receivedDataLog.clear();
                    });
                  },
                  child: Text(
                    'Clear',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.white38,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const Divider(color: Colors.white10, height: 1),

          // ─── Data log ────────────────────────────────────────────────────
          Container(
            height: 160,
            padding: const EdgeInsets.all(12),
            child: log.isEmpty
                ? Center(
                    child: Text(
                      'No data yet. Send a message or wait for device to respond.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.white24,
                      ),
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    itemCount: log.length,
                    itemBuilder: (context, index) {
                      final entry = log[index];
                      final isTx = entry.startsWith('[TX]');
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: Text(
                          entry,
                          style: TextStyle(
                            fontSize: 11,
                            fontFamily: 'monospace',
                            color: isTx
                                ? AppColors.accentSaffron
                                : AppColors.green,
                            letterSpacing: 0.3,
                          ),
                        ),
                      );
                    },
                  ),
          ),

          const Divider(color: Colors.white10, height: 1),

          // ─── Input row ───────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
            child: Row(
              children: [
                // Text input
                Expanded(
                  child: Container(
                    height: 42,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.04),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: AppColors.primaryHudCyan.withOpacity(0.3),
                      ),
                    ),
                    child: TextField(
                      controller: _inputController,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                      ),
                      decoration: const InputDecoration(
                        hintText: 'Type a message or hex bytes…',
                        hintStyle: TextStyle(
                          color: Colors.white30,
                          fontSize: 12,
                        ),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(vertical: 12),
                      ),
                      onSubmitted: (_) => _send(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                // Send button
                GestureDetector(
                  onTap: _isSending ? null : _send,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: _isSending
                          ? AppColors.primaryHudCyan.withOpacity(0.3)
                          : AppColors.primaryHudCyan,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryHudCyan.withOpacity(0.3),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: _isSending
                        ? const Padding(
                            padding: EdgeInsets.all(11),
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColors.background),
                            ),
                          )
                        : const Icon(
                            Icons.send_rounded,
                            color: AppColors.background,
                            size: 18,
                          ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
