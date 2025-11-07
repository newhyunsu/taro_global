import 'package:flutter/material.dart';

class SpreadItem {
  const SpreadItem({
    required this.title,
    required this.description,
    required this.buttonText,
    required this.cardCount,
    this.imageAsset,
    required this.onTap,
  });

  final String title;
  final String description;
  final String buttonText;
  final int cardCount;
  final String? imageAsset;
  final VoidCallback onTap;
}

