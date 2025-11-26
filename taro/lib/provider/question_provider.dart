import 'package:flutter_riverpod/flutter_riverpod.dart';

class QuestionNotifier extends StateNotifier<String> {
  QuestionNotifier() : super('');

  void updateQuestion(String question) {
    state = question;
  }

  void clearQuestion() {
    state = '';
  }
}

final questionProvider = StateNotifierProvider<QuestionNotifier, String>((ref) {
  return QuestionNotifier();
});
