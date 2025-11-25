import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/tarot_reading.dart';

class TarotHistoryNotifier extends StateNotifier<List<TarotReading>> {
  TarotHistoryNotifier() : super([]) {
    _loadInitialData();
  }

  void _loadInitialData() {
    // TODO: 실제 데이터베이스나 SharedPreferences에서 로드
    state = List.generate(
      10,
      (index) => TarotReading(
        id: 'reading_$index',
        date: DateTime.now().subtract(Duration(days: index)),
        question: 'What does the future hold for my career?',
        cardName: 'The Fool',
        isReversed: index % 3 == 0,
        interpretation: 'Sample interpretation...',
      ),
    );
  }

  void addReading(TarotReading reading) {
    state = [reading, ...state];
  }

  void removeReading(String id) {
    state = state.where((reading) => reading.id != id).toList();
  }

  void updateReading(TarotReading updatedReading) {
    state = [
      for (final reading in state)
        if (reading.id == updatedReading.id) updatedReading else reading,
    ];
  }

  void clearHistory() {
    state = [];
  }
}

final tarotHistoryProvider =
    StateNotifierProvider<TarotHistoryNotifier, List<TarotReading>>((ref) {
      return TarotHistoryNotifier();
    });
