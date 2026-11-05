import 'package:flutter_test/flutter_test.dart';
import 'package:margnetra_super_app/core/app_services/api_services/api_urls.dart';
import 'package:margnetra_super_app/core/app_services/local_storage/shared_pref_service.dart';
import 'package:margnetra_super_app/pages/all_nav_pages/wallet_page/data/models/models.dart';
import 'package:margnetra_super_app/pages/all_nav_pages/wallet_page/data/repositories/wallet_repository.dart';
import 'package:margnetra_super_app/pages/all_nav_pages/wallet_page/logic/blocs/wallet_bloc/wallet_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockWalletRepository implements IWalletRepository {
  WalletDashboardDataModel? cached;
  bool shouldFail = false;
  bool shouldTxFail = false;
  List<WalletTransactionModel> txList = const [
    WalletTransactionModel(
      id: "a1b2c3d4-e5f6-7a8b-9c0d-1e2f3a4b5c6d",
      transactionType: "CREDIT",
      category: "TRIP_REWARD",
      amountMgc: 50,
      balanceType: "AVAILABLE",
      status: "SUCCESS",
      referenceId: "FTG-RECHARGE-99214",
      description: "Daily safe driving streak bonus",
      createdAt: "2026-10-30T10:00:00Z",
    ),
  ];

  final sampleResponse = const WalletDashboardResponseModel(
    success: true,
    message: "User registered successfully",
    data: WalletDashboardDataModel(
      balance: WalletBalanceModel(
        availableMgc: 1250,
        provisionalMgc: 45,
        heldMgc: 0,
        totalMgc: 1295,
        currency: "MGC",
      ),
      civilScore: 812,
      civilRating: "GOOD",
      activeStreakProtections: 1,
      recentTransactions: [
        WalletTransactionModel(
          id: "a1b2c3d4-e5f6-7a8b-9c0d-1e2f3a4b5c6d",
          transactionType: "CREDIT",
          category: "TRIP_REWARD",
          amountMgc: 50,
          balanceType: "AVAILABLE",
          status: "SUCCESS",
          referenceId: "FTG-RECHARGE-99214",
          description: "Daily safe driving streak bonus",
          createdAt: "2026-10-30T10:00:00Z",
        ),
      ],
    ),
  );

  @override
  Future<WalletDashboardResponseModel> getWalletDashboard() async {
    if (shouldFail) {
      throw Exception('Failed to fetch wallet dashboard');
    }
    return sampleResponse;
  }

  @override
  Future<TransactionListResponseModel> getTransactionList({
    int page = 1,
    int size = 10,
  }) async {
    if (shouldTxFail) {
      throw Exception('Failed to fetch transaction list');
    }
    return TransactionListResponseModel(
      success: true,
      message: "User registered successfully",
      data: txList,
    );
  }

  @override
  WalletDashboardDataModel? getCachedWalletDashboard() => cached;
}

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await SharedPrefService.init();
  });

  group('Wallet Models Tests', () {
    test('Parses exact user sample JSON response correctly', () {
      final sampleJson = {
        "success": true,
        "message": "User registered successfully",
        "data": {
          "balance": {
            "availableMgc": 1250,
            "provisionalMgc": 45,
            "heldMgc": 0,
            "totalMgc": 1295,
            "currency": "MGC"
          },
          "civilScore": 812,
          "civilRating": "GOOD",
          "activeStreakProtections": 1,
          "recentTransactions": [
            {
              "id": "a1b2c3d4-e5f6-7a8b-9c0d-1e2f3a4b5c6d",
              "transactionType": "CREDIT",
              "category": "TRIP_REWARD",
              "amountMgc": 50,
              "balanceType": "AVAILABLE",
              "status": "SUCCESS",
              "referenceId": "FTG-RECHARGE-99214",
              "description": "Daily safe driving streak bonus",
              "createdAt": "2026-10-30T10:00:00Z"
            }
          ]
        }
      };

      final responseModel = WalletDashboardResponseModel.fromJson(sampleJson);

      expect(responseModel.success, isTrue);
      expect(responseModel.message, "User registered successfully");
      expect(responseModel.data, isNotNull);

      final data = responseModel.data!;
      expect(data.balance.availableMgc, 1250);
      expect(data.balance.provisionalMgc, 45);
      expect(data.balance.heldMgc, 0);
      expect(data.balance.totalMgc, 1295);
      expect(data.balance.currency, "MGC");

      expect(data.civilScore, 812);
      expect(data.civilRating, "GOOD");
      expect(data.activeStreakProtections, 1);

      expect(data.recentTransactions.length, 1);
      final tx = data.recentTransactions.first;
      expect(tx.id, "a1b2c3d4-e5f6-7a8b-9c0d-1e2f3a4b5c6d");
      expect(tx.transactionType, "CREDIT");
      expect(tx.category, "TRIP_REWARD");
      expect(tx.amountMgc, 50);
      expect(tx.balanceType, "AVAILABLE");
      expect(tx.status, "SUCCESS");
      expect(tx.referenceId, "FTG-RECHARGE-99214");
      expect(tx.description, "Daily safe driving streak bonus");
      expect(tx.createdAt, "2026-10-30T10:00:00Z");
      expect(tx.isCredit, isTrue);
      expect(tx.formattedAmount, "+50 MGC");

      final serialized = responseModel.toJson();
      expect(serialized['success'], isTrue);
      expect(serialized['data'], isA<Map<String, dynamic>>());
      expect(serialized['data']['balance']['totalMgc'], 1295);
    });

    test('WalletTransactionModel debit amount formats with minus prefix', () {
      const debitTx = WalletTransactionModel(
        id: "tx-2",
        transactionType: "DEBIT",
        category: "FASTAG_RECHARGE",
        amountMgc: 100,
        balanceType: "AVAILABLE",
        status: "SUCCESS",
        referenceId: "REF-001",
        description: "FASTag recharge",
        createdAt: "2026-10-31T12:00:00Z",
      );

      expect(debitTx.isDebit, isTrue);
      expect(debitTx.isCredit, isFalse);
      expect(debitTx.formattedAmount, "-100 MGC");
    });

    test('TransactionListResponseModel parses exact transaction history response JSON', () {
      final sampleTxResponseJson = {
        "success": true,
        "message": "User registered successfully",
        "data": [
          {
            "id": "a1b2c3d4-e5f6-7a8b-9c0d-1e2f3a4b5c6d",
            "transactionType": "CREDIT",
            "category": "TRIP_REWARD",
            "amountMgc": 50,
            "balanceType": "AVAILABLE",
            "status": "SUCCESS",
            "referenceId": "FTG-RECHARGE-99214",
            "description": "Daily safe driving streak bonus",
            "createdAt": "2026-10-30T10:00:00Z"
          }
        ]
      };

      final response =
          TransactionListResponseModel.fromJson(sampleTxResponseJson);
      expect(response.success, isTrue);
      expect(response.message, "User registered successfully");
      expect(response.data.length, 1);
      expect(response.data.first.id, "a1b2c3d4-e5f6-7a8b-9c0d-1e2f3a4b5c6d");
      expect(response.data.first.category, "TRIP_REWARD");

      final serialized = response.toJson();
      expect(serialized['success'], isTrue);
      expect(serialized['data'], isA<List>());
    });

    test('TransactionPaginationParams generates correct query parameters and URL', () {
      const params = TransactionPaginationParams(page: 2, size: 10);
      final qp = params.toQueryParameters();
      expect(qp['page'], 2);
      expect(qp['size'], 10);
      expect(params.toUrl(), ApiUrls.transactionList(page: 2, size: 10));
      expect(ApiUrls.transactionList(page: 2, size: 10),
          '/api/wallet/transactions?page=2&size=10');
    });
  });

  group('WalletBloc Tests', () {
    test('Loads wallet dashboard successfully and emits WalletLoaded', () async {
      final mockRepo = MockWalletRepository();
      final bloc = WalletBloc(walletRepository: mockRepo);

      expect(bloc.state, isA<WalletInitial>());

      bloc.add(const LoadWalletDashboardEvent());

      await expectLater(
        bloc.stream,
        emitsInOrder([
          isA<WalletLoading>(),
          predicate<WalletLoaded>((state) {
            return state.data.balance.availableMgc == 1250 &&
                state.data.civilScore == 812 &&
                state.transactions.length == 1 &&
                state.currentPage == 1;
          }),
        ]),
      );

      bloc.close();
    });

    test('Emits cached data first if available, then updates with fresh data', () async {
      final cachedData = const WalletDashboardDataModel(
        balance: WalletBalanceModel(availableMgc: 1000, totalMgc: 1000),
        civilScore: 800,
      );

      final mockRepo = MockWalletRepository()..cached = cachedData;
      final bloc = WalletBloc(walletRepository: mockRepo);

      bloc.add(const LoadWalletDashboardEvent());

      await expectLater(
        bloc.stream,
        emitsInOrder([
          predicate<WalletLoading>((state) =>
              state.cachedData?.balance.availableMgc == 1000),
          predicate<WalletLoaded>((state) =>
              state.data.balance.availableMgc == 1250),
        ]),
      );

      bloc.close();
    });

    test('Emits WalletError when repository fails and no cache exists', () async {
      final mockRepo = MockWalletRepository()..shouldFail = true;
      final bloc = WalletBloc(walletRepository: mockRepo);

      bloc.add(const LoadWalletDashboardEvent());

      await expectLater(
        bloc.stream,
        emitsInOrder([
          isA<WalletLoading>(),
          predicate<WalletError>((state) {
            return state.message.contains('Failed to fetch wallet dashboard');
          }),
        ]),
      );

      bloc.close();
    });

    test('Handles LoadMoreTransactionsEvent pagination and appends items', () async {
      final mockRepo = MockWalletRepository();
      // Setup initial load with 10 items so hasReachedMax is false
      mockRepo.txList = List.generate(
        10,
        (i) => WalletTransactionModel(
          id: 'tx-page1-$i',
          transactionType: 'CREDIT',
          category: 'TRIP_REWARD',
          amountMgc: 10,
          balanceType: 'AVAILABLE',
          status: 'SUCCESS',
          referenceId: 'REF-1-$i',
          description: 'Reward $i',
          createdAt: '2026-10-30T10:00:00Z',
        ),
      );

      final bloc = WalletBloc(walletRepository: mockRepo);
      bloc.add(const LoadWalletDashboardEvent());
      await bloc.stream.firstWhere((s) => s is WalletLoaded);

      // Now set mockRepo to return page 2 items
      mockRepo.txList = [
        const WalletTransactionModel(
          id: 'tx-page2-1',
          transactionType: 'DEBIT',
          category: 'FASTAG_RECHARGE',
          amountMgc: 200,
          balanceType: 'AVAILABLE',
          status: 'SUCCESS',
          referenceId: 'REF-P2-1',
          description: 'FASTag recharge page 2',
          createdAt: '2026-10-31T10:00:00Z',
        ),
      ];

      bloc.add(const LoadMoreTransactionsEvent(size: 10));

      await expectLater(
        bloc.stream,
        emitsInOrder([
          predicate<WalletLoaded>((state) => state.isLoadingMore == true),
          predicate<WalletLoaded>((state) {
            return state.isLoadingMore == false &&
                state.currentPage == 2 &&
                state.transactions.length == 11 &&
                state.hasReachedMax == true; // because page 2 had 1 item < 10
          }),
        ]),
      );

      bloc.close();
    });
  });
}
