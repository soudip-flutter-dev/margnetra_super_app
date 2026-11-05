import 'package:equatable/equatable.dart';

/// Model representing user MGC wallet balance details.
class WalletBalanceModel extends Equatable {
  final num availableMgc;
  final num provisionalMgc;
  final num heldMgc;
  final num totalMgc;
  final String currency;

  const WalletBalanceModel({
    this.availableMgc = 0,
    this.provisionalMgc = 0,
    this.heldMgc = 0,
    this.totalMgc = 0,
    this.currency = 'MGC',
  });

  factory WalletBalanceModel.fromJson(Map<String, dynamic> json) {
    return WalletBalanceModel(
      availableMgc: json['availableMgc'] is num
          ? json['availableMgc'] as num
          : (num.tryParse(json['availableMgc']?.toString() ?? '') ?? 0),
      provisionalMgc: json['provisionalMgc'] is num
          ? json['provisionalMgc'] as num
          : (num.tryParse(json['provisionalMgc']?.toString() ?? '') ?? 0),
      heldMgc: json['heldMgc'] is num
          ? json['heldMgc'] as num
          : (num.tryParse(json['heldMgc']?.toString() ?? '') ?? 0),
      totalMgc: json['totalMgc'] is num
          ? json['totalMgc'] as num
          : (num.tryParse(json['totalMgc']?.toString() ?? '') ?? 0),
      currency: json['currency']?.toString() ?? 'MGC',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'availableMgc': availableMgc,
      'provisionalMgc': provisionalMgc,
      'heldMgc': heldMgc,
      'totalMgc': totalMgc,
      'currency': currency,
    };
  }

  WalletBalanceModel copyWith({
    num? availableMgc,
    num? provisionalMgc,
    num? heldMgc,
    num? totalMgc,
    String? currency,
  }) {
    return WalletBalanceModel(
      availableMgc: availableMgc ?? this.availableMgc,
      provisionalMgc: provisionalMgc ?? this.provisionalMgc,
      heldMgc: heldMgc ?? this.heldMgc,
      totalMgc: totalMgc ?? this.totalMgc,
      currency: currency ?? this.currency,
    );
  }

  @override
  List<Object?> get props => [
        availableMgc,
        provisionalMgc,
        heldMgc,
        totalMgc,
        currency,
      ];
}

