import 'package:equatable/equatable.dart';

class CivilScoreHistoryItem extends Equatable {
  final DateTime date;
  final double score;
  final double delta;
  final String reason;

  const CivilScoreHistoryItem({
    required this.date,
    required this.score,
    required this.delta,
    required this.reason,
  });

  factory CivilScoreHistoryItem.fromJson(Map<String, dynamic> json) {
    return CivilScoreHistoryItem(
      date: json['date'] != null
          ? DateTime.tryParse(json['date'].toString()) ?? DateTime.now()
          : DateTime.now(),
      score: (json['score'] is num) ? (json['score'] as num).toDouble() : 750.0,
      delta: (json['delta'] is num) ? (json['delta'] as num).toDouble() : 0.0,
      reason: json['reason']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'score': score,
      'delta': delta,
      'reason': reason,
    };
  }

  @override
  List<Object?> get props => [date, score, delta, reason];
}

class CivilScoreModel extends Equatable {
  final double currentScore;
  final int streakDays;
  final List<CivilScoreHistoryItem> history;

  const CivilScoreModel({
    required this.currentScore,
    required this.streakDays,
    this.history = const [],
  });

  factory CivilScoreModel.fromJson(Map<String, dynamic> json) {
    final list = json['history'] as List<dynamic>? ?? [];
    return CivilScoreModel(
      currentScore: (json['current_score'] is num)
          ? (json['current_score'] as num).toDouble()
          : 750.0,
      streakDays: (json['streak_days'] is int)
          ? json['streak_days'] as int
          : int.tryParse(json['streak_days']?.toString() ?? '0') ?? 0,
      history: list
          .map((e) => CivilScoreHistoryItem.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'current_score': currentScore,
      'streak_days': streakDays,
      'history': history.map((e) => e.toJson()).toList(),
    };
  }

  @override
  List<Object?> get props => [currentScore, streakDays, history];
}
