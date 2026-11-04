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

  @override
  List<Object?> get props => [success, message, data];
}

