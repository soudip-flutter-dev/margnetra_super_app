import 'package:equatable/equatable.dart';
import 'package:margnetra_super_app/pages/all_nav_pages/digilocker_page/data/models/models.dart';

abstract class DocumentEvent extends Equatable {
  const DocumentEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load vehicle documents from server with cache-first support.
class LoadVehicleDocumentsEvent extends DocumentEvent {
  final bool isRefresh;
  final String? vehicleId;

  const LoadVehicleDocumentsEvent({
    this.isRefresh = false,
    this.vehicleId,
  });

  @override
  List<Object?> get props => [isRefresh, vehicleId];
}

/// Event to filter displayed documents by documentType (e.g. 'RC', 'INSURANCE', 'PUCC', 'DL', or null for All).
class FilterDocumentsByTypeEvent extends DocumentEvent {
  final String? documentType;

  const FilterDocumentsByTypeEvent({this.documentType});

  @override
  List<Object?> get props => [documentType];
}

/// Event to search documents by keyword in title, document number, or type.
class SearchDocumentsEvent extends DocumentEvent {
  final String query;

  const SearchDocumentsEvent({required this.query});

  @override
  List<Object?> get props => [query];
}

/// Event to upload/register a new vehicle document via POST API.
class UploadVehicleDocumentEvent extends DocumentEvent {
  final VehicleDocumentUploadRequestModel request;
  final void Function(VehicleDocumentModel uploadedDocument)? onSuccess;
  final void Function(String errorMessage)? onError;

  const UploadVehicleDocumentEvent({
    required this.request,
    this.onSuccess,
    this.onError,
  });

  @override
  List<Object?> get props => [request];
}
