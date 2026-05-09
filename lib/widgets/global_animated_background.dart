// lib/widgets/global_animated_background.dart
import 'package:flutter/material.dart';
import 'dart:math';
import '../utils/constants.dart';

class GlobalAnimatedBackground extends StatefulWidget {
  // Now accepts a ValueNotifier for cursor position
  final ValueNotifier<Offset> cursorPosition;

  const GlobalAnimatedBackground({super.key, required this.cursorPosition});

  @override
  State<GlobalAnimatedBackground> createState() => _GlobalAnimatedBackgroundState();
}

class _GlobalAnimatedBackgroundState extends State<GlobalAnimatedBackground> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  final List<Map<String, dynamic>> _particles = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 25), // Slower, more majestic overall animation
      vsync: this,
    )..repeat(reverse: false);

    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.linear,
      ),
    );

    // Initialize particles with random properties for depth simulation
    for (int i = 0; i < 150; i++) { // Optimized: Reduced particle count for better performance
      _particles.add({
        'x': _random.nextDouble(), // Normalized x
        'y': _random.nextDouble(), // Normalized y
        'depth': _random.nextDouble(), // 0.0 (far) to 1.0 (close)
        'baseSize': _random.nextDouble() * 1.0 + 0.5, // Base size between 0.5 and 1.5
        'speedFactor': _random.nextDouble() * 0.003 + 0.001, // Movement speed
        'directionAngle': _random.nextDouble() * 2 * pi, // Initial movement direction
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return ValueListenableBuilder<Offset>( // Listen to cursor position changes
          valueListenable: widget.cursorPosition,
          builder: (context, cursorOffset, child) {
            return CustomPaint(
              painter: _GlobalBackgroundPainter(
                animation: _animation,
                particles: _particles,
                cursorPosition: cursorOffset, // Pass live cursor position
              ),
              size: Size.infinite,
            );
          },
        );
      },
    );
  }
}

class _GlobalBackgroundPainter extends CustomPainter {
  final Animation<double> animation;
  final List<Map<String, dynamic>> particles;
  final Offset cursorPosition; // Live cursor position

  _GlobalBackgroundPainter({
    required this.animation,
    required this.particles,
    required this.cursorPosition,
  }) : super(repaint: animation); // Repaint on animation updates

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final center = Offset(centerX, centerY);
    final shortestSide = size.shortestSide;

    // --- Background Gradient ---
    final backgroundPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          AppColors.background,
          AppColors.cardBackground.withOpacity(0.8),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), backgroundPaint);

    // --- Global Glowing Effect (More prominent and central) ---
    final globalGlowPaint = Paint()
      ..color = AppColors.primary.withOpacity(0.15 + (sin(animation.value * pi * 4) * 0.05))
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, shortestSide * 0.05 + sin(animation.value * pi * 2) * 2); // Pulsating blur
    canvas.drawCircle(center, shortestSide * 0.35 + sin(animation.value * pi * 2) * shortestSide * 0.02, globalGlowPaint); // Pulsating size

    // --- Pulsating Concentric "Energy" Rings (More layers, dynamic) ---
    final ringPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    for (int i = 1; i <= 8; i++) {
      final baseRadius = shortestSide * 0.08 * i;
      final currentRadius = baseRadius + (sin(animation.value * pi * 2 * 0.5 + i * 0.3) * shortestSide * 0.01) + (animation.value * shortestSide * 0.1);
      final opacity = 0.1 * (1 - (currentRadius / (shortestSide * 1.5)));
      ringPaint.color = AppColors.primary.withOpacity(opacity.clamp(0.0, 0.1));
      canvas.drawCircle(center, currentRadius, ringPaint);
    }

    // --- Radiating & Rotating "Data Stream" Lines ---
    final linePaint = Paint()
      ..color = AppColors.accent.withOpacity(0.08)
      ..strokeWidth = 0.8;

    canvas.save();
    canvas.translate(centerX, centerY);
    canvas.rotate(animation.value * pi * 2 * 0.4);

    for (int i = 0; i < 360; i += 15) {
      final angle = i * (pi / 180);
      final lineLength = shortestSide * (0.3 + (sin(animation.value * pi * 2 * 1.5 + i * 0.1) * 0.1));
      final p1 = Offset(cos(angle) * shortestSide * 0.05, sin(angle) * shortestSide * 0.05);
      final p2 = Offset(cos(angle) * lineLength, sin(angle) * lineLength);
      canvas.drawLine(p1, p2, linePaint);
    }
    canvas.restore();

    // --- Dynamic Particle Field (Stars/Data Points) with Interactive Behavior ---
    final particlePaint = Paint()
      ..style = PaintingStyle.fill;

    final connectingLinePaint = Paint()
      ..strokeWidth = 0.2;

    for (int i = 0; i < particles.length; i++) {
      final particle = particles[i];
      double x = particle['x'] * size.width;
      double y = particle['y'] * size.height;
      final double depth = particle['depth']; // 0.0 (far) to 1.0 (close)
      final double baseSize = particle['baseSize'];
      final double speedFactor = particle['speedFactor'];

      // Apply movement based on animation and depth (parallax)
      // Faster movement for closer particles
      x += sin(animation.value * pi * 2 * (1 + (1 - depth)) + i) * speedFactor * 20;
      y += cos(animation.value * pi * 2 * (1 + (1 - depth)) + i) * speedFactor * 20;

      // Wrap around screen edges
      if (x < 0) x += size.width;
      if (x > size.width) x -= size.width;
      if (y < 0) y += size.height;
      if (y > size.height) y -= size.height;

      // --- Interactive Repulsion/Attraction ---
      // Reduced interaction radius and strength for performance,
      // and to avoid overly dramatic movements that might feel laggy.
      final interactionRadius = shortestSide * 0.08; // Reduced radius
      final repulsionStrength = 10.0 * (1 - depth); // Reduced strength

      if (cursorPosition != Offset.zero) { // Only apply if cursor is active
        final distanceToCursor = (Offset(x, y) - cursorPosition).distance;
        if (distanceToCursor < interactionRadius) {
          final double strength = 1 - (distanceToCursor / interactionRadius); // Normalized strength
          final Offset direction = (Offset(x, y) - cursorPosition).normalize();
          x += direction.dx * strength * repulsionStrength;
          y += direction.dy * strength * repulsionStrength;
        }
      }

      final currentParticlePos = Offset(x, y);

      // Particle size and opacity based on depth
      final effectiveSize = baseSize + (sin(animation.value * pi * 2 * 3 + i * 0.2) * 0.5) * depth; // Pulsating and scaled by depth, reduced pulsation
      final effectiveOpacity = 0.3 + (0.7 * depth) - (sin(animation.value * pi * 2 * 2 + i * 0.1) * 0.1); // Brighter/more opaque when closer
      particlePaint.color = AppColors.textPrimary.withOpacity(effectiveOpacity.clamp(0.0, 1.0));
      canvas.drawCircle(currentParticlePos, effectiveSize, particlePaint);

      // Draw connecting lines to nearby particles, also affected by depth and distance
      for (int j = i + 1; j < particles.length; j++) {
        final otherParticle = particles[j];
        double otherX = otherParticle['x'] * size.width;
        double otherY = otherParticle['y'] * size.height;
        final double otherDepth = otherParticle['depth'];

        otherX += sin(animation.value * pi * 2 * (1 + (1 - otherDepth)) + j) * otherParticle['speedFactor'] * 20;
        otherY += cos(animation.value * pi * 2 * (1 + (1 - otherDepth)) + j) * otherParticle['speedFactor'] * 20;

        if (cursorPosition != Offset.zero) {
          final distanceToCursorOther = (Offset(otherX, otherY) - cursorPosition).distance;
          if (distanceToCursorOther < interactionRadius) {
            final double strength = 1 - (distanceToCursorOther / interactionRadius);
            final Offset direction = (Offset(otherX, otherY) - cursorPosition).normalize();
            otherX += direction.dx * strength * repulsionStrength;
            otherY += direction.dy * strength * repulsionStrength;
          }
        }

        final otherParticlePos = Offset(otherX, otherY);

        final distance = (currentParticlePos - otherParticlePos).distance;
        // Optimized: Significantly reduced maxConnectDistance to limit expensive line drawing
        final maxConnectDistance = shortestSide * 0.05 * ((depth + otherDepth) / 2); // Connect very short distances
        if (distance < maxConnectDistance) {
          final opacity = 0.02 * (1 - (distance / maxConnectDistance)) * ((depth + otherDepth) / 2); // Very subtle lines
          connectingLinePaint.color = AppColors.textSecondary.withOpacity(opacity.clamp(0.0, 0.02));
          canvas.drawLine(currentParticlePos, otherParticlePos, connectingLinePaint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant _GlobalBackgroundPainter oldDelegate) {
    // Repaint if animation value changes OR cursor position changes
    return oldDelegate.animation != animation || oldDelegate.cursorPosition != cursorPosition;
  }
}

// Extension to normalize an offset (make its length 1)
extension on Offset {
  Offset normalize() {
    final double length = distance;
    return length == 0 ? Offset.zero : Offset(dx / length, dy / length);
  }
}
