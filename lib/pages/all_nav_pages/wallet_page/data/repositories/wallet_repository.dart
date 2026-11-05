import 'package:margnetra_super_app/core/app_services/api_services/api_urls.dart';
import 'package:margnetra_super_app/core/app_services/api_services/data_provider.dart';
import 'package:margnetra_super_app/core/app_services/local_storage/shared_pref_service.dart';
import 'package:margnetra_super_app/pages/all_nav_pages/wallet_page/data/models/models.dart';

abstract class IWalletRepository {
  Future<WalletDashboardResponseModel> getWalletDashboard();
  WalletDashboardDataModel? getCachedWalletDashboard();
  Future<TransactionListResponseModel> getTransactionList({
    int page = 1,
    int size = 10,
  });
}

class WalletRepository implements IWalletRepository {
  final DataProvider _dataProvider;
  final SharedPrefService _prefService;

  WalletRepository({
    DataProvider? dataProvider,
    SharedPrefService? prefService,
  })  : _dataProvider = dataProvider ?? DataProvider(),
        _prefService = prefService ?? SharedPrefService.instance;

  @override
  Future<WalletDashboardResponseModel> getWalletDashboard() async {
    final response = await _dataProvider.get(ApiUrls.walletDashboard);

    final map =
        response is Map<String, dynamic> ? response : <String, dynamic>{};
    final result = WalletDashboardResponseModel.fromJson(map);

    // Cache locally for offline viewing and instant startup loading
    if (result.data != null) {
      await _prefService.saveCachedWalletDashboard(result.data!.toJson());
    }

    return result;
  }

  @override
  Future<TransactionListResponseModel> getTransactionList({
    int page = 1,
    int size = 10,
  }) async {
    final endpoint = ApiUrls.transactionList(page: page, size: size);
    final response = await _dataProvider.get(endpoint);

    final map =
        response is Map<String, dynamic> ? response : <String, dynamic>{};
    var result = TransactionListResponseModel.fromJson(map);

    // If page 1 returned empty data, check if backend is 0-indexed (e.g. Spring Data page=0)
    if (result.data.isEmpty && page == 1) {
      try {
        final zeroUrl = ApiUrls.transactionList(page: 0, size: size);
        final zeroResp = await _dataProvider.get(zeroUrl);
        if (zeroResp is Map<String, dynamic>) {
          final zeroResult = TransactionListResponseModel.fromJson(zeroResp);
          if (zeroResult.data.isNotEmpty) {
            return zeroResult;
          }
        }
      } catch (_) {}
    }

    return result;
  }

  @override
  WalletDashboardDataModel? getCachedWalletDashboard() {
    final cachedMap = _prefService.getCachedWalletDashboard();
    if (cachedMap == null || cachedMap.isEmpty) return null;
    try {
      return WalletDashboardDataModel.fromJson(cachedMap);
    } catch (_) {
      return null;
    }
  }
}
