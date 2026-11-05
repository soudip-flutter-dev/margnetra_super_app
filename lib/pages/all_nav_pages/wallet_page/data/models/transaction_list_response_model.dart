import 'package:equatable/equatable.dart';
import 'wallet_transaction_model.dart';

/// Response model for the paginated transaction list endpoint (ApiUrls.transactionList).
class TransactionListResponseModel extends Equatable {
  final bool? success;
  final String? message;
  final List<WalletTransactionModel> data;

  const TransactionListResponseModel({
    this.success,
    this.message,
    this.data = const [],
  });

  factory TransactionListResponseModel.fromJson(Map<String, dynamic> json) {
    final rawList = json['data'];
    final list = <WalletTransactionModel>[];
    if (rawList is List) {
      for (final item in rawList) {
        if (item is Map<String, dynamic>) {
          list.add(WalletTransactionModel.fromJson(item));
        }
      }
    }
    return TransactionListResponseModel(
      success: json['success'] as bool?,
      message: json['message'] as String?,
      data: list,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data.map((e) => e.toJson()).toList(),
    };
  }

  @override
  List<Object?> get props => [success, message, data];
}

