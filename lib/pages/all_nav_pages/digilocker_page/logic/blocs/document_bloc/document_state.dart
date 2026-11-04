import 'package:equatable/equatable.dart';
import 'package:margnetra_super_app/pages/all_nav_pages/digilocker_page/data/models/vehicle_document_model.dart';

abstract class DocumentState extends Equatable {
  const DocumentState();

  @override
  List<Object?> get props => [];
}

/// Initial uninitialized state.
class DocumentInitial extends DocumentState {
  const DocumentInitial();
}

/// Loading state while documents are being fetched.
class DocumentLoading extends DocumentState {
  final List<VehicleDocumentModel>? cachedDocuments;

  const DocumentLoading({this.cachedDocuments});

  @override
  List<Object?> get props => [cachedDocuments];
}

/// Successfully loaded documents state with filtering and search support.
class DocumentLoaded extends DocumentState {
  final List<VehicleDocumentModel> documents;
  final List<VehicleDocumentModel> displayedDocuments;
  final String? selectedType;
  final String searchQuery;
  final bool isUploading;

  const DocumentLoaded({
    required this.documents,
    required this.displayedDocuments,
    this.selectedType,
    this.searchQuery = '',
    this.isUploading = false,
  });

  DocumentLoaded copyWith({
    List<VehicleDocumentModel>? documents,
    List<VehicleDocumentModel>? displayedDocuments,
    String? selectedType,
    String? searchQuery,
    bool? isUploading,
    bool clearType = false,
  }) {
    return DocumentLoaded(
      documents: documents ?? this.documents,
      displayedDocuments: displayedDocuments ?? this.displayedDocuments,
      selectedType: clearType ? null : (selectedType ?? this.selectedType),
      searchQuery: searchQuery ?? this.searchQuery,
      isUploading: isUploading ?? this.isUploading,
    );
  }

  @override
  List<Object?> get props => [
        documents,
        displayedDocuments,
        selectedType,
        searchQuery,
        isUploading,
      ];
}

/// Error state when fetching documents fails.
class DocumentError extends DocumentState {
  final String message;
  final List<VehicleDocumentModel>? cachedDocuments;

  const DocumentError({
    required this.message,
    this.cachedDocuments,
  });

  @override
  List<Object?> get props => [message, cachedDocuments];
}
