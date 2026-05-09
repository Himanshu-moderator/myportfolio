// lib/screens/splash_screen.dart
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:animated_text_kit/animated_text_kit.dart'; // Import for typing effect
import 'dart:math';
import '../utils/constants.dart';
import 'home_page.dart'; // For pi for subtle icon animations

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _mainAnimationController;
  late Animation<double> _fadeOutAnimation;

  // Icon Controllers (now includes slide for dropping effect)
  late AnimationController _icon1Controller;
  late Animation<double> _icon1Scale;
  late Animation<double> _icon1Rotation;
  late Animation<Offset> _icon1Slide;

  late AnimationController _icon2Controller;
  late Animation<double> _icon2Scale;
  late Animation<double> _icon2Rotation;
  late Animation<Offset> _icon2Slide;

  late AnimationController _icon3Controller;
  late Animation<double> _icon3Scale;
  late Animation<double> _icon3Rotation;
  late Animation<Offset> _icon3Slide;

  // Text "Welcome To My"
  late AnimationController _textWelcomeController;
  late Animation<double> _textWelcomeOpacity;
  late Animation<Offset> _textWelcomeSlide; // From left

  // Text "Portfolio Website" (now combined into one animation)
  late AnimationController _textPortfolioWebsiteController;
  late Animation<double> _textPortfolioWebsiteOpacity;
  late Animation<Offset> _textPortfolioWebsiteSlide; // From right

  // Domain Name (for typing effect)
  late AnimationController _domainTextContainerController; // Controls visibility (fade) of the container
  late Animation<double> _domainTextContainerOpacity;

  // Removed _domainTypingEffectController as it's not needed with this approach.

  @override
  void initState() {
    super.initState();

    // Main controller for overall fade out at the end
    _mainAnimationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeOutAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _mainAnimationController, curve: Curves.easeOut),
    );

    // Icon Controllers - Dropping from upward
    _icon1Controller = AnimationController(duration: const Duration(milliseconds: 600), vsync: this);
    _icon1Scale = Tween<double>(begin: 0.5, end: 1.0).animate(CurvedAnimation(parent: _icon1Controller, curve: Curves.easeOutBack));
    _icon1Rotation = Tween<double>(begin: -pi / 4, end: 0.0).animate(CurvedAnimation(parent: _icon1Controller, curve: Curves.easeOutCubic));
    _icon1Slide = Tween<Offset>(begin: const Offset(0, -100), end: Offset.zero).animate(CurvedAnimation(parent: _icon1Controller, curve: Curves.easeOutBack));

    _icon2Controller = AnimationController(duration: const Duration(milliseconds: 600), vsync: this);
    _icon2Scale = Tween<double>(begin: 0.5, end: 1.0).animate(CurvedAnimation(parent: _icon2Controller, curve: Curves.easeOutBack));
    _icon2Rotation = Tween<double>(begin: pi / 4, end: 0.0).animate(CurvedAnimation(parent: _icon2Controller, curve: Curves.easeOutCubic));
    _icon2Slide = Tween<Offset>(begin: const Offset(0, -100), end: Offset.zero).animate(CurvedAnimation(parent: _icon2Controller, curve: Curves.easeOutBack));

    _icon3Controller = AnimationController(duration: const Duration(milliseconds: 600), vsync: this);
    _icon3Scale = Tween<double>(begin: 0.5, end: 1.0).animate(CurvedAnimation(parent: _icon3Controller, curve: Curves.easeOutBack));
    _icon3Rotation = Tween<double>(begin: -pi / 4, end: 0.0).animate(CurvedAnimation(parent: _icon3Controller, curve: Curves.easeOutCubic));
    _icon3Slide = Tween<Offset>(begin: const Offset(0, -100), end: Offset.zero).animate(CurvedAnimation(parent: _icon3Controller, curve: Curves.easeOutBack));

    // Text "Welcome To My" - from left (animation duration increased)
    _textWelcomeController = AnimationController(duration: const Duration(milliseconds: 1000), vsync: this);
    _textWelcomeOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _textWelcomeController, curve: Curves.easeOutCubic));
    _textWelcomeSlide = Tween<Offset>(begin: const Offset(-0.3, 0), end: Offset.zero).animate(CurvedAnimation(parent: _textWelcomeController, curve: Curves.easeOutCubic));

    // Text "Portfolio Website" - from right (combined, animation duration increased)
    _textPortfolioWebsiteController = AnimationController(duration: const Duration(milliseconds: 1000), vsync: this);
    _textPortfolioWebsiteOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _textPortfolioWebsiteController, curve: Curves.easeOutCubic));
    _textPortfolioWebsiteSlide = Tween<Offset>(begin: const Offset(0.3, 0), end: Offset.zero).animate(CurvedAnimation(parent: _textPortfolioWebsiteController, curve: Curves.easeOutCubic));

    // Domain Name fade-in controller
    _domainTextContainerController = AnimationController(duration: const Duration(milliseconds: 700), vsync: this);
    _domainTextContainerOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _domainTextContainerController, curve: Curves.easeIn));

    _startAnimationsSequence();
  }

  void _startAnimationsSequence() async {
    // Icons animate in sequentially with a drop effect
    await Future.delayed(const Duration(milliseconds: 300));
    _icon1Controller.forward();
    await Future.delayed(const Duration(milliseconds: 200)); // Stagger more
    _icon2Controller.forward();
    await Future.delayed(const Duration(milliseconds: 200)); // Stagger more
    _icon3Controller.forward();

    // "Welcome To My" text
    await Future.delayed(const Duration(milliseconds: 700)); // Wait for icons to settle
    _textWelcomeController.forward();

    // "Portfolio Website" text
    await Future.delayed(const Duration(milliseconds: 800)); // Stagger after "Welcome To My" for slower effect
    _textPortfolioWebsiteController.forward();

    // Domain name fade-in starts after Portfolio Website is settled
    await Future.delayed(const Duration(milliseconds: 1000)); // Wait for Portfolio Website to settle and then some
    _domainTextContainerController.forward(); // Start fading in the domain container

    // After all animations complete, wait a bit then navigate
    // This delay needs to account for all previous animations + typing duration
    await Future.delayed(const Duration(seconds: 4)); // Total display time adjusted for new animations
    _mainAnimationController.forward().then((_) {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 500),
            pageBuilder: (context, animation, secondaryAnimation) => FadeTransition(
              opacity: animation,
              child: const HomePage(),
            ),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _mainAnimationController.dispose();
    _icon1Controller.dispose();
    _icon2Controller.dispose();
    _icon3Controller.dispose();
    _textWelcomeController.dispose();
    _textPortfolioWebsiteController.dispose();
    _domainTextContainerController.dispose();
    // Removed _domainTypingEffectController dispose
    super.dispose();
  }

  Widget _buildAnimatedIcon(AnimationController controller, Animation<double> scale, Animation<double> rotation, Animation<Offset> slide, IconData icon) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Opacity(
          opacity: controller.value,
          child: Transform.translate(
            offset: slide.value, // Apply slide translation
            child: Transform.scale(
              scale: scale.value,
              child: Transform.rotate(
                angle: rotation.value,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.cardBackground.withOpacity(0.8),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(controller.value * 0.4), // Stronger neon glow
                        blurRadius: 20, // Increased blur for glow
                        spreadRadius: 8, // Increased spread
                      ),
                    ],
                  ),
                  child: FaIcon(
                    icon,
                    color: AppColors.primary.withOpacity(controller.value),
                    size: 30,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FadeTransition(
        opacity: _fadeOutAnimation,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.background,
                AppColors.cardBackground,
              ],
            ),
            // Added radial gradient for central glow effect
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.1),
                blurRadius: 100,
                spreadRadius: 50,
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Center the whole column
            children: [
              // Adjusted SizedBox height for icon positioning to match reference
              SizedBox(height: MediaQuery.of(context).size.height * 0.22), // Tighter spacing from top

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildAnimatedIcon(_icon1Controller, _icon1Scale, _icon1Rotation, _icon1Slide, FontAwesomeIcons.code),
                  const SizedBox(width: 20),
                  _buildAnimatedIcon(_icon2Controller, _icon2Scale, _icon2Rotation, _icon2Slide, FontAwesomeIcons.user),
                  const SizedBox(width: 20),
                  _buildAnimatedIcon(_icon3Controller, _icon3Scale, _icon3Rotation, _icon3Slide, FontAwesomeIcons.github),
                ],
              ),
              const SizedBox(height: 50), // Reduced space between icons and first text line

              AnimatedBuilder(
                animation: _textWelcomeController,
                builder: (context, child) {
                  return Opacity(
                    opacity: _textWelcomeOpacity.value,
                    child: Transform.translate(
                      offset: _textWelcomeSlide.value * (MediaQuery.of(context).size.width / 4), // Scale offset by fraction of screen width
                      child: Text(
                        'Welcome To My',
                        style: Theme.of(context).textTheme.displayMedium!.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.bold,
                          shadows: [ // Neon effect for text
                            Shadow(
                              color: AppColors.textPrimary.withOpacity(_textWelcomeOpacity.value * 0.7),
                              blurRadius: 15,
                            ),
                            Shadow(
                              color: AppColors.textPrimary.withOpacity(_textWelcomeOpacity.value * 0.4),
                              blurRadius: 30,
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 10), // Reduced spacing
              AnimatedBuilder(
                animation: _textPortfolioWebsiteController, // Use the combined controller
                builder: (context, child) {
                  return Opacity(
                    opacity: _textPortfolioWebsiteOpacity.value,
                    child: Transform.translate(
                      offset: _textPortfolioWebsiteSlide.value * (MediaQuery.of(context).size.width / 4), // Scale offset by fraction of screen width
                      child: Text(
                        'Portfolio Website', // Combined text
                        style: Theme.of(context).textTheme.displayLarge!.copyWith(
                          color: AppColors.primary, // Distinct color
                          fontWeight: FontWeight.bold,
                          shadows: [ // Neon effect for text
                            Shadow(
                              color: AppColors.primary.withOpacity(_textPortfolioWebsiteOpacity.value * 0.8),
                              blurRadius: 20,
                            ),
                            Shadow(
                              color: AppColors.primary.withOpacity(_textPortfolioWebsiteOpacity.value * 0.5),
                              blurRadius: 40,
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 30), // Spacing between Portfolio Website and Domain Name

              AnimatedBuilder(
                animation: _domainTextContainerController,
                builder: (context, child) {
                  return Opacity(
                    opacity: _domainTextContainerOpacity.value, // Fade in the container for typing text
                    child: Row( // Use Row for the globe icon and text
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FaIcon(FontAwesomeIcons.globe, size: 25, color: AppColors.textSecondary.withOpacity(_domainTextContainerOpacity.value)), // Larger globe icon
                        const SizedBox(width: 10), // Increased spacing
                        // Conditionally render AnimatedTextKit based on fade-in completion
                        if (_domainTextContainerController.status == AnimationStatus.completed)
                          DefaultTextStyle(
                            style: Theme.of(context).textTheme.headlineMedium!.copyWith( // Increased font size for domain
                              color: AppColors.textSecondary, // Color is now fixed, opacity handled by parent Opacity
                              shadows: [ // Neon effect for domain text
                                Shadow(
                                  color: AppColors.accent.withOpacity(0.6), // Fixed opacity for shadows
                                  blurRadius: 10,
                                ),
                                Shadow(
                                  color: AppColors.accent.withOpacity(0.3), // Fixed opacity for shadows
                                  blurRadius: 20,
                                ),
                              ],
                            ),
                            child: AnimatedTextKit(
                              animatedTexts: [
                                TypewriterAnimatedText(
                                  'www.hc_alpha.com', // Customize your domain here
                                  speed: const Duration(milliseconds: 80), // Slightly faster typing speed
                                  curve: Curves.easeInCubic,
                                ),
                              ],
                              isRepeatingAnimation: false, // Play only once
                              onFinished: () {
                                // This callback fires when typing is done, but the overall navigation is timed
                                // by the Future.delayed in _startAnimationsSequence.
                              },
                              // No 'play' property needed here. AnimatedTextKit starts when built.
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
              const Spacer(), // Pushes remaining space below domain name
            ],
          ),
        ),
      ),
    );
  }
}
