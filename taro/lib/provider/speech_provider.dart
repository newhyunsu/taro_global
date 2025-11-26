import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:taro/i18n/strings.g.dart';

class SpeechState {
  final bool isListening;
  final bool isAvailable;
  final String recognizedText;
  final String? error;

  SpeechState({
    this.isListening = false,
    this.isAvailable = false,
    this.recognizedText = '',
    this.error,
  });

  SpeechState copyWith({
    bool? isListening,
    bool? isAvailable,
    String? recognizedText,
    String? error,
  }) {
    return SpeechState(
      isListening: isListening ?? this.isListening,
      isAvailable: isAvailable ?? this.isAvailable,
      recognizedText: recognizedText ?? this.recognizedText,
      error: error,
    );
  }
}

class SpeechNotifier extends StateNotifier<SpeechState> {
  final stt.SpeechToText _speech;

  SpeechNotifier(this._speech) : super(SpeechState()) {
    _initSpeech();
  }

  Future<void> _initSpeech() async {
    try {
      final available = await _speech.initialize(
        onError: (error) {
          state = state.copyWith(isListening: false, error: error.errorMsg);
        },
        onStatus: (status) {
          if (status == 'done' || status == 'notListening') {
            state = state.copyWith(isListening: false);
          }
        },
      );
      state = state.copyWith(isAvailable: available);
    } catch (e) {
      state = state.copyWith(isAvailable: false, error: e.toString());
    }
  }

  Future<void> toggleListening(String localeCode) async {
    if (!state.isAvailable) {
      state = state.copyWith(
        error: localeCode == 'ko'
            ? '음성 인식을 사용할 수 없습니다'
            : 'Speech recognition not available',
      );
      return;
    }

    if (!state.isListening) {
      try {
        final available = await _speech.initialize();
        if (available) {
          state = state.copyWith(isListening: true, error: null);
          await _speech.listen(
            onResult: (result) {
              state = state.copyWith(recognizedText: result.recognizedWords);
            },
            localeId: localeCode == 'ko' ? 'ko_KR' : 'en_US',
            listenMode: stt.ListenMode.confirmation,
            pauseFor: const Duration(seconds: 3),
            cancelOnError: true,
          );
        }
      } catch (e) {
        state = state.copyWith(isListening: false, error: e.toString());
      }
    } else {
      await _speech.stop();
      state = state.copyWith(isListening: false);
    }
  }

  void clearText() {
    state = state.copyWith(recognizedText: '');
  }

  @override
  void dispose() {
    _speech.stop();
    super.dispose();
  }
}

final speechProvider = StateNotifierProvider<SpeechNotifier, SpeechState>((
  ref,
) {
  return SpeechNotifier(stt.SpeechToText());
});
