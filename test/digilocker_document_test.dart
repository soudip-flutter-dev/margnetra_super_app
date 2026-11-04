import 'package:flutter_test/flutter_test.dart';
import 'package:margnetra_super_app/core/app_services/local_storage/shared_pref_service.dart';
import 'package:margnetra_super_app/pages/all_nav_pages/digilocker_page/data/models/models.dart';
import 'package:margnetra_super_app/pages/all_nav_pages/digilocker_page/data/repositories/document_repository.dart';
import 'package:margnetra_super_app/pages/all_nav_pages/digilocker_page/logic/blocs/document_bloc/document_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockDocumentRepository implements IDocumentRepository {
  List<VehicleDocumentModel>? cached;
  bool shouldFail = false;
  bool shouldUploadFail = false;

  final sampleResponse = const VehicleDocumentsResponseModel(
    success: true,
    message: "User registered successfully",
    data: [
      VehicleDocumentModel(
        id: "3fa85f64-5717-4562-b3fc-2c963f66afa6",
        documentType: "RC",
        title: "Registration Certificate",
        documentNumber: "MH12AB1234",
        status: "VALID",
        statusText: "Valid",
        expiryDate: "2026-11-04",
        formattedExpiry: "04 Nov 2026",
        daysUntilExpiry: 120,
        fileUrl: "https://example.com/rc.pdf",
        expiringSoon: false,
        verified: true,
      ),
      VehicleDocumentModel(
        id: "4fa85f64-5717-4562-b3fc-2c963f66afa7",
        documentType: "PUCC",
        title: "Pollution Certificate",
        documentNumber: "PUC998811",
        status: "EXPIRING_SOON",
        statusText: "Expires in 10 days",
        expiryDate: "2026-11-14",
        formattedExpiry: "14 Nov 2026",
        daysUntilExpiry: 10,
        fileUrl: "https://example.com/puc.pdf",
        expiringSoon: true,
        verified: true,
      ),
    ],
  );

  @override
  Future<VehicleDocumentsResponseModel> getVehicleDocuments({
    String? vehicleId,
  }) async {
    if (shouldFail) {
      throw Exception('Failed to fetch documents');
    }
    return sampleResponse;
  }

  @override
  Future<VehicleDocumentUploadResponseModel> uploadVehicleDocument(
    VehicleDocumentUploadRequestModel request,
  ) async {
    if (shouldUploadFail) {
      throw Exception('Network error during upload');
    }
    return VehicleDocumentUploadResponseModel(
      success: true,
      message: "User registered successfully",
      data: VehicleDocumentModel(
        id: "new-upload-id-1234",
        documentType: request.documentType,
        title: "${request.documentType} Document",
        documentNumber: request.documentNumber,
        status: "VALID",
        statusText: "Valid",
        expiryDate: request.expiryDate,
        formattedExpiry: request.expiryDate,
        daysUntilExpiry: 180,
        fileUrl: request.fileUrl,
        expiringSoon: false,
        verified: true,
      ),
    );
  }

  @override
  List<VehicleDocumentModel>? getCachedDocuments() => cached;
}

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await SharedPrefService.init();
  });

  group('VehicleDocument Models Tests', () {
    test('Parses exact user sample JSON response correctly', () {
      final sampleJson = {
        "success": true,
        "message": "User registered successfully",
        "data": [
          {
            "id": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
            "documentType": "RC",
            "title": "Registration Certificate",
            "documentNumber": "MH12AB1234",
            "status": "VALID",
            "statusText": "Valid",
            "expiryDate": "2026-11-04",
            "formattedExpiry": "04 Nov 2026",
            "daysUntilExpiry": 0,
            "fileUrl": "https://example.com/rc.pdf",
            "expiringSoon": true,
            "verified": true,
          }
        ],
      };

      final responseModel =
          VehicleDocumentsResponseModel.fromJson(sampleJson);

      expect(responseModel.success, isTrue);
      expect(responseModel.message, "User registered successfully");
      expect(responseModel.data.length, 1);

      final doc = responseModel.data.first;
      expect(doc.id, "3fa85f64-5717-4562-b3fc-2c963f66afa6");
      expect(doc.documentType, "RC");
      expect(doc.title, "Registration Certificate");
      expect(doc.documentNumber, "MH12AB1234");
      expect(doc.status, "VALID");
      expect(doc.statusText, "Valid");
      expect(doc.expiryDate, "2026-11-04");
      expect(doc.formattedExpiry, "04 Nov 2026");
      expect(doc.daysUntilExpiry, 0);
      expect(doc.fileUrl, "https://example.com/rc.pdf");
      expect(doc.expiringSoon, isTrue);
      expect(doc.verified, isTrue);

      final serialized = responseModel.toJson();
      expect(serialized['success'], isTrue);
      expect(serialized['data'], isA<List>());
      expect((serialized['data'] as List).first['documentType'], 'RC');
    });

    test('Helper getters compute validity and expiry states correctly', () {
      const validDoc = VehicleDocumentModel(
        id: "1",
        documentType: "RC",
        title: "RC",
        documentNumber: "123",
        status: "VALID",
        statusText: "Valid",
        expiryDate: "2027-01-01",
        formattedExpiry: "01 Jan 2027",
        daysUntilExpiry: 400,
        fileUrl: "",
        expiringSoon: false,
        verified: true,
      );

      expect(validDoc.isValid, isTrue);
      expect(validDoc.isExpired, isFalse);
      expect(validDoc.isExpiringSoon, isFalse);

      const expiringDoc = VehicleDocumentModel(
        id: "2",
        documentType: "PUCC",
        title: "PUCC",
        documentNumber: "456",
        status: "EXPIRING_SOON",
        statusText: "Expires soon",
        expiryDate: "2026-11-10",
        formattedExpiry: "10 Nov 2026",
        daysUntilExpiry: 6,
        fileUrl: "",
        expiringSoon: true,
        verified: false,
      );

      expect(expiringDoc.isExpiringSoon, isTrue);
      expect(expiringDoc.isValid, isFalse);
    });
  });

  group('VehicleDocumentUpload Models Tests', () {
    test('Serializes VehicleDocumentUploadRequestModel to exact user request JSON', () {
      const request = VehicleDocumentUploadRequestModel(
        vehicleId: "3fa85f64-5717-4562-b3fc-2c963f66afa6",
        documentType: "PUCC",
        documentNumber: "PUCC-MH12-987654",
        expiryDate: "2026-08-12",
        fileUrl: "https://cdn.margentra.com/docs/pucc-123.jpg",
      );

      final json = request.toJson();
      expect(json['vehicleId'], "3fa85f64-5717-4562-b3fc-2c963f66afa6");
      expect(json['documentType'], "PUCC");
      expect(json['documentNumber'], "PUCC-MH12-987654");
      expect(json['expiryDate'], "2026-08-12");
      expect(json['fileUrl'], "https://cdn.margentra.com/docs/pucc-123.jpg");

      final fromJson = VehicleDocumentUploadRequestModel.fromJson(json);
      expect(fromJson, request);
    });

    test('Parses VehicleDocumentUploadResponseModel from exact user response JSON', () {
      final responseJson = {
        "success": true,
        "message": "User registered successfully",
        "data": {
          "id": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
          "documentType": "RC",
          "title": "string",
          "documentNumber": "string",
          "status": "VALID",
          "statusText": "string",
          "expiryDate": "2026-11-04",
          "formattedExpiry": "string",
          "daysUntilExpiry": 0,
          "fileUrl": "string",
          "expiringSoon": true,
          "verified": true,
        }
      };

      final response = VehicleDocumentUploadResponseModel.fromJson(responseJson);
      expect(response.success, isTrue);
      expect(response.message, "User registered successfully");
      expect(response.data, isNotNull);
      expect(response.data!.id, "3fa85f64-5717-4562-b3fc-2c963f66afa6");
      expect(response.data!.documentType, "RC");
      expect(response.data!.status, "VALID");
      expect(response.data!.verified, isTrue);

      final serialized = response.toJson();
      expect(serialized['success'], isTrue);
      expect(serialized['data']['documentType'], 'RC');
    });
  });

  group('DocumentBloc Tests', () {
    test('Loads documents successfully and emits DocumentLoaded', () async {
      final mockRepo = MockDocumentRepository();
      final bloc = DocumentBloc(documentRepository: mockRepo);

      expect(bloc.state, isA<DocumentInitial>());

      bloc.add(const LoadVehicleDocumentsEvent());

      await expectLater(
        bloc.stream,
        emitsInOrder([
          isA<DocumentLoading>(),
          predicate<DocumentLoaded>((state) {
            return state.documents.length == 2 &&
                state.displayedDocuments.length == 2 &&
                state.documents.first.documentType == "RC";
          }),
        ]),
      );

      bloc.close();
    });

    test('Filters documents by document type', () async {
      final mockRepo = MockDocumentRepository();
      final bloc = DocumentBloc(documentRepository: mockRepo);

      bloc.add(const LoadVehicleDocumentsEvent());
      await bloc.stream.firstWhere((s) => s is DocumentLoaded);

      bloc.add(const FilterDocumentsByTypeEvent(documentType: "PUCC"));

      await expectLater(
        bloc.stream,
        emits(predicate<DocumentLoaded>((state) {
          return state.selectedType == "PUCC" &&
              state.displayedDocuments.length == 1 &&
              state.displayedDocuments.first.documentType == "PUCC";
        })),
      );

      bloc.close();
    });

    test('Searches documents by query', () async {
      final mockRepo = MockDocumentRepository();
      final bloc = DocumentBloc(documentRepository: mockRepo);

      bloc.add(const LoadVehicleDocumentsEvent());
      await bloc.stream.firstWhere((s) => s is DocumentLoaded);

      bloc.add(const SearchDocumentsEvent(query: "MH12"));

      await expectLater(
        bloc.stream,
        emits(predicate<DocumentLoaded>((state) {
          return state.displayedDocuments.length == 1 &&
              state.displayedDocuments.first.documentNumber == "MH12AB1234";
        })),
      );

      bloc.close();
    });

    test('Emits DocumentError when repository fails', () async {
      final mockRepo = MockDocumentRepository()..shouldFail = true;
      final bloc = DocumentBloc(documentRepository: mockRepo);

      bloc.add(const LoadVehicleDocumentsEvent());

      await expectLater(
        bloc.stream,
        emitsInOrder([
          isA<DocumentLoading>(),
          predicate<DocumentError>((state) {
            return state.message.contains('Failed to fetch documents');
          }),
        ]),
      );

      bloc.close();
    });

    test('Uploads document and prepends newly uploaded document to list', () async {
      final mockRepo = MockDocumentRepository();
      final bloc = DocumentBloc(documentRepository: mockRepo);

      bloc.add(const LoadVehicleDocumentsEvent());
      await bloc.stream.firstWhere((s) => s is DocumentLoaded);

      bool callbackSuccess = false;
      bloc.add(
        UploadVehicleDocumentEvent(
          request: const VehicleDocumentUploadRequestModel(
            vehicleId: "3fa85f64-5717-4562-b3fc-2c963f66afa6",
            documentType: "PUCC",
            documentNumber: "PUCC-MH12-987654",
            expiryDate: "2026-08-12",
            fileUrl: "https://cdn.margentra.com/docs/pucc-123.jpg",
          ),
          onSuccess: (doc) {
            callbackSuccess = true;
          },
        ),
      );

      await expectLater(
        bloc.stream,
        emitsInOrder([
          // 1. isUploading = true
          predicate<DocumentLoaded>((state) => state.isUploading == true),
          // 2. uploaded, isUploading = false, documents count incremented
          predicate<DocumentLoaded>((state) {
            return state.isUploading == false &&
                state.documents.length == 3 &&
                state.documents.first.id == "new-upload-id-1234" &&
                state.documents.first.documentType == "PUCC";
          }),
        ]),
      );

      expect(callbackSuccess, isTrue);
      bloc.close();
    });

    test('Handles upload failure and triggers onError callback', () async {
      final mockRepo = MockDocumentRepository()..shouldUploadFail = true;
      final bloc = DocumentBloc(documentRepository: mockRepo);

      bloc.add(const LoadVehicleDocumentsEvent());
      await bloc.stream.firstWhere((s) => s is DocumentLoaded);

      String? errorReceived;
      bloc.add(
        UploadVehicleDocumentEvent(
          request: const VehicleDocumentUploadRequestModel(
            vehicleId: "3fa85f64-5717-4562-b3fc-2c963f66afa6",
            documentType: "PUCC",
            documentNumber: "PUCC-MH12-987654",
            expiryDate: "2026-08-12",
            fileUrl: "https://cdn.margentra.com/docs/pucc-123.jpg",
          ),
          onError: (err) {
            errorReceived = err;
          },
        ),
      );

      await expectLater(
        bloc.stream,
        emitsInOrder([
          predicate<DocumentLoaded>((state) => state.isUploading == true),
          predicate<DocumentLoaded>((state) => state.isUploading == false),
        ]),
      );

      expect(errorReceived, isNotNull);
      expect(errorReceived, contains('Network error during upload'));
      bloc.close();
    });
  });
}
