import 'package:equatable/equatable.dart';

/// Request model for uploading/registering a vehicle document to DigiLocker.
class VehicleDocumentUploadRequestModel extends Equatable {
  final String vehicleId;
  final String documentType;
  final String documentNumber;
  final String expiryDate;
  final String fileUrl;

  const VehicleDocumentUploadRequestModel({
    required this.vehicleId,
    required this.documentType,
    required this.documentNumber,
    required this.expiryDate,
    required this.fileUrl,
  });

  factory VehicleDocumentUploadRequestModel.fromJson(Map<String, dynamic> json) {
    return VehicleDocumentUploadRequestModel(
      vehicleId: json['vehicleId']?.toString() ?? '',
      documentType: json['documentType']?.toString() ?? '',
      documentNumber: json['documentNumber']?.toString() ?? '',
      expiryDate: json['expiryDate']?.toString() ?? '',
      fileUrl: json['fileUrl']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'vehicleId': vehicleId,
      'documentType': documentType,
      'documentNumber': documentNumber,
      'expiryDate': expiryDate,
      'fileUrl': fileUrl,
    };
  }

  VehicleDocumentUploadRequestModel copyWith({
    String? vehicleId,
    String? documentType,
    String? documentNumber,
    String? expiryDate,
    String? fileUrl,
  }) {
    return VehicleDocumentUploadRequestModel(
      vehicleId: vehicleId ?? this.vehicleId,
      documentType: documentType ?? this.documentType,
      documentNumber: documentNumber ?? this.documentNumber,
      expiryDate: expiryDate ?? this.expiryDate,
      fileUrl: fileUrl ?? this.fileUrl,
    );
  }

  @override
  List<Object?> get props => [
        vehicleId,
        documentType,
        documentNumber,
        expiryDate,
        fileUrl,
      ];
}

