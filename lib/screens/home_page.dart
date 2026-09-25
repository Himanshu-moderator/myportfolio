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
import '../widgets/skill_section.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late AutoScrollController _scrollController;
  final List<GlobalKey<SectionAnimatorState>> _sectionKeys =
  List.generate(5, (_) => GlobalKey<SectionAnimatorState>());
  int _currentSectionIndex = 0;
  final ValueNotifier<Offset> _cursorPosition = ValueNotifier<Offset>(Offset.zero);

  @override
  void initState() {
    super.initState();
    _scrollController = AutoScrollController(
      viewportBoundaryGetter: () =>
          Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom),
      axis: Axis.vertical,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _sectionKeys[0].currentState?.playAnimation();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _cursorPosition.dispose();
    super.dispose();
  }

  void _scrollToIndex(int index) {
    setState(() {
      _currentSectionIndex = index;
    });
    _sectionKeys[index].currentState?.resetAnimation();
    _scrollController
        .scrollToIndex(
      index,
      preferPosition: AutoScrollPosition.begin,
      duration: AppDurations.scrollAnimation,
    )
        .then((_) {
      _sectionKeys[index].currentState?.playAnimation();
    });
  }

  void _onSectionVisibilityChanged(int index, VisibilityInfo info) {
    // Play threshold is a small fraction (not >0.5) because visibleFraction is
    // relative to the SECTION's own height, not the viewport. Sections taller
    // than one screen (e.g. Portfolio's stacked project cards on mobile) can
    // scroll fully across the viewport while never showing more than half of
    // their own total height at once, so a >0.5 requirement could leave them
    // permanently un-animated. The reset threshold is likewise tightened to
    // "essentially fully gone" so a tall section can't trigger then get reset
    // again within the same scroll motion before it settles on screen.
    if (info.visibleFraction > 0.05 &&
        _sectionKeys[index].currentState?.controller.status !=
            AnimationStatus.completed) {
      _sectionKeys[index].currentState?.playAnimation();
      if (_currentSectionIndex != index) {
        setState(() {
          _currentSectionIndex = index;
        });
      }
    } else if (info.visibleFraction <= 0.0 &&
        _sectionKeys[index].currentState?.controller.status ==
            AnimationStatus.completed) {
      _sectionKeys[index].currentState?.resetAnimation();
    }
  }

  void _handlePointerEvent(PointerEvent event) {
    if (event is PointerHoverEvent ||
        event is PointerMoveEvent ||
        event is PointerDownEvent) {
      _cursorPosition.value = event.position;
    } else if (event is PointerExitEvent) {
      _cursorPosition.value = Offset.zero;
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
      body: Stack(
        children: [
          // Background is ignored for hit-testing so it never blocks scrolling
          IgnorePointer(
            child: Positioned.fill(
              child: GlobalAnimatedBackground(
                cursorPosition: _cursorPosition,
              ),
            ),
          ),

          // The Listener captures mouse/touch movement for the 3D effect
          Listener(
            onPointerHover: _handlePointerEvent,
            onPointerMove: _handlePointerEvent,
            onPointerDown: _handlePointerEvent,
            behavior: HitTestBehavior.translucent,
            child: SingleChildScrollView(
              controller: _scrollController,
              // AlwaysScrollableScrollPhysics ensures the scroll view is active
              // even if the content hasn't fully calculated its height yet
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              child: Column(
                children: [
                  // Hero Section
                  _buildSectionTag(0, HeroSection(
                    onProjectTap: () => _scrollToIndex(3),
                    onContactTap: () => _scrollToIndex(4),
                    cursorPosition: _cursorPosition,
                  ), isHero: true),

                  // Other Sections
                  _buildSectionTag(1, const AboutSection()),
                  _buildSectionTag(2, const SkillSection()),
                  _buildSectionTag(3, const PortfolioSection()),
                  _buildSectionTag(4, const ContactSection()),

                  const FooterSection(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTag(int index, Widget child, {bool isHero = false}) {
    return AutoScrollTag(
      key: _sectionKeys[index],
      controller: _scrollController,
      index: index,
      child: VisibilityDetector(
        key: Key('section_$index'),
        onVisibilityChanged: (info) => _onSectionVisibilityChanged(index, info),
        child: SectionAnimator(
          key: _sectionKeys[index],
          // Hero section uses your custom duration and curve, others use defaults
          animationDuration: isHero ? const Duration(milliseconds: 1000) : const Duration(milliseconds: 800),
          slideOffset: isHero ? const Offset(0, 50) : const Offset(0, 30),
          curve: isHero ? Curves.easeOutExpo : Curves.easeInOut,
          child: child,
        ),
      ),
    );
  }
}