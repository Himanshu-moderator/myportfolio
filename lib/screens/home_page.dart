// lib/screens/home_page.dart
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../utils/constants.dart';
import '../widgets/about_section.dart';
import '../widgets/contact_section.dart';
import '../widgets/footer_section.dart';
import '../widgets/global_animated_background.dart';
import '../widgets/hero_section.dart';
import '../widgets/navbar.dart';
import '../widgets/portfolio_section.dart';
import '../widgets/section_animator.dart';
import '../widgets/skill_section.dart'; // Import the global background

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late AutoScrollController _scrollController;
  final List<GlobalKey<SectionAnimatorState>> _sectionKeys = List.generate(5, (_) => GlobalKey<SectionAnimatorState>());
  int _currentSectionIndex = 0;
  // Use ValueNotifier to pass cursor position to the background painter
  final ValueNotifier<Offset> _cursorPosition = ValueNotifier<Offset>(Offset.zero); // Stores GLOBAL cursor position

  @override
  void initState() {
    super.initState();
    _scrollController = AutoScrollController(
      viewportBoundaryGetter: () => Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom),
      axis: Axis.vertical,
    );

    // Trigger animation for the first section (HeroSection) on initial load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _sectionKeys[0].currentState?.playAnimation();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _cursorPosition.dispose(); // Dispose the ValueNotifier
    super.dispose();
  }

  void _scrollToIndex(int index) {
    setState(() {
      _currentSectionIndex = index;
    });
    _sectionKeys[index].currentState?.resetAnimation();
    _scrollController.scrollToIndex(
      index,
      preferPosition: AutoScrollPosition.begin,
      duration: AppDurations.scrollAnimation,
    ).then((_) {
      _sectionKeys[index].currentState?.playAnimation();
    });
  }

  void _onSectionVisibilityChanged(int index, VisibilityInfo info) {
    if (info.visibleFraction > 0.5 && _sectionKeys[index].currentState?.controller.status != AnimationStatus.completed) {
      _sectionKeys[index].currentState?.playAnimation();
      if (_currentSectionIndex != index) {
        setState(() {
          _currentSectionIndex = index;
        });
      }
    } else if (info.visibleFraction < 0.1 && _sectionKeys[index].currentState?.controller.status == AnimationStatus.completed) {
      _sectionKeys[index].currentState?.resetAnimation();
    }
  }

  // Handle pointer events (mouse hover, touch move)
  void _handlePointerEvent(PointerEvent event) {
    // IMPORTANT: Use event.position (global) here
    if (event is PointerHoverEvent || event is PointerMoveEvent || event is PointerDownEvent) {
      _cursorPosition.value = event.position; // Store GLOBAL position
    } else if (event is PointerExitEvent) {
      _cursorPosition.value = Offset.zero; // Reset to zero when cursor leaves the entire Listener area
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomNavBar(
        scrollController: _scrollController,
        onNavItemTap: _scrollToIndex,
        currentSectionIndex: _currentSectionIndex,
      ),
      body: Listener( // Capture all pointer events within the body
        onPointerHover: _handlePointerEvent,
        onPointerMove: _handlePointerEvent,
        onPointerDown: _handlePointerEvent, // Capture initial touch/click
        child: Stack( // Use a Stack to layer the background and content
          children: [
            // Global Animated Background (always visible, covers full screen)
            Positioned.fill(
              child: GlobalAnimatedBackground(
                cursorPosition: _cursorPosition, // Pass the GLOBAL cursor position
              ),
            ),

            // Scrollable content on top of the background
            SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: [
                  // Home Section
                  AutoScrollTag(
                    key: _sectionKeys[0],
                    controller: _scrollController,
                    index: 0,
                    child: VisibilityDetector(
                      key: const Key('section_0'),
                      onVisibilityChanged: (info) => _onSectionVisibilityChanged(0, info),
                      child: SectionAnimator(
                        key: _sectionKeys[0],
                        animationDuration: const Duration(milliseconds: 1000),
                        slideOffset: const Offset(0, 50),
                        curve: Curves.easeOutExpo,
                        child: HeroSection(
                          onProjectTap: () => _scrollToIndex(3), // Index for PortfolioSection
                          onContactTap: () => _scrollToIndex(4), // Index for ContactSection
                          cursorPosition: _cursorPosition, // Pass GLOBAL cursor for local 3D effect in HeroSection
                        ),
                      ),
                    ),
                  ),
                  // About Section
                  AutoScrollTag(
                    key: _sectionKeys[1],
                    controller: _scrollController,
                    index: 1,
                    child: VisibilityDetector(
                      key: const Key('section_1'),
                      onVisibilityChanged: (info) => _onSectionVisibilityChanged(1, info),
                      child: SectionAnimator(
                        key: _sectionKeys[1],
                        child: const AboutSection(),
                      ),
                    ),
                  ),
                  // Skill Section
                  AutoScrollTag(
                    key: _sectionKeys[2],
                    controller: _scrollController,
                    index: 2,
                    child: VisibilityDetector(
                      key: const Key('section_2'),
                      onVisibilityChanged: (info) => _onSectionVisibilityChanged(2, info),
                      child: SectionAnimator(
                        key: _sectionKeys[2],
                        child: const SkillSection(),
                      ),
                    ),
                  ),
                  // Portfolio Section
                  AutoScrollTag(
                    key: _sectionKeys[3],
                    controller: _scrollController,
                    index: 3,
                    child: VisibilityDetector(
                      key: const Key('section_3'),
                      onVisibilityChanged: (info) => _onSectionVisibilityChanged(3, info),
                      child: SectionAnimator(
                        key: _sectionKeys[3],
                        child: const PortfolioSection(),
                      ),
                    ),
                  ),
                  // Contact Section
                  AutoScrollTag(
                    key: _sectionKeys[4],
                    controller: _scrollController,
                    index: 4,
                    child: VisibilityDetector(
                      key: const Key('section_4'),
                      onVisibilityChanged: (info) => _onSectionVisibilityChanged(4, info),
                      child: SectionAnimator(
                        key: _sectionKeys[4],
                        child: const ContactSection(),
                      ),
                    ),
                  ),
                  const FooterSection(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
