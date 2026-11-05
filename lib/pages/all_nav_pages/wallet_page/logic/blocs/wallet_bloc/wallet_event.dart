import 'package:equatable/equatable.dart';

abstract class WalletEvent extends Equatable {
  const WalletEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load wallet dashboard summary data from server with cache-first support.
class LoadWalletDashboardEvent extends WalletEvent {
  final bool isRefresh;

  const LoadWalletDashboardEvent({this.isRefresh = false});

  @override
  List<Object?> get props => [isRefresh];
}

/// Event to fetch or refresh transaction history list.
class FetchTransactionsEvent extends WalletEvent {
  final int page;
  final int size;
  final bool isRefresh;

  const FetchTransactionsEvent({
    this.page = 1,
    this.size = 10,
    this.isRefresh = false,
  });

  @override
  List<Object?> get props => [page, size, isRefresh];
}

/// Event to load the next page of transactions (pagination with size 10).
class LoadMoreTransactionsEvent extends WalletEvent {
  final int size;

  const LoadMoreTransactionsEvent({this.size = 10});

  @override
  List<Object?> get props => [size];
}
