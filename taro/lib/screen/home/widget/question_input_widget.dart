import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taro/i18n/strings.g.dart';
import 'package:taro/provider/question_provider.dart';
import 'package:taro/provider/speech_provider.dart';

class QuestionInputWidget extends ConsumerStatefulWidget {
  const QuestionInputWidget({super.key});

  @override
  ConsumerState<QuestionInputWidget> createState() =>
      _QuestionInputWidgetState();
}

class _QuestionInputWidgetState extends ConsumerState<QuestionInputWidget> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      ref.read(questionProvider.notifier).updateQuestion(_controller.text);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final speechState = ref.watch(speechProvider);
    final localeCode = LocaleSettings.currentLocale.languageCode;

    // 음성 인식 텍스트를 TextField에 동기화
    ref.listen(speechProvider, (previous, next) {
      if (next.recognizedText != _controller.text) {
        _controller.text = next.recognizedText;
        _controller.selection = TextSelection.fromPosition(
          TextPosition(offset: _controller.text.length),
        );
      }

      // 에러 표시
      if (next.error != null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(next.error!)));
      }
    });

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A0B2E),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              style: const TextStyle(color: Colors.white, fontSize: 16),
              decoration: InputDecoration(
                hintText: t.home.questionHint,
                hintStyle: TextStyle(
                  color: Colors.white.withOpacity(0.5),
                  fontSize: 16,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
              maxLines: 3,
              minLines: 1,
            ),
          ),
          const SizedBox(width: 8),
          // 음성 입력 버튼
          InkWell(
            onTap: () {
              ref.read(speechProvider.notifier).toggleListening(localeCode);
            },
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: speechState.isListening
                    ? const Color(0xFFFFD700).withOpacity(0.2)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                speechState.isListening ? Icons.mic : Icons.mic_none,
                color: speechState.isListening
                    ? const Color(0xFFFFD700)
                    : Colors.white.withOpacity(0.7),
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
