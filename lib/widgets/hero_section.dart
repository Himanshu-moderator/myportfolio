// lib/widgets/hero_section.dart
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart'; // Still needed for AnimatedRoleText in HeroSubComponents
import 'package:three_d_portfolio/utils/constants.dart'; // Corrected import
import 'package:three_d_portfolio/widgets/responsive_layout.dart'; // Assuming this is present
import 'package:three_d_portfolio/widgets/vector_3d_for_animation.dart'; // Assuming this is present and defines Vector3
import 'package:url_launcher/url_launcher.dart'; // Still needed for launching URLs in HeroSubComponents
import 'dart:math'; // Needed for mathematical operations like pi, cos, sin

// Import the new file containing refactored components
import 'package:three_d_portfolio/widgets/hero_sub_components.dart'; // Corrected import

// --- HeroSection: The main widget that holds content and the 3D animation ---
class HeroSection extends StatefulWidget {
  final VoidCallback onProjectTap;
  final VoidCallback onContactTap;
  final ValueNotifier<Offset> cursorPosition; // To pass GLOBAL cursor for local 3D effect

  const HeroSection({
    super.key,
    required this.onProjectTap,
    required this.onContactTap,
    required this.cursorPosition,
  });

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection> with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    // The animation controller for the avatar is now within AnimatedAbstractIllustration
  }

  @override
  void dispose() {
    super.dispose();
  }

  // Helper widget to build the main content column (text, buttons, skills)
  Widget _buildContentColumnWidget(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start, // Left align content
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const ReadyToInnovateBadge(), // Reusable component
        const SizedBox(height: 30),
        const MainTitle(), // Reusable component
        const SizedBox(height: 10),
        const AnimatedRoleText(), // Reusable component
        const SizedBox(height: 20),
        const DescriptionParagraph(), // Reusable component
        const SizedBox(height: 30),

        // Skill Chips
        Wrap(
          spacing: 15.0,
          runSpacing: 15.0,
          children: const [
            SkillChip(text: 'React'),
            SkillChip(text: 'Javascript'),
            SkillChip(text: 'Node.js'),
            SkillChip(text: 'Tailwind'),
          ],
        ),
        const SizedBox(height: 40),

        // Buttons
        Row(
          mainAxisSize: MainAxisSize.min, // Keep buttons grouped
          children: [
            ActionButton(
              label: 'Projects',
              icon: Icons.folder_open, // Using Material Icon
              onTap: widget.onProjectTap,
              baseColor: AppColors.primary, // Primary color for Projects
            ),
            const SizedBox(width: 20),
            ActionButton(
              label: 'Contact',
              icon: Icons.mail, // Using Material Icon
              onTap: widget.onContactTap,
              baseColor: AppColors.accent, // Accent color for Contact
            ),
          ],
        ),
        const SizedBox(height: 50), // Space for bottom social icons
        const SocialButtons(), // Reusable component for social media icons
      ],
    );
  }

  // Helper widget to wrap the 3D illustration
  Widget _buildAbstractIllustration(BuildContext context) {
    return SizedBox(
      width: 500, // Fixed width for the illustration canvas
      height: 500, // Fixed height for the illustration canvas
      child: AnimatedAbstractIllustration(
        cursorPosition: widget.cursorPosition, // Pass GLOBAL cursor position for interactivity
      ),
    );
  }

  // Mobile layout: content above illustration, centered
  Widget _buildMobileLayout(BuildContext context) {
    return SingleChildScrollView(
      padding: AppPaddings.sectionPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildContentColumnWidget(context),
          const SizedBox(height: 50),
          _buildAbstractIllustration(context),
        ],
      ),
    );
  }

  // Desktop layout: content and illustration side-by-side
  Widget _buildDesktopLayout(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 48.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.centerLeft,
              child: _buildContentColumnWidget(context),
            ),
          ),
          Expanded(
            flex: 1,
            child: Align(
              alignment: Alignment.centerRight,
              child: _buildAbstractIllustration(context),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Container(
      width: screenSize.width,
      height: screenSize.height,
      child: ResponsiveLayout( // ResponsiveLayout is assumed to be defined elsewhere
        mobileBody: _buildMobileLayout(context),
        tabletBody: _buildDesktopLayout(context), // Reusing for tablet
        desktopBody: _buildDesktopLayout(context),
      ),
    );
  }
}

// --- AnimatedAbstractIllustration: Manages the animation controller and passes it to the painter ---
class AnimatedAbstractIllustration extends StatefulWidget {
  final ValueNotifier<Offset> cursorPosition; // This is now the GLOBAL cursor position

  const AnimatedAbstractIllustration({super.key, required this.cursorPosition});

  @override
  State<AnimatedAbstractIllustration> createState() => _AnimatedAbstractIllustrationState();
}

class _AnimatedAbstractIllustrationState extends State<AnimatedAbstractIllustration> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation; // Drives global rotation and pulsation

  final GlobalKey _customPaintKey = GlobalKey(); // Key to get RenderBox of CustomPaint
  late ValueNotifier<Offset> _localCursorPosition; // Cursor position relative to this CustomPaint

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 20), // Overall animation speed
      vsync: this,
    )..repeat(); // Repeat indefinitely for continuous motion

    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.linear),
    );

    _localCursorPosition = ValueNotifier<Offset>(Offset.zero);

    // Listen to the global cursor position and convert it to local
    widget.cursorPosition.addListener(_updateLocalCursorPosition);

    // Initial calculation after layout is built, and also for window resizes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateLocalCursorPosition();
    });
  }

  void _updateLocalCursorPosition() {
    if (_customPaintKey.currentContext == null) return;

    final RenderBox renderBox = _customPaintKey.currentContext!.findRenderObject() as RenderBox;
    // widget.cursorPosition.value is GLOBAL. Convert it to LOCAL for this CustomPaint.
    // If the global cursor is Offset.zero (meaning it's off the webpage), pass Offset.zero locally.
    if (widget.cursorPosition.value == Offset.zero) {
      _localCursorPosition.value = Offset.zero;
    } else {
      _localCursorPosition.value = renderBox.globalToLocal(widget.cursorPosition.value); // CORRECT CONVERSION
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    widget.cursorPosition.removeListener(_updateLocalCursorPosition);
    _localCursorPosition.dispose(); // Dispose the local ValueNotifier
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Offset>(
      valueListenable: _localCursorPosition, // Listen to the LOCAL cursor position
      builder: (context, localCursorOffset, child) {
        return CustomPaint(
          key: _customPaintKey, // Assign key to CustomPaint
          painter: _AvatarPainter(
            animation: _animation,
            cursorPosition: localCursorOffset, // Pass the LOCAL cursor position to the painter
          ),
          size: Size.infinite,
        );
      },
    );
  }
}

// --- _AvatarPainter: Draws the 3D abstract avatar and handles its interactivity ---
class _AvatarPainter extends CustomPainter {
  final Animation<double> animation;
  final Offset cursorPosition; // This is now the LOCAL cursor position (relative to CustomPaint's top-left)

  _AvatarPainter({
    required this.animation,
    required this.cursorPosition,
  }) : super(repaint: animation);

  // Constants for avatar rendering
  static const double _focalLength = 300.0; // Affects perspective
  static const double _avatarBaseScale = 1.0; // Overall scale of the avatar
  static const double _headRadius = 120.0; // Increased size of the head
  static const double _eyeRadius = 38.0; // Increased white of the eye
  static const double _irisRadius = 23.0; // Increased iris size
  static const double _pupilRadius = 10.0; // Increased pupil size
  static const double _eyeSeparation = 55.0; // Adjusted distance between eyes for larger size and more spacing
  static const double _pupilMovementRange = 12.0; // Increased range for precise pupil movement

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final centerY = size.height / 2;

    // Convert cursor position (which is LOCAL to CustomPaint) to 3D space, relative to the canvas center
    // This 'rawCursor3D' is the cursor's coordinate in the avatar's local 3D space, assuming Z=0
    final Vector3 rawCursor3D = Vector3(
      cursorPosition.dx - centerX,
      cursorPosition.dy - centerY,
      0, // Assume cursor is on the Z=0 plane relative to the canvas center
    );

    // Normalize cursor position relative to the center of the canvas (for head tilt)
    final Offset normalizedCursor = Offset(
      (cursorPosition.dx - centerX) / size.width,
      (cursorPosition.dy - centerY) / size.height,
    );

    canvas.save();
    canvas.translate(centerX, centerY); // Move canvas origin to center for 3D rotations

    // Global rotation for the entire avatar (continuous subtle movement)
    final double globalRotationY = animation.value * pi * 2 * 0.05; // Slow rotation around Y
    final double globalRotationX = sin(animation.value * pi * 2 * 0.2) * 0.05; // Even more gentle sway around X

    // Interaction-based tilt/reorientation for the HEAD itself (very subtle)
    final double interactiveTiltX = -normalizedCursor.dy * pi * 0.03; // Much less responsive head tilt
    final double interactiveTiltY = normalizedCursor.dx * pi * 0.03;

    // Define head's base position (at origin)
    Vector3 headBase = Vector3(0, 0, 0);

    // Apply global and interactive rotations to the head's base position
    Vector3 transformedHead = headBase
        .rotateY(globalRotationY + interactiveTiltY)
        .rotateX(globalRotationX + interactiveTiltX);

    // Project the transformed head center to 2D
    Offset projectedHeadCenter = transformedHead.project(_focalLength, _avatarBaseScale);

    // --- Calculate influence based on cursor proximity to the AVATAR ITSELF ---
    // distanceToAvatarCenter is the distance from the CustomPaint's center (which is also the avatar's conceptual center) to the cursor.
    // This correctly uses rawCursor3D.magnitude as rawCursor3D is already centered.
    final double distanceToAvatarCenter = rawCursor3D.magnitude;

    // Define the radius within which the avatar will be considered "engaged"
    // This is set to be slightly larger than the head radius for a better interaction zone.
    final double engagementRadius = _headRadius * 1.2; // Engage when cursor is within 1.2 times the head radius

    // Calculate influence: 1.0 when cursor is at center of avatar, fades to 0.0 at engagementRadius
    // Only apply influence if cursor is NOT Offset.zero (meaning it's on the CustomPaint)
    final double influence;
    if (cursorPosition == Offset.zero) { // Cursor is off the CustomPaint area
      influence = 0.0;
    } else {
      influence = (1.0 - (distanceToAvatarCenter / engagementRadius)).clamp(0.0, 1.0);
    }


    // --- Draw Interactive Aura/Glow (behind head) ---
    final auraPaint = Paint()
      ..color = AppColors.accent.withOpacity(0.5 + influence * 0.5) // Base opacity 0.5 (always visible), increases up to 1.0 with influence
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, _headRadius * 0.9 + influence * _headRadius * 2.0); // Larger base blur, scales strongly

    canvas.drawCircle(projectedHeadCenter, _headRadius * 1.2, auraPaint); // Larger aura

    // --- Draw Neon Glowing Border around the whole avatar ---
    final avatarBorderGlowPaint = Paint()
      ..color = AppColors.accent.withOpacity(0.7 + influence * 0.3) // Base opacity 0.7 (always visible), increases up to 1.0 with influence
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 30.0 + influence * 50.0) // Wider base blur, dramatically increases with influence
      ..style = PaintingStyle.stroke // Make it a stroke for a border effect
      ..strokeWidth = 8.0 + influence * 10.0; // Thicker base stroke, dramatically increases with influence

    canvas.drawCircle(projectedHeadCenter, _headRadius + 8, avatarBorderGlowPaint); // Draw border slightly outside the head


    // --- Draw Head Shadow (for depth) ---
    final headShadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.2)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 15.0); // Soft blur for shadow
    canvas.drawOval(
      Rect.fromCircle(center: projectedHeadCenter + Offset(0, _headRadius * 0.8), radius: _headRadius * 0.7),
      headShadowPaint,
    );


    // --- Draw Head ---
    final headPaint = Paint()
      ..shader = RadialGradient( // More realistic radial gradient for head
        center: Alignment.topCenter, // Light source from top-center
        radius: 0.9, // Slightly smaller radius for more intense core light
        colors: [
          AppColors.primary.withOpacity(1.0), // Brightest point
          AppColors.primary.withOpacity(0.7), // Mid-tone, slightly less opaque
          AppColors.background.withOpacity(0.9), // Blending with background (darker edges)
        ],
        stops: const [0.0, 0.6, 1.0], // Adjusted stops for smoother transition
      ).createShader(Rect.fromCircle(center: projectedHeadCenter, radius: _headRadius));

    canvas.drawOval(
      Rect.fromCircle(center: projectedHeadCenter, radius: _headRadius),
      headPaint..maskFilter = MaskFilter.blur(BlurStyle.normal, 0.5), // Subtle blur for the head itself
    );

    // --- Draw Eyes ---
    final eyeWhitePaint = Paint()
      ..color = Colors.white.withOpacity(0.9); // Slightly off-white for realism

    final irisPaint = Paint(); // Will use shader
    final pupilPaint = Paint()
      ..color = Colors.black.withOpacity(0.8);

    // Eye positions relative to head center (before head transformation)
    Vector3 leftEyeBase = Vector3(-_eyeSeparation, -_headRadius * 0.2, _headRadius * 0.8);
    Vector3 rightEyeBase = Vector3(_eyeSeparation, -_headRadius * 0.2, _headRadius * 0.8);

    // Transform eye base positions by the *same rotation as the head*
    Vector3 transformedLeftEye = leftEyeBase
        .rotateY(globalRotationY + interactiveTiltY)
        .rotateX(globalRotationX + interactiveTiltX);
    Vector3 transformedRightEye = rightEyeBase
        .rotateY(globalRotationY + interactiveTiltY)
        .rotateX(globalRotationX + interactiveTiltX);

    // Project transformed eye positions
    Offset projectedLeftEye = transformedLeftEye.project(_focalLength, _avatarBaseScale);
    Offset projectedRightEye = transformedRightEye.project(_focalLength, _avatarBaseScale);

    // --- Draw Subtle Eye Glow (behind the white of the eye, reacts to influence) ---
    final eyeGlowPaint = Paint()
      ..color = AppColors.accent.withOpacity(0.3 + influence * 0.5) // Base opacity 0.3, increases up to 0.8 with influence
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, _eyeRadius * 0.9 + influence * 20); // Larger base blur, scales with influence

    canvas.drawCircle(projectedLeftEye, _eyeRadius * 1.2, eyeGlowPaint);
    canvas.drawCircle(projectedRightEye, _eyeRadius * 1.2, eyeGlowPaint);


    // Draw left eye white
    canvas.drawCircle(projectedLeftEye, _eyeRadius, eyeWhitePaint);
    // Draw right eye white
    canvas.drawCircle(projectedRightEye, _eyeRadius, eyeWhitePaint);

    // --- Draw Iris (with radial gradient for depth and vibrancy) ---
    final irisShader = RadialGradient( // Changed to RadialGradient for more consistent depth
      center: Alignment.center,
      radius: 1.0,
      colors: [
        AppColors.accent.withOpacity(0.9), // Inner iris color (more vibrant)
        AppColors.accent.withOpacity(0.7), // Mid iris color
        Colors.black.withOpacity(0.5), // Outer darker edge for depth
      ],
      stops: const [0.0, 0.7, 1.0],
    );

    canvas.drawCircle(projectedLeftEye, _irisRadius, Paint()..shader = irisShader.createShader(Rect.fromCircle(center: projectedLeftEye, radius: _irisRadius)));
    canvas.drawCircle(projectedRightEye, _irisRadius, Paint()..shader = irisShader.createShader(Rect.fromCircle(center: projectedRightEye, radius: _irisRadius)));

    // --- Draw Pupils (following cursor or looking at content) ---
    // Default gaze target: Look towards the content on the left side of the screen.
    // This is relative to the canvas origin (center of the avatar's CustomPaint widget after translation).
    // We adjust the X coordinate to point generally towards the left content section from the avatar's perspective.
    final double contentLookX = -size.width * 0.7; // Adjusted to point further left relative to avatar's center
    final double contentLookY = -size.height * 0.2; // Slightly up
    final Vector3 defaultGazeTarget = Vector3(contentLookX, contentLookY, -_focalLength * 0.2); // Slightly recessed

    final Vector3 finalGazeTarget;

    // If cursor is not active (Offset.zero), default to looking left.
    // Otherwise, precisely target the raw local cursor position.
    if (cursorPosition == Offset.zero) {
      finalGazeTarget = defaultGazeTarget;
    } else {
      finalGazeTarget = rawCursor3D; // rawCursor3D is already cursor pos relative to avatar center
    }

    // Calculate gaze direction from transformed head to final gaze target
    Vector3 gazeDirection = (finalGazeTarget - transformedHead).normalize();

    // Convert normalized gaze direction to 2D offset within the eye
    Offset pupilOffset = Offset(
      gazeDirection.x.clamp(-1.0, 1.0) * _pupilMovementRange,
      gazeDirection.y.clamp(-1.0, 1.0) * _pupilMovementRange,
    );

    // Draw left pupil
    canvas.drawCircle(projectedLeftEye + pupilOffset, _pupilRadius, pupilPaint);
    // Draw right pupil
    canvas.drawCircle(projectedRightEye + pupilOffset, _pupilRadius, pupilPaint);

    // Add refined eye highlights for realism and sparkle
    // Main brightest highlight
    canvas.drawCircle(projectedLeftEye + pupilOffset + Offset(_pupilRadius * 0.8, -_pupilRadius * 0.8), _pupilRadius * 0.4, Paint()..color = Colors.white.withOpacity(0.9));
    // Secondary, slightly larger and blurred reflection
    canvas.drawOval(
      Rect.fromLTWH(
        projectedLeftEye.dx + pupilOffset.dx - _pupilRadius * 0.6,
        projectedLeftEye.dy + pupilOffset.dy + _pupilRadius * 0.3,
        _pupilRadius * 1.2,
        _pupilRadius * 0.4,
      ),
      Paint()..color = Colors.white.withOpacity(0.6)..maskFilter = MaskFilter.blur(BlurStyle.normal, 2.5),
    );
    // Small, sharp highlight for extra sparkle
    canvas.drawCircle(projectedLeftEye + pupilOffset + Offset(_pupilRadius * 0.5, -_pupilRadius * 1.0), _pupilRadius * 0.15, Paint()..color = Colors.white.withOpacity(1.0));

    // Repeat highlights for right eye
    canvas.drawCircle(projectedRightEye + pupilOffset + Offset(_pupilRadius * 0.8, -_pupilRadius * 0.8), _pupilRadius * 0.4, Paint()..color = Colors.white.withOpacity(0.9));
    canvas.drawOval(
      Rect.fromLTWH(
        projectedRightEye.dx + pupilOffset.dx - _pupilRadius * 0.6,
        projectedRightEye.dy + pupilOffset.dy + _pupilRadius * 0.3,
        _pupilRadius * 1.2,
        _pupilRadius * 0.4,
      ),
      Paint()..color = Colors.white.withOpacity(0.6)..maskFilter = MaskFilter.blur(BlurStyle.normal, 2.5),
    );
    canvas.drawCircle(projectedRightEye + pupilOffset + Offset(_pupilRadius * 0.5, -_pupilRadius * 1.0), _pupilRadius * 0.15, Paint()..color = Colors.white.withOpacity(1.0));


    // Optional: Simple mouth (adjust position based on head rotation)
    final mouthWidth = _headRadius * 0.4;
    final mouthHeight = _headRadius * 0.1;
    Offset mouthCenter = projectedHeadCenter + Offset(0, _headRadius * 0.4);

    // Draw an arc for a more expressive mouth
    canvas.drawArc(
      Rect.fromCenter(center: mouthCenter, width: mouthWidth, height: mouthHeight),
      0, // Start angle (radians)
      pi, // Sweep angle (180 degrees for a simple curve)
      false, // Use center
      Paint()..color = Colors.black.withOpacity(0.3)..style = PaintingStyle.stroke..strokeWidth = 2.0,
    );


    canvas.restore(); // Restore canvas
  }

  @override
  bool shouldRepaint(covariant _AvatarPainter oldDelegate) {
    // Repaint if animation value changes or cursor position changes
    return oldDelegate.animation.value != animation.value || oldDelegate.cursorPosition != cursorPosition;
  }
}

// Extension to normalize an offset (make its length 1)
extension on Offset {
  Offset normalize() {
    final double length = distance;
    return length == 0 ? Offset.zero : Offset(dx / length, dy / length);
  }
}
