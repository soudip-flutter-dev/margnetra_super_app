import 'package:equatable/equatable.dart';
import 'wallet_dashboard_data_model.dart';

/// Top-level response model for the wallet dashboard endpoint.
class WalletDashboardResponseModel extends Equatable {
  final bool? success;
  final String? message;
  final WalletDashboardDataModel? data;

  const WalletDashboardResponseModel({
    this.success,
    this.message,
    this.data,
  });

  factory WalletDashboardResponseModel.fromJson(Map<String, dynamic> json) {
    return WalletDashboardResponseModel(
      success: json['success'] as bool?,
      message: json['message'] as String?,
      data: json['data'] is Map<String, dynamic>
          ? WalletDashboardDataModel.fromJson(
              json['data'] as Map<String, dynamic>)
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

