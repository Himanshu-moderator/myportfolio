// lib/screens/home_page.dart
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:three_d_portfolio/screens/about_section.dart';
import 'package:three_d_portfolio/screens/contact_section.dart';
import 'package:three_d_portfolio/widgets/footer_section.dart';
import 'package:three_d_portfolio/widgets/global_animated_background.dart';
import 'package:three_d_portfolio/hero/hero_section.dart';
import 'package:three_d_portfolio/widgets/navbar.dart';
import 'package:three_d_portfolio/screens/portfolio_section.dart';
import 'package:three_d_portfolio/widgets/section_animator.dart';
import 'package:three_d_portfolio/screens/skill_section.dart';

// This page uses true discrete paging (one section fully occupies the screen
// at a time) rather than continuous free scroll. Section-to-section movement
// is a slow slide-and-fade: the outgoing section slides out (up if moving to
// a later section, down if moving to an earlier one) while the incoming
// section slides in from the opposite edge, both fading as they go. That
// keeps the felt motion of scrolling without ever having two sections fully
// resting on screen together. Scrolling/dragging within a section that's
// taller than the screen (About, Skills, Portfolio) works normally via that
// section's own
// inner scroll view; only once you scroll past ITS top or bottom edge does
// that turn into a page change, detected via OverscrollNotification rather
// than by fighting over the drag gesture itself (relying on a nested
// scrollable to "hand off" an in-progress drag once it hits its own edge is
// exactly the mechanism that caused the mobile scroll-lock bug fixed earlier
// this session - this sidesteps that class of bug entirely).
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const int _sectionCount = 5;

  // How long the slide-and-fade between two sections takes, and its easing.
  // Slow enough that the outgoing section visibly dims and slides away before
  // the incoming one fades up from the opposite edge, quick enough to still
  // feel responsive rather than sluggish.
  static const Duration _transitionDuration = Duration(milliseconds: 850);
  static const Curve _transitionCurve = Curves.easeInOut;

  final List<GlobalKey<SectionAnimatorState>> _sectionKeys = List.generate(
    _sectionCount,
    (_) => GlobalKey<SectionAnimatorState>(),
  );
  // One per page, so wheel input can be checked against that page's own
  // scroll position directly (see _handlePointerSignal) - mouse wheel
  // scrolling that's already clamped at a boundary does not reliably
  // dispatch OverscrollNotification the way a drag gesture does, so
  // OverscrollNotification alone isn't enough to detect "wants next page"
  // for wheel/trackpad users.
  final List<ScrollController> _innerControllers = List.generate(
    _sectionCount,
    (_) => ScrollController(),
  );
  int _currentSectionIndex = 0;
  final ValueNotifier<Offset> _cursorPosition = ValueNotifier<Offset>(
    Offset.zero,
  );

  // Guards against a single continued drag/fling generating more than one
  // page change from repeated overscroll notifications.
  DateTime? _lastPageTurn;

  // True for the duration of the crossfade. A single fast fling or multi-tick
  // wheel scroll delivers several pointer signals in quick succession - only
  // the first should trigger the page turn, but the rest would otherwise
  // still reach the currently hit-tested SingleChildScrollView and scroll it
  // away from the top mid-fade. Absorbing pointer input for the transition's
  // duration (see build()) prevents that leakage.
  bool _isTransitioning = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _sectionKeys[0].currentState?.playAnimation();
    });
  }

  @override
  void dispose() {
    for (final controller in _innerControllers) {
      controller.dispose();
    }
    _cursorPosition.dispose();
    super.dispose();
  }

  void _goToPage(int index) {
    if (index == _currentSectionIndex || _isTransitioning) return;
    final outgoingIndex = _currentSectionIndex;

    setState(() {
      _isTransitioning = true;
      _currentSectionIndex = index;
    });
    // Starts the incoming section's own slide-and-fade-in immediately, so it
    // reaches full opacity roughly alongside the outer crossfade.
    _sectionKeys[index].currentState?.playAnimation();

    Future.delayed(_transitionDuration, () {
      if (!mounted) return;
      // The outgoing section is only reset (snapped back to its hidden,
      // pre-animation state) once it has fully faded out - resetting it
      // immediately would make it vanish instantly instead of fading, since
      // its own opacity is multiplied into the outer crossfade opacity.
      _sectionKeys[outgoingIndex].currentState?.resetAnimation();
      // Always land at the top of the destination section, regardless of any
      // scroll it may have accumulated the last time it was visible.
      final controller = _innerControllers[index];
      if (controller.hasClients) {
        controller.jumpTo(0);
      }
      setState(() {
        _isTransitioning = false;
      });
    });
  }

  // Called whenever a section's own inner scroll view is dragged/scrolled
  // past its top or bottom edge. A large-enough overscroll in either
  // direction is treated as "the user wants the next/previous section."
  void _handleOverscroll(int sectionIndex, double overscroll) {
    final now = DateTime.now();
    if (_lastPageTurn != null &&
        now.difference(_lastPageTurn!) < _transitionDuration) {
      return;
    }

    // A deliberately generous buffer: a normal scroll that merely reaches a
    // section's edge (or a tiny accidental overshoot) shouldn't page-turn -
    // only a clear, continued scroll past the edge should.
    const threshold = 30.0;
    if (overscroll > threshold && sectionIndex < _sectionCount - 1) {
      _lastPageTurn = now;
      _goToPage(sectionIndex + 1);
    } else if (overscroll < -threshold && sectionIndex > 0) {
      _lastPageTurn = now;
      _goToPage(sectionIndex - 1);
    }
  }

  // Mouse wheel / trackpad input arrives as a PointerScrollEvent rather than
  // a drag. When the target page's own scroll position is already at its
  // boundary and the wheel keeps scrolling in that same direction, treat it
  // the same as an overscroll drag - checked directly against that page's
  // ScrollController rather than relying on OverscrollNotification, which a
  // clamped/bounced wheel scroll does not reliably dispatch.
  void _handleWheelSignal(int index, PointerSignalEvent event) {
    if (event is! PointerScrollEvent) return;
    final controller = _innerControllers[index];
    if (!controller.hasClients) return;
    final position = controller.position;
    final deltaY = event.scrollDelta.dy;

    if (deltaY > 0 && position.pixels >= position.maxScrollExtent - 1.0) {
      _handleOverscroll(index, deltaY);
    } else if (deltaY < 0 &&
        position.pixels <= position.minScrollExtent + 1.0) {
      _handleOverscroll(index, deltaY);
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
        onNavItemTap: _goToPage,
        currentSectionIndex: _currentSectionIndex,
      ),
      body: Stack(
        children: [
          // Background is ignored for hit-testing so it never blocks scrolling.
          // Positioned must be Stack's direct child - IgnorePointer goes
          // inside it, not the other way around (which throws an
          // "incompatible ParentData" exception on every frame).
          Positioned.fill(
            child: IgnorePointer(
              child: GlobalAnimatedBackground(cursorPosition: _cursorPosition),
            ),
          ),

          // The Listener captures mouse/touch movement for the 3D effect
          Listener(
            onPointerHover: _handlePointerEvent,
            onPointerMove: _handlePointerEvent,
            onPointerDown: _handlePointerEvent,
            behavior: HitTestBehavior.translucent,
            // Swallows pointer input (wheel ticks, drags) for the duration of
            // the transition, so a fast fling/scroll can't leak past the
            // first tick into whichever inner SingleChildScrollView is
            // currently hit-tested (see _isTransitioning/_goToPage).
            child: AbsorbPointer(
              absorbing: _isTransitioning,
              // All 5 sections are stacked in the same place; only the
              // current one is at full opacity, resting position, and
              // interactive. Moving between sections slides + fades them
              // (see _buildFadingPage/_restOffset) rather than jumping
              // instantly, so it keeps the felt motion of scrolling.
              child: Stack(
                children: [
                  _buildFadingPage(
                    0,
                    HeroSection(
                      onProjectTap: () => _goToPage(3),
                      onContactTap: () => _goToPage(4),
                      cursorPosition: _cursorPosition,
                    ),
                    isHero: true,
                  ),
                  _buildFadingPage(1, const AboutSection()),
                  _buildFadingPage(2, const SkillSection()),
                  _buildFadingPage(3, const PortfolioSection()),
                  _buildFadingPage(
                    4,
                    const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [ContactSection(), FooterSection()],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // A section not currently on screen rests just above or just below the
  // viewport depending on which side of the active section it's on - above
  // (already scrolled past) if it comes earlier, below (not reached yet) if
  // it comes later. That's what makes the transition read as scrolling: the
  // outgoing section continues moving the same direction off one edge while
  // the incoming section arrives from the other.
  Offset _restOffset(int index) {
    if (index == _currentSectionIndex) return Offset.zero;
    return index < _currentSectionIndex
        ? const Offset(0, -1)
        : const Offset(0, 1);
  }

  // Wraps a page so it slides and crossfades in/out as it becomes the active
  // section, and stays out of the hit-test tree while it's not active (so its
  // offscreen inner scroll view can't intercept input meant for the visible
  // page underneath).
  Widget _buildFadingPage(int index, Widget child, {bool isHero = false}) {
    final bool isActive = index == _currentSectionIndex;
    return Positioned.fill(
      child: IgnorePointer(
        ignoring: !isActive,
        child: AnimatedSlide(
          offset: _restOffset(index),
          duration: _transitionDuration,
          curve: _transitionCurve,
          child: AnimatedOpacity(
            opacity: isActive ? 1.0 : 0.0,
            duration: _transitionDuration,
            curve: _transitionCurve,
            child: _buildPage(index, child, isHero: isHero),
          ),
        ),
      ),
    );
  }

  // Each page is one full-screen section. Its content sits in its own
  // scroll view so sections taller than the screen (About, Skills,
  // Portfolio) can be scrolled through normally; overscrolling past that
  // section's own top/bottom edge is what triggers moving to the
  // next/previous page.
  Widget _buildPage(int index, Widget child, {bool isHero = false}) {
    return NotificationListener<OverscrollNotification>(
      // Covers touch drag: dragging past this page's edge reliably
      // dispatches OverscrollNotification.
      onNotification: (notification) {
        _handleOverscroll(index, notification.overscroll);
        return false;
      },
      child: Listener(
        // Covers mouse wheel / trackpad: see _handleWheelSignal for why
        // OverscrollNotification alone doesn't cover this input type.
        onPointerSignal: (event) => _handleWheelSignal(index, event),
        child: SingleChildScrollView(
          controller: _innerControllers[index],
          // AlwaysScrollableScrollPhysics is required even though this
          // section may not need to scroll at all (content shorter than the
          // viewport, e.g. Hero) - without it, a SingleChildScrollView with
          // zero scroll extent simply doesn't process scroll/drag input at
          // all.
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          child: SectionAnimator(
            key: _sectionKeys[index],
            // Hero section uses your custom duration and curve, others use defaults
            animationDuration: isHero
                ? const Duration(milliseconds: 1000)
                : const Duration(milliseconds: 900),
            slideOffset: isHero ? const Offset(0, 50) : const Offset(0, 45),
            curve: isHero ? Curves.easeOutExpo : Curves.easeOutCubic,
            child: child,
          ),
        ),
      ),
    );
  }
}
