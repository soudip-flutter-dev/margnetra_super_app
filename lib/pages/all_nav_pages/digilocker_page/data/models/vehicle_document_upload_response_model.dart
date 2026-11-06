import 'package:equatable/equatable.dart';
import 'vehicle_document_model.dart';

/// Response model for document upload/registration endpoint.
class VehicleDocumentUploadResponseModel extends Equatable {
  final bool? success;
  final String? message;
  final VehicleDocumentModel? data;

  const VehicleDocumentUploadResponseModel({
    this.success,
    this.message,
    this.data,
  });

  factory VehicleDocumentUploadResponseModel.fromJson(
      Map<String, dynamic> json) {
    return VehicleDocumentUploadResponseModel(
      success: json['success'] as bool?,
      message: json['message'] as String?,
      data: json['data'] is Map<String, dynamic>
          ? VehicleDocumentModel.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      if (data != null) 'data': data!.toJson(),
    };
  }

  VehicleDocumentUploadResponseModel copyWith({
    bool? success,
    String? message,
    VehicleDocumentModel? data,
  }) {
    return VehicleDocumentUploadResponseModel(
      success: success ?? this.success,
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }

  // ── Convenience getters directly matching response fields ───────────────────
  String get id => data?.id ?? '';
  String get documentType => data?.documentType ?? '';
  String get title => data?.title ?? '';
  String get documentNumber => data?.documentNumber ?? '';
  String get status => data?.status ?? 'VALID';
  String get statusText => data?.statusText ?? '';
  String get expiryDate => data?.expiryDate ?? '';
  String get formattedExpiry => data?.formattedExpiry ?? '';
  int get daysUntilExpiry => data?.daysUntilExpiry ?? 0;
  String get fileUrl => data?.fileUrl ?? '';
  bool get expiringSoon => data?.expiringSoon ?? false;
  bool get verified => data?.verified ?? false;

  @override
  List<Object?> get props => [success, message, data];
}
