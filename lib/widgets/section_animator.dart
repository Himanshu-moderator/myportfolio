// lib/widgets/section_animator.dart
import 'package:flutter/material.dart';

class SectionAnimator extends StatefulWidget {
  final Widget child;
  final Duration animationDuration;
  final Offset slideOffset; // Starting offset for translation
  final Curve curve; // Animation curve

  const SectionAnimator({
    super.key,
    required this.child,
    this.animationDuration = const Duration(milliseconds: 800), // Default smooth duration
    this.slideOffset = const Offset(0, 30), // Subtle slide up
    this.curve = Curves.easeOutCubic, // Smooth and strong ease-out
  });

  @override
  State<SectionAnimator> createState() => SectionAnimatorState();
}

class SectionAnimatorState extends State<SectionAnimator> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _opacityAnimation;
  late Animation<Offset> _slideAnimation;

  // Public getter to expose the animation controller
  AnimationController get controller => _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: widget.curve,
      ),
    );

    _slideAnimation = Tween<Offset>(begin: widget.slideOffset, end: Offset.zero).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: widget.curve,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // Method to trigger the animation
  void playAnimation() {
    if (!_animationController.isAnimating && _animationController.status != AnimationStatus.completed) {
      _animationController.forward();
    }
  }

  // Method to reset the animation
  void resetAnimation() {
    if (_animationController.status == AnimationStatus.completed || _animationController.status == AnimationStatus.forward) {
      _animationController.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Opacity(
          opacity: _opacityAnimation.value,
          child: Transform.translate(
            offset: _slideAnimation.value,
            child: widget.child,
          ),
        );
      },
    );
  }
}
