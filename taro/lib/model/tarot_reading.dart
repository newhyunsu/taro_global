class TarotReading {
  final String id;
  final DateTime date;
  final String question;
  final String cardName;
  final bool isReversed;
  final String? interpretation;

  TarotReading({
    required this.id,
    required this.date,
    required this.question,
    required this.cardName,
    required this.isReversed,
    this.interpretation,
  });

  TarotReading copyWith({
    String? id,
    DateTime? date,
    String? question,
    String? cardName,
    bool? isReversed,
    String? interpretation,
  }) {
    return TarotReading(
      id: id ?? this.id,
      date: date ?? this.date,
      question: question ?? this.question,
      cardName: cardName ?? this.cardName,
      isReversed: isReversed ?? this.isReversed,
      interpretation: interpretation ?? this.interpretation,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'question': question,
      'cardName': cardName,
      'isReversed': isReversed,
      'interpretation': interpretation,
    };
  }

  factory TarotReading.fromJson(Map<String, dynamic> json) {
    return TarotReading(
      id: json['id'] as String,
      date: DateTime.parse(json['date'] as String),
      question: json['question'] as String,
      cardName: json['cardName'] as String,
      isReversed: json['isReversed'] as bool,
      interpretation: json['interpretation'] as String?,
    );
  }
}
