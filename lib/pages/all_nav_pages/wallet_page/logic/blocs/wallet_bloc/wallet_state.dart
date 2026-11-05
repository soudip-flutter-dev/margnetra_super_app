import 'package:equatable/equatable.dart';
import 'package:margnetra_super_app/pages/all_nav_pages/wallet_page/data/models/models.dart';

abstract class WalletState extends Equatable {
  const WalletState();

  @override
  List<Object?> get props => [];
}

/// Initial uninitialized state.
class WalletInitial extends WalletState {
  const WalletInitial();
}

/// Loading state while fetching fresh dashboard data.
class WalletLoading extends WalletState {
  final WalletDashboardDataModel? cachedData;

  const WalletLoading({this.cachedData});

  @override
  List<Object?> get props => [cachedData];
}

/// Successfully loaded wallet dashboard state with paginated transactions support.
class WalletLoaded extends WalletState {
  final WalletDashboardDataModel data;
  final List<WalletTransactionModel> transactions;
  final int currentPage;
  final int pageSize;
  final bool hasReachedMax;
  final bool isLoadingMore;

  WalletLoaded({
    required this.data,
    List<WalletTransactionModel>? transactions,
    this.currentPage = 1,
    this.pageSize = 10,
    this.hasReachedMax = false,
    this.isLoadingMore = false,
  }) : transactions = transactions ?? data.recentTransactions;

  WalletLoaded copyWith({
    WalletDashboardDataModel? data,
    List<WalletTransactionModel>? transactions,
    int? currentPage,
    int? pageSize,
    bool? hasReachedMax,
    bool? isLoadingMore,
  }) {
    return WalletLoaded(
      data: data ?? this.data,
      transactions: transactions ?? this.transactions,
      currentPage: currentPage ?? this.currentPage,
      pageSize: pageSize ?? this.pageSize,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  @override
  List<Object?> get props => [
        data,
        transactions,
        currentPage,
        pageSize,
        hasReachedMax,
        isLoadingMore,
      ];
}

/// Error state when fetching wallet data fails.
class WalletError extends WalletState {
  final String message;
  final WalletDashboardDataModel? cachedData;

  const WalletError({
    required this.message,
    this.cachedData,
  });

  @override
  List<Object?> get props => [message, cachedData];
}
