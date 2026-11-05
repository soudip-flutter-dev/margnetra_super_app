import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:margnetra_super_app/core/app_exception_handler/app_exception_handler.dart';
import 'package:margnetra_super_app/pages/all_nav_pages/wallet_page/data/repositories/wallet_repository.dart';
import 'package:margnetra_super_app/pages/all_nav_pages/wallet_page/logic/blocs/wallet_bloc/wallet_event.dart';
import 'package:margnetra_super_app/pages/all_nav_pages/wallet_page/logic/blocs/wallet_bloc/wallet_state.dart';

export 'wallet_event.dart';
export 'wallet_state.dart';

class WalletBloc extends Bloc<WalletEvent, WalletState> {
  final IWalletRepository _walletRepository;

  WalletBloc({IWalletRepository? walletRepository})
      : _walletRepository = walletRepository ?? WalletRepository(),
        super(const WalletInitial()) {
    on<LoadWalletDashboardEvent>(_onLoadDashboard);
    on<FetchTransactionsEvent>(_onFetchTransactions);
    on<LoadMoreTransactionsEvent>(_onLoadMoreTransactions);
  }

  Future<void> _onLoadDashboard(
    LoadWalletDashboardEvent event,
    Emitter<WalletState> emit,
  ) async {
    final cached = _walletRepository.getCachedWalletDashboard();

    // Cache-first: show cached data immediately while fetching fresh data
    if (cached != null && !event.isRefresh) {
      emit(WalletLoading(cachedData: cached));
    } else if (!event.isRefresh && state is! WalletLoaded) {
      emit(const WalletLoading());
    }

    try {
      final dashboardResponse = await _walletRepository.getWalletDashboard();
      if (dashboardResponse.data != null) {
        final dashboardData = dashboardResponse.data!;

        // Attempt to fetch first page of transactions from ApiUrls.transactionList
        try {
          final txResponse = await _walletRepository.getTransactionList(
            page: 1,
            size: 10,
          );
          final transactions = txResponse.data.isNotEmpty
              ? txResponse.data
              : dashboardData.recentTransactions;

          emit(WalletLoaded(
            data: dashboardData,
            transactions: transactions,
            currentPage: 1,
            pageSize: 10,
            hasReachedMax: txResponse.data.length < 10,
            isLoadingMore: false,
          ));
        } catch (_) {
          // If transaction list API is unreachable, gracefully fallback to dashboard's recentTransactions
          emit(WalletLoaded(
            data: dashboardData,
            transactions: dashboardData.recentTransactions,
            currentPage: 1,
            pageSize: 10,
            hasReachedMax: dashboardData.recentTransactions.length < 10,
            isLoadingMore: false,
          ));
        }
      } else {
        if (cached != null) {
          emit(WalletLoaded(data: cached));
        } else {
          emit(WalletError(
            message: dashboardResponse.message ?? 'Failed to load wallet dashboard',
            cachedData: cached,
          ));
        }
      }
    } on AppExceptionHandler catch (e) {
      if (cached != null) {
        emit(WalletLoaded(data: cached));
      } else {
        emit(WalletError(
          message: e.exMsg,
          cachedData: cached,
        ));
      }
    } catch (e) {
      if (cached != null) {
        emit(WalletLoaded(data: cached));
      } else {
        emit(WalletError(
          message: e.toString(),
          cachedData: cached,
        ));
      }
    }
  }

  Future<void> _onFetchTransactions(
    FetchTransactionsEvent event,
    Emitter<WalletState> emit,
  ) async {
    if (state is! WalletLoaded) return;
    final currentState = state as WalletLoaded;

    try {
      final txResponse = await _walletRepository.getTransactionList(
        page: event.page,
        size: event.size,
      );

      final newItems = txResponse.data;
      final updatedList = event.isRefresh || event.page <= 1
          ? (newItems.isNotEmpty ? newItems : currentState.transactions)
          : [...currentState.transactions, ...newItems];

      emit(currentState.copyWith(
        transactions: updatedList,
        currentPage: event.page,
        pageSize: event.size,
        hasReachedMax: newItems.length < event.size,
        isLoadingMore: false,
      ));
    } catch (_) {
      // Preserve current loaded state on background refresh error
    }
  }

  Future<void> _onLoadMoreTransactions(
    LoadMoreTransactionsEvent event,
    Emitter<WalletState> emit,
  ) async {
    if (state is! WalletLoaded) return;
    final currentState = state as WalletLoaded;

    // Do nothing if already loading more or has reached the end
    if (currentState.isLoadingMore || currentState.hasReachedMax) return;

    emit(currentState.copyWith(isLoadingMore: true));

    final nextPage = currentState.currentPage + 1;

    try {
      final txResponse = await _walletRepository.getTransactionList(
        page: nextPage,
        size: event.size,
      );

      final newItems = txResponse.data;
      final existingIds = currentState.transactions.map((e) => e.id).toSet();
      final deduplicatedNewItems =
          newItems.where((e) => !existingIds.contains(e.id)).toList();

      final updatedList = [
        ...currentState.transactions,
        ...deduplicatedNewItems,
      ];

      emit(currentState.copyWith(
        transactions: updatedList,
        currentPage: nextPage,
        pageSize: event.size,
        hasReachedMax: newItems.length < event.size,
        isLoadingMore: false,
      ));
    } catch (_) {
      emit(currentState.copyWith(isLoadingMore: false));
    }
  }
}
