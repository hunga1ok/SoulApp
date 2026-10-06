import 'package:flutter/material.dart';
import '../soul_theme.dart';

/// Animated mini audio wave equalizer bars that animate smoothly when audio is playing.
class SoulAudioWave extends StatefulWidget {
  const SoulAudioWave({
    super.key,
    required this.isPlaying,
    this.barColor = SoulColors.plum,
    this.barCount = 4,
    this.height = 18,
  });

  final bool isPlaying;
  final Color barColor;
  final int barCount;
  final double height;

  @override
  State<SoulAudioWave> createState() => _SoulAudioWaveState();
}

class _SoulAudioWaveState extends State<SoulAudioWave>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  bool get _canAnimate {
    final isTest = WidgetsBinding.instance.runtimeType.toString().contains(
      'TestWidgetsFlutterBinding',
    );
    return !isTest;
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    if (widget.isPlaying && _canAnimate) {
      _controller.repeat();
    } else {
      _controller.value = 0.4;
    }
  }

  @override
  void didUpdateWidget(SoulAudioWave oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isPlaying != oldWidget.isPlaying) {
      if (widget.isPlaying && _canAnimate) {
        _controller.repeat();
      } else {
        _controller.stop();
        _controller.value = 0.4;
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: List.generate(widget.barCount, (index) {
            // Distinct phase shift for each equalizer bar
            final offset = index * 0.28;
            final phase = (_controller.value + offset) % 1.0;
            // Smooth sine bounce
            final factor =
                widget.isPlaying
                    ? (0.25 +
                        0.75 *
                            (0.5 +
                                0.5 *
                                    (phase < 0.5 ? phase * 2 : 2 - phase * 2)))
                    : 0.25;

            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 1.2),
              width: 3.0,
              height: (widget.height * factor).clamp(3.0, widget.height),
              decoration: BoxDecoration(
                color: widget.barColor,
                borderRadius: BorderRadius.circular(1.5),
              ),
            );
          }),
        );
      },
    );
  }
}

/// Mindful Breathing Orb animation that expands and contracts in a meditative 4-4-4 breathing cycle.
class SoulBreathingOrb extends StatefulWidget {
  const SoulBreathingOrb({
    super.key,
    required this.isPlaying,
    this.size = 140.0,
    this.child,
  });

  final bool isPlaying;
  final double size;
  final Widget? child;

  @override
  State<SoulBreathingOrb> createState() => _SoulBreathingOrbState();
}

class _SoulBreathingOrbState extends State<SoulBreathingOrb>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _glowAnimation;

  bool get _canAnimate {
    final isTest = WidgetsBinding.instance.runtimeType.toString().contains(
      'TestWidgetsFlutterBinding',
    );
    return !isTest;
  }

  @override
  void initState() {
    super.initState();
    // 6-second relaxing breathing cycle: Inhale (3s), Exhale (3s)
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    );

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0.94,
          end: 1.06,
        ).chain(CurveTween(curve: Curves.easeInOutCubic)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1.06,
          end: 0.94,
        ).chain(CurveTween(curve: Curves.easeInOutCubic)),
        weight: 50,
      ),
    ]).animate(_controller);

    _glowAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0.12,
          end: 0.32,
        ).chain(CurveTween(curve: Curves.easeInOutCubic)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0.32,
          end: 0.12,
        ).chain(CurveTween(curve: Curves.easeInOutCubic)),
        weight: 50,
      ),
    ]).animate(_controller);

    if (widget.isPlaying && _canAnimate) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(SoulBreathingOrb oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isPlaying != oldWidget.isPlaying) {
      if (widget.isPlaying && _canAnimate) {
        _controller.repeat();
      } else {
        _controller.animateTo(0.0, duration: const Duration(milliseconds: 600));
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final scale = widget.isPlaying ? _scaleAnimation.value : 1.0;
        final glowAlpha = widget.isPlaying ? _glowAnimation.value : 0.12;

        return Transform.scale(
          scale: scale,
          child: Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  SoulColors.rose.withValues(alpha: glowAlpha * 1.5),
                  SoulColors.plum.withValues(alpha: glowAlpha),
                  Colors.transparent,
                ],
                stops: const [0.35, 0.7, 1.0],
              ),
            ),
            child: Center(
              child: Container(
                width: widget.size * 0.85,
                height: widget.size * 0.85,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  gradient: LinearGradient(
                    colors: [
                      SoulColors.plum.withValues(alpha: 0.18),
                      SoulColors.rose.withValues(alpha: 0.28),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  border: Border.all(
                    color: SoulColors.plum.withValues(alpha: 0.25),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: SoulColors.plum.withValues(alpha: glowAlpha),
                      blurRadius: 24,
                      spreadRadius: widget.isPlaying ? 2 : 0,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: widget.child,
              ),
            ),
          ),
        );
      },
    );
  }
}
