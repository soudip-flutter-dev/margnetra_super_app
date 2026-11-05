import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:margnetra_super_app/core/utils/custom_snack_bar.dart';
import 'package:margnetra_super_app/pages/all_nav_pages/wallet_page/data/models/models.dart';
import 'package:margnetra_super_app/pages/all_nav_pages/wallet_page/logic/blocs/wallet_bloc/wallet_bloc.dart';
import 'package:margnetra_super_app/pages/all_nav_pages/wallet_page/widgets/widgets.dart';

/// Top-level Wallet page widget embedded inside the main navigation tabs.
class MgcWalletWidget extends StatefulWidget {
  const MgcWalletWidget({super.key});

  @override
  State<MgcWalletWidget> createState() => _MgcWalletWidgetState();
}

typedef WalletPage = MgcWalletWidget;

class _MgcWalletWidgetState extends State<MgcWalletWidget> {
  // ─────────────────────────────────────────────────────────────
  // Color palette
  // ─────────────────────────────────────────────────────────────
  static const Color backgroundColor = Color(0xFF0A0A0F);
  static const Color cyanAccent = Color(0xFF00D9E8);

  static const Color greenBorder = Color(0xFF245B45);
  static const Color greenBackground = Color(0xFF10231C);

  static const Color amberBorder = Color(0xFF624829);
  static const Color amberBackground = Color(0xFF21180F);

  static const Color redBorder = Color(0xFF5E2E32);
  static const Color redBackground = Color(0xFF211113);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final state = context.read<WalletBloc>().state;
        if (state is WalletInitial) {
          context.read<WalletBloc>().add(const LoadWalletDashboardEvent());
        } else if (state is WalletLoaded && state.transactions.isEmpty) {
          context.read<WalletBloc>().add(
                const FetchTransactionsEvent(page: 1, size: 10),
              );
        }
      }
    });
  }

  void _onRefresh() {
    context.read<WalletBloc>().add(
          const LoadWalletDashboardEvent(isRefresh: true),
        );
  }

  String _formatNumber(num val) {
    final parts = val.toString().split('.');
    final integerPart = parts[0];
    final regex = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    final formattedInt =
        integerPart.replaceAllMapped(regex, (m) => '${m[1]},');
    if (parts.length > 1 && parts[1] != '0') {
      return '$formattedInt.${parts[1]}';
    }
    return formattedInt;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      child: SafeArea(
        child: BlocBuilder<WalletBloc, WalletState>(
          builder: (context, state) {
            final isLoading = state is WalletLoading && state.cachedData == null;

            final WalletDashboardDataModel? data = (state is WalletLoaded)
                ? state.data
                : (state is WalletLoading
                    ? state.cachedData
                    : (state is WalletError ? state.cachedData : null));

            return RefreshIndicator(
              onRefresh: () async {
                _onRefresh();
                await Future.delayed(const Duration(milliseconds: 600));
              },
              color: cyanAccent,
              backgroundColor: const Color(0xFF141724),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ─────────────────────────────────────────────────
                    // Header
                    // ─────────────────────────────────────────────────
                    _buildHeader(context, state, data),

                    const SizedBox(height: 18),

                    // Loading spinner when no data yet
                    if (isLoading) ...[
                      const SizedBox(height: 40),
                      const Center(
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(cyanAccent),
                        ),
                      ),
                      const SizedBox(height: 40),
                    ] else if (state is WalletError && state.cachedData == null) ...[
                      // Error state view with retry button
                      _buildErrorView(context, state.message),
                    ] else if (data != null) ...[
                      // ─────────────────────────────────────────────────
                      // Available MGC
                      // ─────────────────────────────────────────────────
                      WalletBalanceCard(
                        label: 'Available MGC',
                        value: _formatNumber(data.balance.availableMgc),
                        currency: data.balance.currency,
                        backgroundColor: greenBackground,
                        borderColor: greenBorder,
                        icon: Icons.account_balance_wallet_outlined,
                      ),

                      const SizedBox(height: 12),

                      // ─────────────────────────────────────────────────
                      // Provisional MGC
                      // ─────────────────────────────────────────────────
                      WalletBalanceCard(
                        label: 'Provisional MGC',
                        value: _formatNumber(data.balance.provisionalMgc),
                        currency: data.balance.currency,
                        backgroundColor: amberBackground,
                        borderColor: amberBorder,
                        topRightText: 'Settles in 24h',
                        icon: Icons.hourglass_top_rounded,
                      ),

                      const SizedBox(height: 12),

                      // ─────────────────────────────────────────────────
                      // Held MGC
                      // ─────────────────────────────────────────────────
                      WalletBalanceCard(
                        label: 'Held MGC',
                        value: _formatNumber(data.balance.heldMgc),
                        currency: data.balance.currency,
                        backgroundColor: redBackground,
                        borderColor: redBorder,
                        icon: Icons.lock_outline_rounded,
                      ),

                      const SizedBox(height: 12),

                      // ─────────────────────────────────────────────────
                      // Civil Score Card
                      // ─────────────────────────────────────────────────
                      CivilScoreCard(
                        civilScore: data.civilScore,
                        civilRating: data.civilRating,
                        activeStreakProtections:
                            data.activeStreakProtections,
                      ),

                      const SizedBox(height: 28),

                      // ─────────────────────────────────────────────────
                      // Quick Actions section
                      // ─────────────────────────────────────────────────
                      const Text(
                        'Quick Actions',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.1,
                        ),
                      ),

                      const SizedBox(height: 12),

                      QuickActionTile(
                        icon: Icons.local_taxi_rounded,
                        title: 'REDEEM FASTAG',
                        subtitle: 'Recharge your FASTag',
                        onTap: () {
                          CustomSnackBar.showInfo(
                              context, 'FASTag Recharge feature opening...');
                        },
                      ),

                      const SizedBox(height: 10),

                      QuickActionTile(
                        icon: Icons.shield_rounded,
                        title: 'BUY STREAK PROTECTION',
                        subtitle: '(50 MGC)',
                        onTap: () {
                          CustomSnackBar.showInfo(context,
                              'Streak Protection: 50 MGC deducted on confirmation.');
                        },
                      ),

                      const SizedBox(height: 28),

                      // ─────────────────────────────────────────────────
                      // Recent Transactions Section (with Pagination)
                      // ─────────────────────────────────────────────────
                      _buildRecentTransactionsSection(
                        context: context,
                        transactions: (state is WalletLoaded)
                            ? state.transactions
                            : data.recentTransactions,
                        currentPage:
                            (state is WalletLoaded) ? state.currentPage : 1,
                        hasReachedMax: (state is WalletLoaded)
                            ? state.hasReachedMax
                            : true,
                        isLoadingMore: (state is WalletLoaded)
                            ? state.isLoadingMore
                            : false,
                      ),
                    ],
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    WalletState state,
    WalletDashboardDataModel? data,
  ) {
    final isSyncing = state is WalletLoading;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'MGC Wallet',
              style: TextStyle(
                color: Colors.white,
                fontSize: 21,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.3,
              ),
            ),
            if (data != null) ...[
              const SizedBox(height: 2),
              Text(
                'Total: ${_formatNumber(data.balance.totalMgc)} ${data.balance.currency}',
                style: const TextStyle(
                  color: cyanAccent,
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ],
        ),

        // Header actions (Sync refresh button & grid icon)
        Row(
          children: [
            IconButton(
              onPressed: isSyncing ? null : _onRefresh,
              tooltip: 'Refresh Wallet',
              icon: isSyncing
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(cyanAccent),
                      ),
                    )
                  : const Icon(
                      Icons.refresh_rounded,
                      color: Colors.white,
                      size: 22,
                    ),
            ),
            const SizedBox(width: 4),
            _buildGridIcon(),
          ],
        ),
      ],
    );
  }

  Widget _buildRecentTransactionsSection({
    required BuildContext context,
    required List<WalletTransactionModel> transactions,
    required int currentPage,
    required bool hasReachedMax,
    required bool isLoadingMore,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Recent Transactions',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.1,
              ),
            ),
            if (transactions.isNotEmpty)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFF141724),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: const Color(0xFF262B3D)),
                ),
                child: Text(
                  'Page $currentPage • ${transactions.length} items',
                  style: const TextStyle(
                    color: Color(0xFF858A96),
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),
        if (transactions.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
            decoration: BoxDecoration(
              color: const Color(0xFF101318),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFF242932)),
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.receipt_long_outlined,
                  color: Color(0xFF858A96),
                  size: 32,
                ),
                const SizedBox(height: 8),
                const Text(
                  'No recent transactions found.',
                  style: TextStyle(
                    color: Color(0xFF858A96),
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 10),
                TextButton.icon(
                  onPressed: () {
                    context.read<WalletBloc>().add(
                          const FetchTransactionsEvent(
                            page: 1,
                            size: 10,
                            isRefresh: true,
                          ),
                        );
                  },
                  icon: const Icon(Icons.refresh_rounded,
                      size: 16, color: cyanAccent),
                  label: const Text(
                    'Fetch Transactions',
                    style: TextStyle(color: cyanAccent, fontSize: 12),
                  ),
                ),
              ],
            ),
          )
        else ...[
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: transactions.length,
            separatorBuilder: (_, index) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              return WalletTransactionTile(
                transaction: transactions[index],
              );
            },
          ),

          // Pagination status / Load More button
          if (isLoadingMore)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(cyanAccent),
                      ),
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Loading more transactions...',
                      style: TextStyle(
                        color: Color(0xFF858A96),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else if (!hasReachedMax)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: InkWell(
                onTap: () {
                  context.read<WalletBloc>().add(
                        const LoadMoreTransactionsEvent(size: 10),
                      );
                },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF141724),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFF262B3D)),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.expand_more_rounded,
                          size: 18, color: cyanAccent),
                      SizedBox(width: 6),
                      Text(
                        'LOAD MORE TRANSACTIONS (10 PER PAGE)',
                        style: TextStyle(
                          color: cyanAccent,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.6,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          else if (transactions.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 14),
              child: Center(
                child: Text(
                  'All transactions loaded (${transactions.length} total)',
                  style: const TextStyle(
                    color: Color(0xFF555B6E),
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
        ],
      ],
    );
  }

  Widget _buildErrorView(BuildContext context, String message) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1215),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF5E2E32)),
      ),
      child: Column(
        children: [
          const Icon(Icons.error_outline_rounded,
              color: Color(0xFFFF5252), size: 36),
          const SizedBox(height: 10),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white, fontSize: 13),
          ),
          const SizedBox(height: 14),
          ElevatedButton.icon(
            onPressed: _onRefresh,
            icon: const Icon(Icons.refresh_rounded, size: 18),
            label: const Text('Try Again'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF242731),
              foregroundColor: cyanAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridIcon() {
    return SizedBox(
      width: 24,
      height: 24,
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        itemCount: 16,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 3,
          mainAxisSpacing: 3,
        ),
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.65),
              borderRadius: BorderRadius.circular(1.5),
            ),
          );
        },
      ),
    );
  }
}
