import 'package:equatable/equatable.dart';

class PaymentMethodModel extends Equatable {
  final int id;
  final int? userId;
  final String type;
  final String identifier;
  final bool isDefault;
  final DateTime? createdAt;

  const PaymentMethodModel({
    required this.id,
    this.userId,
    required this.type,
    required this.identifier,
    this.isDefault = false,
    this.createdAt,
  });

  factory PaymentMethodModel.fromJson(Map<String, dynamic> json) {
    return PaymentMethodModel(
      id: json['id'] is int ? json['id'] as int : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      userId: json['user_id'] is int ? json['user_id'] as int : int.tryParse(json['user_id']?.toString() ?? ''),
      type: json['type']?.toString() ?? 'upi',
      identifier: json['identifier']?.toString() ?? '',
      isDefault: json['is_default'] as bool? ?? false,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'type': type,
      'identifier': identifier,
      'is_default': isDefault,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [id, userId, type, identifier, isDefault, createdAt];
}
