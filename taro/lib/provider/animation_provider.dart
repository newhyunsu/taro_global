import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AnimationState {
  final double magicAnimationX;
  final double magicAnimationY;
  final double cardGlowAnimation;

  AnimationState({
    required this.magicAnimationX,
    required this.magicAnimationY,
    required this.cardGlowAnimation,
  });

  AnimationState copyWith({
    double? magicAnimationX,
    double? magicAnimationY,
    double? cardGlowAnimation,
  }) {
    return AnimationState(
      magicAnimationX: magicAnimationX ?? this.magicAnimationX,
      magicAnimationY: magicAnimationY ?? this.magicAnimationY,
      cardGlowAnimation: cardGlowAnimation ?? this.cardGlowAnimation,
    );
  }
}

class AnimationNotifier extends StateNotifier<AnimationState> {
  AnimationNotifier()
    : super(
        AnimationState(
          magicAnimationX: 0.0,
          magicAnimationY: 0.0,
          cardGlowAnimation: 0.6,
        ),
      );

  void updateMagicAnimation(double x, double y) {
    state = state.copyWith(magicAnimationX: x, magicAnimationY: y);
  }

  void updateCardGlow(double value) {
    state = state.copyWith(cardGlowAnimation: value);
  }
}

final animationProvider =
    StateNotifierProvider<AnimationNotifier, AnimationState>((ref) {
      return AnimationNotifier();
    });
