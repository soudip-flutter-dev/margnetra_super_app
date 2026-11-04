import 'package:equatable/equatable.dart';
import 'vehicle_document_model.dart';

/// Top-level response model for the vehicle documents endpoint.
class VehicleDocumentsResponseModel extends Equatable {
  final bool? success;
  final String? message;
  final List<VehicleDocumentModel> data;

  const VehicleDocumentsResponseModel({
    this.success,
    this.message,
    this.data = const [],
  });

  /// Factory constructor to parse envelope JSON safely.
  factory VehicleDocumentsResponseModel.fromJson(Map<String, dynamic> json) {
    List<VehicleDocumentModel> parsedData = [];

    if (json['data'] is List) {
      parsedData = (json['data'] as List)
          .whereType<Map<String, dynamic>>()
          .map((item) => VehicleDocumentModel.fromJson(item))
          .toList();
    } else if (json['data'] is Map<String, dynamic>) {
      // In case server returns a single document object instead of a list
      parsedData = [
        VehicleDocumentModel.fromJson(json['data'] as Map<String, dynamic>)
      ];
    }

    return VehicleDocumentsResponseModel(
      success: json['success'] as bool?,
      message: json['message'] as String?,
      data: parsedData,
    );
  }

  /// Converts the response model back to JSON.
  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data.map((doc) => doc.toJson()).toList(),
    };
  }

  @override
  List<Object?> get props => [success, message, data];
}

