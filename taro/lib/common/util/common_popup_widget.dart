import 'package:flutter/material.dart';

Future<bool?> showConfirmDialog({
  required BuildContext context,
  String title = '알림',
  String content = '',
  String confirmText = '확인',
  String cancelText = '취소',
  Color? titleBackgroundColor,
}) {
  return showGeneralDialog<bool>(
    context: context,
    barrierDismissible: false,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    transitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (context, animation, secondaryAnimation) {
      return Center(
        child: _buildDialogContent(
          context,
          title: title,
          content: content,
          confirmText: confirmText,
          cancelText: cancelText,
          titleBackgroundColor: titleBackgroundColor,
        ),
      );
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: animation,
        child: ScaleTransition(
          scale: CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
          child: child,
        ),
      );
    },
  );
}

Widget _buildDialogContent(
  BuildContext context, {
  required String title,
  required String content,
  required String confirmText,
  required String cancelText,
  required Color? titleBackgroundColor,
}) {
  // final isDark = Theme.of(context).brightness == Brightness.dark;
  final isDark = false;
  final defaultTitleBgColor =
      titleBackgroundColor ?? (isDark ? Colors.blue.shade700 : Colors.green);

  final dialogBgColor = isDark ? Colors.grey.shade800 : Colors.white;
  final titleTextColor = isDark ? Colors.white : Colors.white;
  final contentTextColor = isDark ? Colors.white70 : Colors.black87;
  final cancelTextColor = isDark ? Colors.white60 : Colors.black87;
  final confirmTextColor = isDark ? Colors.white : Colors.white;
  final dividerColor = isDark ? Colors.grey.shade600 : Colors.grey.shade300;

  return Dialog(
    backgroundColor: dialogBgColor,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 🔷 Title
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: defaultTitleBgColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
          ),
          child: Text(
            title,
            style: TextStyle(
              color: titleTextColor,
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        // 🔹 Content
        Padding(
          padding: const EdgeInsets.all(20),
          child: Text(
            content,
            style: TextStyle(
              fontSize: 16,
              color: contentTextColor,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),

        Divider(height: 1, color: dividerColor),

        // 🔸 Buttons with 50/50 layout
        Row(
          children: [
            Expanded(
              flex: 2,
              child: TextButton(
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(12),
                    ),
                  ),
                ),
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(
                  cancelText,
                  style: TextStyle(
                    color: cancelTextColor,
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
            ),
            Container(width: 1, height: 50, color: dividerColor),
            Expanded(
              flex: 3,
              child: TextButton(
                style: TextButton.styleFrom(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(12),
                    ),
                  ),
                  backgroundColor: defaultTitleBgColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () => Navigator.of(context).pop(true),
                child: Text(
                  confirmText,
                  style: TextStyle(
                    color: confirmTextColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

void showToast({required BuildContext context, required String message}) {
  final snackBar = SnackBar(
    content: Text(message),
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
    backgroundColor: Colors.black.withValues(alpha: 0.7),
    duration: const Duration(seconds: 3),
    animation: CurvedAnimation(
      parent: AnimationController(
        vsync: ScaffoldMessenger.of(context),
        duration: const Duration(milliseconds: 350),
      ),
      curve: Curves.easeInOut,
    ),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
