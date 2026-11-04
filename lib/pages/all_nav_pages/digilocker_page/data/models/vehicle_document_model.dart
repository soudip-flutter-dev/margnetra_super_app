import 'package:equatable/equatable.dart';

/// Represents a single vehicle document stored in DigiLocker.
class VehicleDocumentModel extends Equatable {
  final String id;
  final String documentType;
  final String title;
  final String documentNumber;
  final String status;
  final String statusText;
  final String expiryDate;
  final String formattedExpiry;
  final int daysUntilExpiry;
  final String fileUrl;
  final bool expiringSoon;
  final bool verified;

  const VehicleDocumentModel({
    required this.id,
    required this.documentType,
    required this.title,
    required this.documentNumber,
    required this.status,
    required this.statusText,
    required this.expiryDate,
    required this.formattedExpiry,
    required this.daysUntilExpiry,
    required this.fileUrl,
    required this.expiringSoon,
    required this.verified,
  });

  /// Factory constructor to parse JSON with safe defaults.
  factory VehicleDocumentModel.fromJson(Map<String, dynamic> json) {
    return VehicleDocumentModel(
      id: json['id']?.toString() ?? '',
      documentType: json['documentType']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      documentNumber: json['documentNumber']?.toString() ?? '',
      status: json['status']?.toString() ?? 'VALID',
      statusText: json['statusText']?.toString() ?? '',
      expiryDate: json['expiryDate']?.toString() ?? '',
      formattedExpiry: json['formattedExpiry']?.toString() ?? '',
      daysUntilExpiry: (json['daysUntilExpiry'] as num?)?.toInt() ?? 0,
      fileUrl: json['fileUrl']?.toString() ?? '',
      expiringSoon: json['expiringSoon'] as bool? ?? false,
      verified: json['verified'] as bool? ?? false,
    );
  }

  /// Converts the document model to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'documentType': documentType,
      'title': title,
      'documentNumber': documentNumber,
      'status': status,
      'statusText': statusText,
      'expiryDate': expiryDate,
      'formattedExpiry': formattedExpiry,
      'daysUntilExpiry': daysUntilExpiry,
      'fileUrl': fileUrl,
      'expiringSoon': expiringSoon,
      'verified': verified,
    };
  }

  VehicleDocumentModel copyWith({
    String? id,
    String? documentType,
    String? title,
    String? documentNumber,
    String? status,
    String? statusText,
    String? expiryDate,
    String? formattedExpiry,
    int? daysUntilExpiry,
    String? fileUrl,
    bool? expiringSoon,
    bool? verified,
  }) {
    return VehicleDocumentModel(
      id: id ?? this.id,
      documentType: documentType ?? this.documentType,
      title: title ?? this.title,
      documentNumber: documentNumber ?? this.documentNumber,
      status: status ?? this.status,
      statusText: statusText ?? this.statusText,
      expiryDate: expiryDate ?? this.expiryDate,
      formattedExpiry: formattedExpiry ?? this.formattedExpiry,
      daysUntilExpiry: daysUntilExpiry ?? this.daysUntilExpiry,
      fileUrl: fileUrl ?? this.fileUrl,
      expiringSoon: expiringSoon ?? this.expiringSoon,
      verified: verified ?? this.verified,
    );
  }

  /// Helper boolean: whether the document is already expired.
  bool get isExpired =>
      status.toUpperCase() == 'EXPIRED' ||
      (daysUntilExpiry < 0 && daysUntilExpiry != 0);

  /// Helper boolean: whether the document is valid.
  bool get isValid =>
      status.toUpperCase() == 'VALID' && !isExpired && !expiringSoon;

  /// Helper boolean: whether the document is near expiry.
  bool get isExpiringSoon =>
      expiringSoon ||
      status.toUpperCase() == 'EXPIRING_SOON' ||
      (daysUntilExpiry > 0 && daysUntilExpiry <= 30);

  @override
  List<Object?> get props => [
        id,
        documentType,
        title,
        documentNumber,
        status,
        statusText,
        expiryDate,
        formattedExpiry,
        daysUntilExpiry,
        fileUrl,
        expiringSoon,
        verified,
      ];
}

