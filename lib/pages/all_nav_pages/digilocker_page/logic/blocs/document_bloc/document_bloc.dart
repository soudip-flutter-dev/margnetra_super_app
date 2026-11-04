import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:margnetra_super_app/core/app_exception_handler/app_exception_handler.dart';
import 'package:margnetra_super_app/pages/all_nav_pages/digilocker_page/data/models/vehicle_document_model.dart';
import 'package:margnetra_super_app/pages/all_nav_pages/digilocker_page/data/repositories/document_repository.dart';
import 'package:margnetra_super_app/pages/all_nav_pages/digilocker_page/logic/blocs/document_bloc/document_event.dart';
import 'package:margnetra_super_app/pages/all_nav_pages/digilocker_page/logic/blocs/document_bloc/document_state.dart';

export 'document_event.dart';
export 'document_state.dart';

class DocumentBloc extends Bloc<DocumentEvent, DocumentState> {
  final IDocumentRepository _documentRepository;

  DocumentBloc({IDocumentRepository? documentRepository})
      : _documentRepository = documentRepository ?? DocumentRepository(),
        super(const DocumentInitial()) {
    on<LoadVehicleDocumentsEvent>(_onLoadDocuments);
    on<FilterDocumentsByTypeEvent>(_onFilterByType);
    on<SearchDocumentsEvent>(_onSearch);
    on<UploadVehicleDocumentEvent>(_onUploadDocument);
  }

  Future<void> _onLoadDocuments(
    LoadVehicleDocumentsEvent event,
    Emitter<DocumentState> emit,
  ) async {
    final cached = _documentRepository.getCachedDocuments();

    // Cache-first: show cached docs immediately while fetching fresh data
    if (cached != null && cached.isNotEmpty && !event.isRefresh) {
      emit(DocumentLoading(cachedDocuments: cached));
    } else {
      emit(const DocumentLoading());
    }

    try {
      final response = await _documentRepository.getVehicleDocuments(
        vehicleId: event.vehicleId,
      );

      final documents = response.data;
      emit(DocumentLoaded(
        documents: documents,
        displayedDocuments: documents,
      ));
    } on AppExceptionHandler catch (e) {
      emit(DocumentError(
        message: e.exMsg,
        cachedDocuments: cached,
      ));
    } catch (e) {
      emit(DocumentError(
        message: e.toString(),
        cachedDocuments: cached,
      ));
    }
  }

  void _onFilterByType(
    FilterDocumentsByTypeEvent event,
    Emitter<DocumentState> emit,
  ) {
    if (state is! DocumentLoaded) return;
    final currentState = state as DocumentLoaded;

    final filtered = _applyFilterAndSearch(
      documents: currentState.documents,
      selectedType: event.documentType,
      searchQuery: currentState.searchQuery,
    );

    emit(currentState.copyWith(
      displayedDocuments: filtered,
      selectedType: event.documentType,
      clearType: event.documentType == null,
    ));
  }

  void _onSearch(
    SearchDocumentsEvent event,
    Emitter<DocumentState> emit,
  ) {
    if (state is! DocumentLoaded) return;
    final currentState = state as DocumentLoaded;

    final filtered = _applyFilterAndSearch(
      documents: currentState.documents,
      selectedType: currentState.selectedType,
      searchQuery: event.query,
    );

    emit(currentState.copyWith(
      displayedDocuments: filtered,
      searchQuery: event.query,
    ));
  }

  Future<void> _onUploadDocument(
    UploadVehicleDocumentEvent event,
    Emitter<DocumentState> emit,
  ) async {
    final currentState = state;
    if (currentState is DocumentLoaded) {
      emit(currentState.copyWith(isUploading: true));
    }

    try {
      final response =
          await _documentRepository.uploadVehicleDocument(event.request);
      final newDoc = response.data;

      if (newDoc != null) {
        if (state is DocumentLoaded) {
          final loaded = state as DocumentLoaded;
          final updatedDocs = [
            newDoc,
            ...loaded.documents.where((d) => d.id != newDoc.id),
          ];
          final updatedDisplayed = _applyFilterAndSearch(
            documents: updatedDocs,
            selectedType: loaded.selectedType,
            searchQuery: loaded.searchQuery,
          );
          emit(loaded.copyWith(
            documents: updatedDocs,
            displayedDocuments: updatedDisplayed,
            isUploading: false,
          ));
        } else {
          emit(DocumentLoaded(
            documents: [newDoc],
            displayedDocuments: [newDoc],
            isUploading: false,
          ));
        }

        event.onSuccess?.call(newDoc);
      } else {
        if (state is DocumentLoaded) {
          emit((state as DocumentLoaded).copyWith(isUploading: false));
        }
        event.onError?.call(response.message ?? 'Failed to upload document');
      }
    } on AppExceptionHandler catch (e) {
      if (state is DocumentLoaded) {
        emit((state as DocumentLoaded).copyWith(isUploading: false));
      }
      event.onError?.call(e.exMsg);
    } catch (e) {
      if (state is DocumentLoaded) {
        emit((state as DocumentLoaded).copyWith(isUploading: false));
      }
      event.onError?.call(e.toString());
    }
  }

  List<VehicleDocumentModel> _applyFilterAndSearch({
    required List<VehicleDocumentModel> documents,
    String? selectedType,
    String searchQuery = '',
  }) {
    return documents.where((doc) {
      // 1. Check document type filter
      if (selectedType != null && selectedType.isNotEmpty) {
        if (doc.documentType.toUpperCase() != selectedType.toUpperCase()) {
          return false;
        }
      }

      // 2. Check search keyword
      final q = searchQuery.trim().toLowerCase();
      if (q.isNotEmpty) {
        final matchesTitle = doc.title.toLowerCase().contains(q);
        final matchesNumber = doc.documentNumber.toLowerCase().contains(q);
        final matchesType = doc.documentType.toLowerCase().contains(q);
        final matchesStatus = doc.statusText.toLowerCase().contains(q);
        return matchesTitle || matchesNumber || matchesType || matchesStatus;
      }

      return true;
    }).toList();
  }
}
