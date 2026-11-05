import 'package:equatable/equatable.dart';

/// Model representing a single wallet transaction in the recent transactions list.
class WalletTransactionModel extends Equatable {
  final String id;
  final String transactionType; // CREDIT, DEBIT
  final String category; // TRIP_REWARD, FASTAG_RECHARGE, etc.
  final num amountMgc;
  final String balanceType; // AVAILABLE, PROVISIONAL, etc.
  final String status; // SUCCESS, PENDING, FAILED
  final String referenceId;
  final String description;
  final String createdAt;

  const WalletTransactionModel({
    required this.id,
    required this.transactionType,
    required this.category,
    required this.amountMgc,
    required this.balanceType,
    required this.status,
    required this.referenceId,
    required this.description,
    required this.createdAt,
  });

  bool get isCredit => transactionType.toUpperCase() == 'CREDIT';
  bool get isDebit => transactionType.toUpperCase() == 'DEBIT';
  bool get isSuccess => status.toUpperCase() == 'SUCCESS';

  String get formattedAmount {
    final prefix = isCredit ? '+' : (isDebit ? '-' : '');
    return '$prefix$amountMgc MGC';
  }

  factory WalletTransactionModel.fromJson(Map<String, dynamic> json) {
    return WalletTransactionModel(
      id: json['id']?.toString() ?? '',
      transactionType: json['transactionType']?.toString() ?? 'CREDIT',
      category: json['category']?.toString() ?? '',
      amountMgc: json['amountMgc'] is num
          ? json['amountMgc'] as num
          : (num.tryParse(json['amountMgc']?.toString() ?? '') ?? 0),
      balanceType: json['balanceType']?.toString() ?? 'AVAILABLE',
      status: json['status']?.toString() ?? 'SUCCESS',
      referenceId: json['referenceId']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      createdAt: json['createdAt']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'transactionType': transactionType,
      'category': category,
      'amountMgc': amountMgc,
      'balanceType': balanceType,
      'status': status,
      'referenceId': referenceId,
      'description': description,
      'createdAt': createdAt,
    };
  }

  WalletTransactionModel copyWith({
    String? id,
    String? transactionType,
    String? category,
    num? amountMgc,
    String? balanceType,
    String? status,
    String? referenceId,
    String? description,
    String? createdAt,
  }) {
    return WalletTransactionModel(
      id: id ?? this.id,
      transactionType: transactionType ?? this.transactionType,
      category: category ?? this.category,
      amountMgc: amountMgc ?? this.amountMgc,
      balanceType: balanceType ?? this.balanceType,
      status: status ?? this.status,
      referenceId: referenceId ?? this.referenceId,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        transactionType,
        category,
        amountMgc,
        balanceType,
        status,
        referenceId,
        description,
        createdAt,
      ];
}

