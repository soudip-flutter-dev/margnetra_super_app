import 'package:equatable/equatable.dart';
import 'wallet_balance_model.dart';
import 'wallet_transaction_model.dart';

/// Data payload of the wallet dashboard endpoint.
class WalletDashboardDataModel extends Equatable {
  final WalletBalanceModel balance;
  final int civilScore;
  final String civilRating;
  final int activeStreakProtections;
  final List<WalletTransactionModel> recentTransactions;

  const WalletDashboardDataModel({
    required this.balance,
    this.civilScore = 0,
    this.civilRating = 'GOOD',
    this.activeStreakProtections = 0,
    this.recentTransactions = const [],
  });

  factory WalletDashboardDataModel.fromJson(Map<String, dynamic> json) {
    final balanceJson = json['balance'] is Map<String, dynamic>
        ? json['balance'] as Map<String, dynamic>
        : <String, dynamic>{};

    final rawTransactions = json['recentTransactions'];
    final transactions = <WalletTransactionModel>[];
    if (rawTransactions is List) {
      for (final item in rawTransactions) {
        if (item is Map<String, dynamic>) {
          transactions.add(WalletTransactionModel.fromJson(item));
        }
      }
    }

    return WalletDashboardDataModel(
      balance: WalletBalanceModel.fromJson(balanceJson),
      civilScore: json['civilScore'] is int
          ? json['civilScore'] as int
          : (int.tryParse(json['civilScore']?.toString() ?? '') ?? 0),
      civilRating: json['civilRating']?.toString() ?? 'GOOD',
      activeStreakProtections: json['activeStreakProtections'] is int
          ? json['activeStreakProtections'] as int
          : (int.tryParse(json['activeStreakProtections']?.toString() ?? '') ?? 0),
      recentTransactions: transactions,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'balance': balance.toJson(),
      'civilScore': civilScore,
      'civilRating': civilRating,
      'activeStreakProtections': activeStreakProtections,
      'recentTransactions': recentTransactions.map((e) => e.toJson()).toList(),
    };
  }

  WalletDashboardDataModel copyWith({
    WalletBalanceModel? balance,
    int? civilScore,
    String? civilRating,
    int? activeStreakProtections,
    List<WalletTransactionModel>? recentTransactions,
  }) {
    return WalletDashboardDataModel(
      balance: balance ?? this.balance,
      civilScore: civilScore ?? this.civilScore,
      civilRating: civilRating ?? this.civilRating,
      activeStreakProtections:
          activeStreakProtections ?? this.activeStreakProtections,
      recentTransactions: recentTransactions ?? this.recentTransactions,
    );
  }

  @override
  List<Object?> get props => [
        balance,
        civilScore,
        civilRating,
        activeStreakProtections,
        recentTransactions,
      ];
}

