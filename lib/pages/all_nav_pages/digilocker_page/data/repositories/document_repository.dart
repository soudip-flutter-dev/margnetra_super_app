import 'package:margnetra_super_app/core/app_services/api_services/api_urls.dart';
import 'package:margnetra_super_app/core/app_services/api_services/data_provider.dart';
import 'package:margnetra_super_app/core/app_services/local_storage/shared_pref_service.dart';
import 'package:margnetra_super_app/pages/all_nav_pages/digilocker_page/data/models/models.dart';

abstract class IDocumentRepository {
  Future<VehicleDocumentsResponseModel> getVehicleDocuments({String? vehicleId});
  Future<VehicleDocumentUploadResponseModel> uploadVehicleDocument(
    VehicleDocumentUploadRequestModel request,
  );
  List<VehicleDocumentModel>? getCachedDocuments();
}

class DocumentRepository implements IDocumentRepository {
  final DataProvider _dataProvider;
  final SharedPrefService _prefService;

  DocumentRepository({
    DataProvider? dataProvider,
    SharedPrefService? prefService,
  })  : _dataProvider = dataProvider ?? DataProvider(),
        _prefService = prefService ?? SharedPrefService.instance;

  @override
  Future<VehicleDocumentsResponseModel> getVehicleDocuments({
    String? vehicleId,
  }) async {
    final queryParams = vehicleId != null && vehicleId.isNotEmpty
        ? {'vehicleId': vehicleId}
        : null;

    final response = await _dataProvider.get(
      ApiUrls.vehicleDocuments,
      queryParameters: queryParams,
    );

    final map =
        response is Map<String, dynamic> ? response : <String, dynamic>{};
    final result = VehicleDocumentsResponseModel.fromJson(map);

    // Cache documents locally for offline viewing and instant startup loading
    if (result.data.isNotEmpty) {
      await _prefService.saveCachedDocuments(
        result.data.map((doc) => doc.toJson()).toList(),
      );
    }

    return result;
  }

  @override
  Future<VehicleDocumentUploadResponseModel> uploadVehicleDocument(
    VehicleDocumentUploadRequestModel request,
  ) async {
    final response = await _dataProvider.post(
      ApiUrls.vehicleDocuments,
      data: request.toJson(),
    );

    final map =
        response is Map<String, dynamic> ? response : <String, dynamic>{};
    final result = VehicleDocumentUploadResponseModel.fromJson(map);

    // If successfully uploaded and returned data is present, update local cache
    if (result.data != null) {
      final currentDocs = getCachedDocuments() ?? [];
      final updatedDocs = [result.data!, ...currentDocs];
      await _prefService.saveCachedDocuments(
        updatedDocs.map((doc) => doc.toJson()).toList(),
      );
    }

    return result;
  }

  @override
  List<VehicleDocumentModel>? getCachedDocuments() {
    final rawList = _prefService.getCachedDocuments();
    if (rawList == null || rawList.isEmpty) return null;
    return rawList.map((e) => VehicleDocumentModel.fromJson(e)).toList();
  }
}
