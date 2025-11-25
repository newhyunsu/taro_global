import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../provider/tarot_history_provider.dart';
import 'tarot_history_item.dart';

class TarotHistoryWidget extends ConsumerStatefulWidget {
  const TarotHistoryWidget({super.key});

  @override
  ConsumerState<TarotHistoryWidget> createState() => _TarotHistoryWidgetState();
}

class _TarotHistoryWidgetState extends ConsumerState<TarotHistoryWidget> {
  double _dragStartX = 0;
  double _dragUpdateX = 0;

  @override
  Widget build(BuildContext context) {
    final historyList = ref.watch(tarotHistoryProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF2D1B4E),
      body: GestureDetector(
        onHorizontalDragStart: (details) {
          _dragStartX = details.globalPosition.dx;
        },
        onHorizontalDragUpdate: (details) {
          _dragUpdateX = details.globalPosition.dx;
        },
        onHorizontalDragEnd: (details) {
          final dragDistance = _dragUpdateX - _dragStartX;
          // 오른쪽으로 100px 이상 드래그하거나 빠른 속도로 스와이프
          // if (dragDistance > 100 ||
          //     (details.primaryVelocity != null &&
          //         details.primaryVelocity! > 500)) {
          Navigator.pop(context);
          // }
        },
        child: Column(
          children: [
            // 헤더
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Reading History',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    if (historyList.isNotEmpty)
                      IconButton(
                        icon: const Icon(
                          Icons.delete_outline,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          _showClearHistoryDialog(context, ref);
                        },
                      ),
                  ],
                ),
              ),
            ),
            // 히스토리 리스트
            Expanded(
              child: historyList.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: historyList.length,
                      itemBuilder: (context, index) {
                        final reading = historyList[index];
                        return TarotHistoryItem(
                          reading: reading,
                          onTap: () {
                            // TODO: 상세 페이지로 이동
                          },
                          onDelete: () {
                            ref
                                .read(tarotHistoryProvider.notifier)
                                .removeReading(reading.id);
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.history, size: 64, color: Colors.white.withOpacity(0.3)),
          const SizedBox(height: 16),
          Text(
            'No readings yet',
            style: TextStyle(
              color: Colors.white.withOpacity(0.5),
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your tarot reading history will appear here',
            style: TextStyle(
              color: Colors.white.withOpacity(0.3),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  void _showClearHistoryDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2D1B4E),
        title: const Text(
          'Clear History',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'Are you sure you want to clear all reading history?',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              ref.read(tarotHistoryProvider.notifier).clearHistory();
              Navigator.pop(context);
            },
            child: const Text('Clear', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
