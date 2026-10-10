import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../data/content/comfort_zone_catalog.dart';

/// Animated full-bleed healing illustration canvas for each of the 25 Comfort Zone scenes.
class ComfortSceneCanvas extends StatefulWidget {
  const ComfortSceneCanvas({
    super.key,
    required this.scene,
    this.isPlaying = true,
    this.borderRadius,
    this.showVignette = true,
  });

  final ComfortZoneScene scene;
  final bool isPlaying;
  final BorderRadius? borderRadius;
  final bool showVignette;

  @override
  State<ComfortSceneCanvas> createState() => _ComfortSceneCanvasState();
}

class _ComfortSceneCanvasState extends State<ComfortSceneCanvas>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

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
      duration: const Duration(seconds: 12),
    );
    if (widget.isPlaying && _canAnimate) {
      _controller.repeat();
    } else {
      _controller.value = 0.35;
    }
  }

  @override
  void didUpdateWidget(ComfortSceneCanvas oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isPlaying != oldWidget.isPlaying) {
      if (widget.isPlaying && _canAnimate) {
        _controller.repeat();
      } else {
        _controller.stop();
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
    final disableAnimations =
        MediaQuery.maybeDisableAnimationsOf(context) ?? false;
    if (disableAnimations && _controller.isAnimating) {
      _controller.stop();
    } else if (!disableAnimations &&
        widget.isPlaying &&
        _canAnimate &&
        !_controller.isAnimating) {
      _controller.repeat();
    }

    final canvas = AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return CustomPaint(
          painter: _ComfortScenePainter(
            scene: widget.scene,
            progress: _controller.value,
            showVignette: widget.showVignette,
          ),
          size: Size.infinite,
        );
      },
    );

    if (widget.borderRadius != null) {
      return ClipRRect(borderRadius: widget.borderRadius!, child: canvas);
    }
    return canvas;
  }
}

class _ComfortScenePainter extends CustomPainter {
  const _ComfortScenePainter({
    required this.scene,
    required this.progress,
    required this.showVignette,
  });

  final ComfortZoneScene scene;
  final double progress;
  final bool showVignette;

  double get _tau => progress * math.pi * 2;

  /// On tall portrait screens, positions focal subjects in the upper-middle
  /// visual zone while floors, hills, lakes, and meadows extend all the way to
  /// `size.height` (100% full screen).
  double _focalHeight(Size size) =>
      size.height > size.width * 1.15 ? size.height * 0.82 : size.height;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    canvas.save();
    canvas.clipRect(rect);

    // 1. Full-screen atmospheric base sky gradient
    _paintSkyGradient(canvas, rect);

    // 2. Scene-specific full-bleed multi-layer illustration
    switch (scene.number) {
      case 1:
        _paintLazyMorning(canvas, size);
      case 2:
        _paintBookRoom(canvas, size);
      case 3:
        _paintSoftestSofa(canvas, size);
      case 4:
        _paintSlowKitchen(canvas, size);
      case 5:
        _paintRainyWindow(canvas, size);
      case 6:
        _paintLittleAttic(canvas, size);
      case 7:
        _paintWinterFireplace(canvas, size);
      case 8:
        _paintMidnightBath(canvas, size);
      case 9:
        _paintFlowerHill(canvas, size);
      case 10:
        _paintCloudWatching(canvas, size);
      case 11:
        _paintLakesideCabin(canvas, size);
      case 12:
        _paintUnderOldTree(canvas, size);
      case 13:
        _paintSeasideHideaway(canvas, size);
      case 14:
        _paintSecretGarden(canvas, size);
      case 15:
        _paintForestHideout(canvas, size);
      case 16:
        _paintGoodCat(canvas, size);
      case 17:
        _paintDogFriend(canvas, size);
      case 18:
        _paintAfternoonNap(canvas, size);
      case 19:
        _paintLittlePicnic(canvas, size);
      case 20:
        _paintHomeTogether(canvas, size);
      case 21:
        _paintStargazingRooftop(canvas, size);
      case 22:
        _paintSunsetBalcony(canvas, size);
      case 23:
        _paintCoffeeAndRain(canvas, size);
      case 24:
        _paintQuietTrain(canvas, size);
      case 25:
        _paintAboveClouds(canvas, size);
      case 26:
        _paintGryffindorChristmas(canvas, size);
      case 27:
        _paintAutumnThanksgiving(canvas, size);
      case 28:
      default:
        _paintTetMorning(canvas, size);
    }

    // 3. Soft atmospheric vignette for depth and UI contrast
    if (showVignette) {
      final vignettePaint =
          Paint()
            ..shader = LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withValues(alpha: 0.14),
                Colors.transparent,
                Colors.black.withValues(alpha: 0.32),
              ],
              stops: const [0.0, 0.52, 1.0],
            ).createShader(rect);
      canvas.drawRect(rect, vignettePaint);
    }

    canvas.restore();
  }

  // ===========================================================================
  // SHARED ARCHITECTURAL, COZY DECOR, NATURE & AESTHETIC CHARACTER HELPERS
  // ===========================================================================

  double _unit(Size size) => math.min(size.width, size.height);

  void _paintSkyGradient(Canvas canvas, Rect rect) {
    final skyPaint =
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              scene.skyTop,
              scene.skyBottom,
              Color.lerp(scene.skyBottom, scene.accentColor, 0.42)!,
            ],
            stops: const [0.0, 0.62, 1.0],
          ).createShader(rect);
    canvas.drawRect(rect, skyPaint);
  }

  /// Paints a complete indoor room with wall gradient, subtle wallpaper wainscot
  /// texture, baseboard trim, and full-bleed floor with perspective wood planks.
  void _drawInteriorRoom(
    Canvas canvas,
    Size size, {
    required Color wallTop,
    required Color wallBottom,
    required Color floorTop,
    required Color floorBottom,
    Color baseboardColor = const Color(0xFFD6C7B8),
    double floorYRatio = 0.64,
    bool woodPlanks = true,
    bool fairyLights = true,
  }) {
    final fh = _focalHeight(size);
    final floorY = fh * floorYRatio;
    final wallRect = Rect.fromLTWH(0, 0, size.width, floorY);
    canvas.drawRect(
      wallRect,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [wallTop, wallBottom],
        ).createShader(wallRect),
    );

    // Subtle vertical wainscoting lines on the lower 28% of the wall for cozy depth
    final wainscotTop = floorY * 0.72;
    canvas.drawLine(
      Offset(0, wainscotTop),
      Offset(size.width, wainscotTop),
      Paint()
        ..color = baseboardColor.withValues(alpha: 0.35)
        ..strokeWidth = 2,
    );
    final panelPaint =
        Paint()
          ..color = Colors.black.withValues(alpha: 0.045)
          ..strokeWidth = 1;
    for (var x = 18.0; x < size.width; x += 28) {
      canvas.drawLine(Offset(x, wainscotTop), Offset(x, floorY), panelPaint);
    }

    final floorRect = Rect.fromLTWH(
      0,
      floorY,
      size.width,
      size.height - floorY,
    );
    canvas.drawRect(
      floorRect,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [floorTop, floorBottom],
        ).createShader(floorRect),
    );

    if (woodPlanks) {
      final plankPaint =
          Paint()
            ..color = Colors.black.withValues(alpha: 0.13)
            ..strokeWidth = 1.2;
      for (var i = 1; i <= 8; i++) {
        final t = i / 8.5;
        final py = floorY + (size.height - floorY) * (t * t);
        canvas.drawLine(Offset(0, py), Offset(size.width, py), plankPaint);
      }
      final vanish = Offset(size.width * 0.5, floorY - fh * 0.25);
      for (var i = -7; i <= 7; i++) {
        final bottomX = size.width * (0.5 + i * 0.14);
        final dir = bottomX - vanish.dx;
        final startX =
            vanish.dx +
            dir * ((floorY - vanish.dy) / (size.height - vanish.dy));
        canvas.drawLine(
          Offset(startX, floorY),
          Offset(bottomX, size.height),
          plankPaint,
        );
      }
    }

    // Baseboard molding
    final baseH = math.max(7.0, fh * 0.016);
    canvas.drawRect(
      Rect.fromLTWH(0, floorY - baseH, size.width, baseH),
      Paint()..color = baseboardColor,
    );
    canvas.drawLine(
      Offset(0, floorY - baseH),
      Offset(size.width, floorY - baseH),
      Paint()
        ..color = Colors.white.withValues(alpha: 0.28)
        ..strokeWidth = 1.2,
    );

    if (fairyLights) {
      _drawFairyStringLights(canvas, size, y: fh * 0.08);
    }
  }

  /// Warm twinkling fairy string lights draped across the top of a cozy room.
  void _drawFairyStringLights(
    Canvas canvas,
    Size size, {
    required double y,
    int bulbs = 15,
  }) {
    final wirePath = Path()..moveTo(0, y);
    for (var i = 0; i <= bulbs; i++) {
      final t = i / bulbs;
      final x = size.width * t;
      final sag = math.sin(t * math.pi * 3) * 14 + math.sin(_tau + t * 4) * 1.5;
      wirePath.lineTo(x, y + sag);
    }
    canvas.drawPath(
      wirePath,
      Paint()
        ..color = Colors.black.withValues(alpha: 0.28)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2,
    );

    for (var i = 1; i < bulbs; i++) {
      final t = i / bulbs;
      final x = size.width * t;
      final sag = math.sin(t * math.pi * 3) * 14 + math.sin(_tau + t * 4) * 1.5;
      final pos = Offset(x, y + sag + 3);
      final pulse = 0.55 + 0.45 * math.sin(_tau * 2 + i * 0.9);
      canvas.drawCircle(
        pos,
        9 * pulse,
        Paint()
          ..color = const Color(0xFFFFD166).withValues(alpha: 0.26 * pulse),
      );
      canvas.drawCircle(
        pos,
        2.8,
        Paint()
          ..color = const Color(
            0xFFFFF8D6,
          ).withValues(alpha: 0.75 + 0.25 * pulse),
      );
    }
  }

  /// Draws a floating wooden wall shelf with mini books, a flickering candle,
  /// and swaying trailing pothos/ivy vines.
  void _drawWallShelfWithTrailingVines(
    Canvas canvas,
    Offset center,
    double width, {
    bool vinesOnRight = true,
    Color shelfColor = const Color(0xFF8B5E3C),
  }) {
    // Shelf shadow & plank
    final shelfRect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: center, width: width, height: 6),
      const Radius.circular(3),
    );
    canvas.drawRRect(
      shelfRect.shift(const Offset(0, 3)),
      Paint()..color = Colors.black.withValues(alpha: 0.18),
    );
    canvas.drawRRect(shelfRect, Paint()..color = shelfColor);

    // Mini books on one side
    final bookDir = vinesOnRight ? -1.0 : 1.0;
    final bookBaseX = center.dx + bookDir * (width * 0.24);
    const colors = [Color(0xFFE07A5F), Color(0xFF81B29A), Color(0xFFF2CC8F)];
    for (var b = 0; b < 3; b++) {
      final bh = 16.0 - b * 2.0;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(
            bookBaseX + b * 6.5 * (-bookDir) - 3,
            center.dy - 3 - bh,
            5.5,
            bh,
          ),
          const Radius.circular(1.2),
        ),
        Paint()..color = colors[b % colors.length],
      );
    }

    // Small glowing scented candle in the middle
    final candleCenter = Offset(center.dx, center.dy - 9);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: candleCenter, width: 9, height: 11),
        const Radius.circular(2),
      ),
      Paint()..color = const Color(0xFFFFF1E6),
    );
    final flicker = 1.0 + 0.2 * math.sin(_tau * 3 + center.dx);
    canvas.drawCircle(
      candleCenter + const Offset(0, -8),
      10 * flicker,
      Paint()..color = const Color(0xFFFFB703).withValues(alpha: 0.28),
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: candleCenter + const Offset(0, -8),
        width: 3.5,
        height: 6 * flicker,
      ),
      Paint()..color = const Color(0xFFFFD166),
    );

    // Small pot & trailing pothos vines
    final potCenter = Offset(
      center.dx + (vinesOnRight ? 1 : -1) * (width * 0.28),
      center.dy - 10,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: potCenter, width: 15, height: 14),
        const Radius.circular(3),
      ),
      Paint()..color = const Color(0xFFC87D55),
    );

    final sway = math.sin(_tau * 1.5) * 4.0;
    final vinePaint =
        Paint()
          ..color = const Color(0xFF386641)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.4;
    final leafPaint = Paint()..color = const Color(0xFF6A994E);

    for (var v = 0; v < 3; v++) {
      final vx = potCenter.dx + (v - 1) * 4.5;
      final vLen = 28.0 + (v == 1 ? 14.0 : 4.0);
      final path =
          Path()
            ..moveTo(vx, potCenter.dy + 4)
            ..quadraticBezierTo(
              vx + sway * (0.6 + v * 0.2),
              potCenter.dy + vLen * 0.55,
              vx - sway * 0.4,
              potCenter.dy + vLen,
            );
      canvas.drawPath(path, vinePaint);
      for (var l = 1; l <= 4; l++) {
        final lt = l / 4.2;
        final lx =
            vx + math.sin(lt * math.pi) * sway * 0.5 + (l.isEven ? 3 : -3);
        final ly = potCenter.dy + 4 + vLen * lt;
        canvas.drawOval(
          Rect.fromCenter(center: Offset(lx, ly), width: 6.5, height: 4.5),
          leafPaint,
        );
      }
    }
  }

  /// Draws 2 framed botanical/landscape art prints on a room wall.
  void _drawFramedWallArt(
    Canvas canvas,
    Offset center, {
    double scale = 1.0,
    bool verticalPair = false,
  }) {
    final offsets =
        verticalPair
            ? [Offset(0, -22 * scale), Offset(0, 22 * scale)]
            : [Offset(-20 * scale, -6 * scale), Offset(20 * scale, 6 * scale)];
    for (var i = 0; i < offsets.length; i++) {
      final fc = center + offsets[i];
      final frameRect = RRect.fromRectAndRadius(
        Rect.fromCenter(center: fc, width: 30 * scale, height: 38 * scale),
        Radius.circular(3 * scale),
      );
      canvas.drawRRect(
        frameRect.shift(const Offset(0, 2)),
        Paint()..color = Colors.black.withValues(alpha: 0.16),
      );
      canvas.drawRRect(frameRect, Paint()..color = const Color(0xFF6B4F3B));
      final matRect = frameRect.deflate(3 * scale);
      canvas.drawRRect(matRect, Paint()..color = const Color(0xFFFFF8F0));

      // Mini art inside
      if (i == 0) {
        canvas.drawCircle(
          fc + Offset(0, -4 * scale),
          6 * scale,
          Paint()..color = const Color(0xFFE07A5F).withValues(alpha: 0.75),
        );
        final hill =
            Path()
              ..moveTo(matRect.left + 3, matRect.bottom - 3)
              ..quadraticBezierTo(
                fc.dx,
                fc.dy,
                matRect.right - 3,
                matRect.bottom - 3,
              )
              ..close();
        canvas.drawPath(hill, Paint()..color = const Color(0xFF52796F));
      } else {
        canvas.drawLine(
          fc + Offset(0, 10 * scale),
          fc + Offset(0, -10 * scale),
          Paint()
            ..color = const Color(0xFF386641)
            ..strokeWidth = 1.5 * scale,
        );
        for (final dy in [-6.0, -1.0, 4.0]) {
          canvas.drawOval(
            Rect.fromCenter(
              center: fc + Offset(-4 * scale, dy * scale),
              width: 7 * scale,
              height: 4 * scale,
            ),
            Paint()..color = const Color(0xFF6A994E),
          );
          canvas.drawOval(
            Rect.fromCenter(
              center: fc + Offset(4 * scale, (dy - 2) * scale),
              width: 7 * scale,
              height: 4 * scale,
            ),
            Paint()..color = const Color(0xFF6A994E),
          );
        }
      }
    }
  }

  /// Draws a cozy woven rug on the floor with geometric pattern and fringe tassels.
  void _drawCozyWovenRug(
    Canvas canvas,
    Offset center,
    double width,
    double height, {
    Color baseColor = const Color(0xFFEDE0D4),
    Color patternColor = const Color(0xFFC89F7B),
  }) {
    final rugRect = Rect.fromCenter(
      center: center,
      width: width,
      height: height,
    );
    // Drop shadow
    canvas.drawOval(
      rugRect.shift(const Offset(0, 3)),
      Paint()..color = Colors.black.withValues(alpha: 0.18),
    );
    // Main woven body
    canvas.drawOval(rugRect, Paint()..color = baseColor);
    // Inner woven border
    canvas.drawOval(
      rugRect.deflate(6),
      Paint()
        ..color = patternColor.withValues(alpha: 0.65)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.2,
    );
    // Center diamond motif
    final dm =
        Path()
          ..moveTo(center.dx - width * 0.16, center.dy)
          ..lineTo(center.dx, center.dy - height * 0.22)
          ..lineTo(center.dx + width * 0.16, center.dy)
          ..lineTo(center.dx, center.dy + height * 0.22)
          ..close();
    canvas.drawPath(
      dm,
      Paint()
        ..color = patternColor.withValues(alpha: 0.45)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.8,
    );
    // Tassels on left & right ends
    final tasselPaint =
        Paint()
          ..color = const Color(0xFFF8F4EE).withValues(alpha: 0.8)
          ..strokeWidth = 1.6
          ..strokeCap = StrokeCap.round;
    for (var i = -2; i <= 2; i++) {
      final dy = i * (height * 0.11);
      canvas.drawLine(
        Offset(rugRect.left + 3, center.dy + dy),
        Offset(rugRect.left - 7, center.dy + dy + 2),
        tasselPaint,
      );
      canvas.drawLine(
        Offset(rugRect.right - 3, center.dy + dy),
        Offset(rugRect.right + 7, center.dy + dy + 2),
        tasselPaint,
      );
    }
  }

  /// Draws diagonal sunbeams or moonbeams streaming from a window into a room.
  void _drawWindowLightBeams(
    Canvas canvas,
    Rect winRect,
    Size size, {
    Color color = const Color(0xFFFFF3B0),
    double alpha = 0.22,
  }) {
    for (var i = 0; i < 2; i++) {
      final leftOffset = winRect.width * (0.08 + i * 0.42);
      final rightOffset = leftOffset + winRect.width * 0.36;
      final beam =
          Path()
            ..moveTo(winRect.left + leftOffset, winRect.top + 10)
            ..lineTo(winRect.left + rightOffset, winRect.top + 10)
            ..lineTo(winRect.left + rightOffset + 65, size.height)
            ..lineTo(winRect.left + leftOffset + 25, size.height)
            ..close();
      canvas.drawPath(
        beam,
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              color.withValues(alpha: alpha),
              color.withValues(alpha: alpha * 0.35),
              Colors.transparent,
            ],
          ).createShader(Offset.zero & size),
      );
    }
  }

  // ===========================================================================
  // AESTHETIC LO-FI / GHIBLI CHARACTER ILLUSTRATORS (NON-CREEPY!)
  // ===========================================================================

  /// Draws a cozy person stretching in bed from a warm 3/4 back-side view
  /// with voluminous wavy hair, hair bun, and soft knit cardigan sleeves.
  void _drawPersonStretchingInBed(Canvas canvas, Offset center, double scale) {
    final stretch = math.sin(_tau) * 3.5 * scale;
    const hairColor = Color(0xFF3B2314);
    const hairHighlight = Color(0xFF6F4E37);
    const sweaterColor = Color(0xFFF3D5B5);
    const skinColor = Color(0xFFF7D6C4);

    // Raised cozy arms in knit sleeves
    final sleevePaint =
        Paint()
          ..color = sweaterColor
          ..strokeWidth = 9.5 * scale
          ..strokeCap = StrokeCap.round;
    final leftHand = center + Offset(-24 * scale, -22 * scale + stretch);
    final rightHand = center + Offset(24 * scale, -22 * scale - stretch);
    canvas.drawLine(
      center + Offset(-12 * scale, 4 * scale),
      leftHand,
      sleevePaint,
    );
    canvas.drawLine(
      center + Offset(12 * scale, 4 * scale),
      rightHand,
      sleevePaint,
    );
    canvas.drawCircle(leftHand, 4.2 * scale, Paint()..color = skinColor);
    canvas.drawCircle(rightHand, 4.2 * scale, Paint()..color = skinColor);

    // Soft rounded sweater torso & shoulders
    final torsoPath =
        Path()
          ..moveTo(center.dx - 19 * scale, center.dy + 24 * scale)
          ..quadraticBezierTo(
            center.dx - 18 * scale,
            center.dy - 4 * scale,
            center.dx - 9 * scale,
            center.dy - 6 * scale,
          )
          ..lineTo(center.dx + 9 * scale, center.dy - 6 * scale)
          ..quadraticBezierTo(
            center.dx + 18 * scale,
            center.dy - 4 * scale,
            center.dx + 19 * scale,
            center.dy + 24 * scale,
          )
          ..close();
    canvas.drawPath(torsoPath, Paint()..color = sweaterColor);

    // Neck & soft head tilt
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: center + Offset(0, -9 * scale),
          width: 8 * scale,
          height: 8 * scale,
        ),
        Radius.circular(4 * scale),
      ),
      Paint()..color = skinColor,
    );
    final headCenter = center + Offset(1 * scale, -18 * scale);
    canvas.drawCircle(headCenter, 11.5 * scale, Paint()..color = skinColor);

    // Voluminous wavy back hair + top morning bun
    final hairPath =
        Path()
          ..moveTo(headCenter.dx - 12 * scale, headCenter.dy - 2 * scale)
          ..quadraticBezierTo(
            headCenter.dx - 13 * scale,
            headCenter.dy - 14 * scale,
            headCenter.dx,
            headCenter.dy - 14 * scale,
          )
          ..quadraticBezierTo(
            headCenter.dx + 13 * scale,
            headCenter.dy - 14 * scale,
            headCenter.dx + 12 * scale,
            headCenter.dy - 1 * scale,
          )
          ..quadraticBezierTo(
            headCenter.dx + 15 * scale,
            headCenter.dy + 13 * scale,
            headCenter.dx + 8 * scale,
            headCenter.dy + 18 * scale,
          )
          ..quadraticBezierTo(
            headCenter.dx,
            headCenter.dy + 21 * scale,
            headCenter.dx - 9 * scale,
            headCenter.dy + 17 * scale,
          )
          ..quadraticBezierTo(
            headCenter.dx - 15 * scale,
            headCenter.dy + 11 * scale,
            headCenter.dx - 12 * scale,
            headCenter.dy - 2 * scale,
          )
          ..close();
    canvas.drawPath(hairPath, Paint()..color = hairColor);
    // Morning bun on crown
    canvas.drawCircle(
      headCenter + Offset(-2 * scale, -15 * scale),
      6.5 * scale,
      Paint()..color = hairColor,
    );
    // Scrunchie / ribbon around bun
    canvas.drawOval(
      Rect.fromCenter(
        center: headCenter + Offset(-2 * scale, -11.5 * scale),
        width: 11 * scale,
        height: 3.5 * scale,
      ),
      Paint()..color = const Color(0xFFE07A5F),
    );
    // Warm sunlit hair highlight arc
    canvas.drawArc(
      Rect.fromCircle(center: headCenter, radius: 9.5 * scale),
      -math.pi * 0.8,
      math.pi * 0.6,
      false,
      Paint()
        ..color = hairHighlight
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2 * scale
        ..strokeCap = StrokeCap.round,
    );
  }

  /// Draws an aesthetic Lo-Fi character curled up reading a book with rich
  /// hair, peaceful eyelashes, blush, oversized sweater, and tucked blanket.
  void _drawPersonCurledReading(
    Canvas canvas,
    Offset center,
    double scale, {
    Color sweaterColor = const Color(0xFFF2CC8F),
    Color blanketColor = const Color(0xFFE07A5F),
  }) {
    final breathe = math.sin(_tau * 2) * 1.2 * scale;
    const skinColor = Color(0xFFFADECD);
    const hairColor = Color(0xFF2B1B17);

    // Legs tucked under cozy knit blanket on the right
    final blanketPath =
        Path()
          ..moveTo(center.dx - 4 * scale, center.dy + 2 * scale)
          ..quadraticBezierTo(
            center.dx + 22 * scale,
            center.dy - 8 * scale + breathe,
            center.dx + 44 * scale,
            center.dy + 8 * scale,
          )
          ..quadraticBezierTo(
            center.dx + 46 * scale,
            center.dy + 22 * scale,
            center.dx + 18 * scale,
            center.dy + 22 * scale,
          )
          ..lineTo(center.dx - 8 * scale, center.dy + 20 * scale)
          ..close();
    canvas.drawPath(blanketPath, Paint()..color = blanketColor);

    // Oversized sweater torso
    final sweaterPath =
        Path()
          ..moveTo(center.dx - 16 * scale, center.dy + 18 * scale)
          ..quadraticBezierTo(
            center.dx - 18 * scale,
            center.dy - 8 * scale + breathe,
            center.dx - 4 * scale,
            center.dy - 10 * scale + breathe,
          )
          ..quadraticBezierTo(
            center.dx + 12 * scale,
            center.dy - 8 * scale + breathe,
            center.dx + 14 * scale,
            center.dy + 16 * scale,
          )
          ..close();
    canvas.drawPath(sweaterPath, Paint()..color = sweaterColor);

    // Head tilted gently toward book
    final headCenter = center + Offset(-3 * scale, -21 * scale + breathe);
    // Back hair volume & low bun
    canvas.drawCircle(
      headCenter + Offset(-11 * scale, -2 * scale),
      6.5 * scale,
      Paint()..color = hairColor,
    );
    canvas.drawCircle(
      headCenter + Offset(-2 * scale, -1 * scale),
      12.5 * scale,
      Paint()..color = hairColor,
    );
    // Face profile
    canvas.drawCircle(
      headCenter + Offset(2 * scale, 1 * scale),
      10.5 * scale,
      Paint()..color = skinColor,
    );
    // Soft rosy cheek
    canvas.drawCircle(
      headCenter + Offset(5 * scale, 4 * scale),
      3.0 * scale,
      Paint()..color = const Color(0xFFFF8FA3).withValues(alpha: 0.55),
    );
    // Peaceful closed eye curve
    canvas.drawArc(
      Rect.fromCenter(
        center: headCenter + Offset(6 * scale, 0.5 * scale),
        width: 5 * scale,
        height: 3 * scale,
      ),
      0.1,
      math.pi * 0.85,
      false,
      Paint()
        ..color = hairColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.4 * scale
        ..strokeCap = StrokeCap.round,
    );
    // Sweeping front bangs & side locks framing face
    final bangsPath =
        Path()
          ..moveTo(headCenter.dx - 10 * scale, headCenter.dy - 6 * scale)
          ..quadraticBezierTo(
            headCenter.dx + 2 * scale,
            headCenter.dy - 14 * scale,
            headCenter.dx + 12 * scale,
            headCenter.dy - 3 * scale,
          )
          ..quadraticBezierTo(
            headCenter.dx + 4 * scale,
            headCenter.dy - 6 * scale,
            headCenter.dx - 1 * scale,
            headCenter.dy + 9 * scale,
          )
          ..quadraticBezierTo(
            headCenter.dx - 10 * scale,
            headCenter.dy + 8 * scale,
            headCenter.dx - 10 * scale,
            headCenter.dy - 6 * scale,
          )
          ..close();
    canvas.drawPath(bangsPath, Paint()..color = hairColor);

    // Open book with glowing pages held in front
    final bookCenter = center + Offset(16 * scale, -4 * scale + breathe);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: bookCenter + Offset(0, 1.5 * scale),
          width: 22 * scale,
          height: 14 * scale,
        ),
        Radius.circular(2.5 * scale),
      ),
      Paint()..color = const Color(0xFF6B4423),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: bookCenter,
          width: 20 * scale,
          height: 12 * scale,
        ),
        Radius.circular(2 * scale),
      ),
      Paint()..color = const Color(0xFFFFF8F0),
    );
    // Sweater arm reaching to hold book
    canvas.drawLine(
      center + Offset(-2 * scale, -2 * scale + breathe),
      bookCenter + Offset(-4 * scale, 3 * scale),
      Paint()
        ..color = Color.lerp(sweaterColor, Colors.black, 0.08)!
        ..strokeWidth = 6.5 * scale
        ..strokeCap = StrokeCap.round,
    );
    canvas.drawCircle(
      bookCenter + Offset(-3 * scale, 3 * scale),
      3.2 * scale,
      Paint()..color = skinColor,
    );
  }

  /// Draws an aesthetic Lo-Fi character sitting by a window (3/4 back/side view)
  /// with flowing wavy hair, cozy sweater, scarf/headphones, and warm rim light.
  void _drawPersonByWindow(
    Canvas canvas,
    Offset center,
    double scale, {
    Color sweaterColor = const Color(0xFFB5838D),
    bool facingLeft = true,
    bool headphones = false,
  }) {
    final dir = facingLeft ? -1.0 : 1.0;
    final breathe = math.sin(_tau * 2) * 1.2 * scale;
    const skinColor = Color(0xFFFADECD);
    const hairColor = Color(0xFF281815);

    // Soft rounded sweater shoulders & torso
    final bodyPath =
        Path()
          ..moveTo(center.dx - 20 * scale, center.dy + 26 * scale)
          ..quadraticBezierTo(
            center.dx - 19 * scale,
            center.dy - 6 * scale + breathe,
            center.dx - 8 * scale,
            center.dy - 10 * scale + breathe,
          )
          ..lineTo(center.dx + 8 * scale, center.dy - 10 * scale + breathe)
          ..quadraticBezierTo(
            center.dx + 19 * scale,
            center.dy - 6 * scale + breathe,
            center.dx + 20 * scale,
            center.dy + 26 * scale,
          )
          ..close();
    canvas.drawPath(bodyPath, Paint()..color = sweaterColor);

    // Cozy knitted collar / scarf
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: center + Offset(0, -10 * scale + breathe),
          width: 22 * scale,
          height: 7 * scale,
        ),
        Radius.circular(3.5 * scale),
      ),
      Paint()..color = const Color(0xFFFFF1E6),
    );

    // Head & face profile
    final headCenter = center + Offset(dir * 2 * scale, -24 * scale + breathe);
    canvas.drawCircle(
      headCenter + Offset(dir * 3 * scale, 1 * scale),
      11 * scale,
      Paint()..color = skinColor,
    );
    // Cheek blush & peaceful closed eye
    canvas.drawCircle(
      headCenter + Offset(dir * 7 * scale, 3.5 * scale),
      2.8 * scale,
      Paint()..color = const Color(0xFFFF8FA3).withValues(alpha: 0.55),
    );
    canvas.drawArc(
      Rect.fromCenter(
        center: headCenter + Offset(dir * 7.5 * scale, 0),
        width: 4.5 * scale,
        height: 2.8 * scale,
      ),
      0.1,
      math.pi * 0.8,
      false,
      Paint()
        ..color = hairColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.3 * scale,
    );

    // Voluminous flowing wavy hair over back and shoulder
    final hairPath =
        Path()
          ..moveTo(headCenter.dx + dir * 10 * scale, headCenter.dy - 5 * scale)
          ..quadraticBezierTo(
            headCenter.dx,
            headCenter.dy - 16 * scale,
            headCenter.dx - dir * 13 * scale,
            headCenter.dy - 4 * scale,
          )
          ..quadraticBezierTo(
            headCenter.dx - dir * 17 * scale,
            headCenter.dy + 12 * scale,
            headCenter.dx - dir * 10 * scale,
            headCenter.dy + 24 * scale,
          )
          ..quadraticBezierTo(
            headCenter.dx - dir * 2 * scale,
            headCenter.dy + 22 * scale,
            headCenter.dx - dir * 1 * scale,
            headCenter.dy + 6 * scale,
          )
          ..close();
    canvas.drawPath(hairPath, Paint()..color = hairColor);

    if (headphones) {
      canvas.drawArc(
        Rect.fromCircle(center: headCenter, radius: 12.5 * scale),
        -math.pi * 0.85,
        math.pi * 0.7,
        false,
        Paint()
          ..color = const Color(0xFFF4EDE4)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3 * scale,
      );
      canvas.drawOval(
        Rect.fromCenter(
          center: headCenter + Offset(0, 2 * scale),
          width: 7 * scale,
          height: 9 * scale,
        ),
        Paint()..color = const Color(0xFFE07A5F),
      );
    }
  }

  /// Draws a framed window (rectangular or arched) with clipped outdoor view,
  /// mullions, glass reflection, outer frame, and protruding sill.
  void _drawWindowWithOutdoorView(
    Canvas canvas,
    Rect winRect, {
    required VoidCallback paintOutdoor,
    Color frameColor = const Color(0xFF6B4F3B),
    Color sillColor = const Color(0xFF523A28),
    int cols = 2,
    int rows = 2,
    bool arched = false,
    bool drawSill = true,
  }) {
    final radius =
        arched
            ? BorderRadius.only(
              topLeft: Radius.circular(winRect.width * 0.5),
              topRight: Radius.circular(winRect.width * 0.5),
              bottomLeft: const Radius.circular(6),
              bottomRight: const Radius.circular(6),
            )
            : BorderRadius.circular(10);
    final rrect = radius.toRRect(winRect);

    // Window drop shadow on wall
    canvas.drawRRect(
      rrect.shift(const Offset(0, 4)),
      Paint()..color = Colors.black.withValues(alpha: 0.18),
    );

    // Clipped outdoor scene
    canvas.save();
    canvas.clipRRect(rrect);
    _paintSkyGradient(canvas, winRect);
    paintOutdoor();

    // Subtle diagonal glass reflection
    final glarePath =
        Path()
          ..moveTo(winRect.left + winRect.width * 0.08, winRect.top)
          ..lineTo(winRect.left + winRect.width * 0.24, winRect.top)
          ..lineTo(winRect.left + winRect.width * 0.04, winRect.bottom)
          ..lineTo(winRect.left - winRect.width * 0.10, winRect.bottom)
          ..close();
    canvas.drawPath(
      glarePath,
      Paint()..color = Colors.white.withValues(alpha: 0.08),
    );
    canvas.restore();

    // Inner mullions
    final mullionPaint =
        Paint()
          ..color = frameColor
          ..strokeWidth = 3.5;
    canvas.save();
    canvas.clipRRect(rrect);
    for (var c = 1; c < cols; c++) {
      final x = winRect.left + winRect.width * (c / cols);
      canvas.drawLine(
        Offset(x, winRect.top),
        Offset(x, winRect.bottom),
        mullionPaint,
      );
    }
    for (var r = 1; r < rows; r++) {
      final y =
          arched
              ? winRect.top + winRect.height * (0.32 + r * 0.34)
              : winRect.top + winRect.height * (r / rows);
      if (y < winRect.bottom - 8) {
        canvas.drawLine(
          Offset(winRect.left, y),
          Offset(winRect.right, y),
          mullionPaint,
        );
      }
    }
    canvas.restore();

    // Outer frame
    canvas.drawRRect(
      rrect,
      Paint()
        ..color = frameColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 7,
    );
    canvas.drawRRect(
      rrect.deflate(3),
      Paint()
        ..color = Colors.white.withValues(alpha: 0.16)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2,
    );

    // Window sill
    if (drawSill) {
      final sillRect = RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(winRect.center.dx, winRect.bottom + 4),
          width: winRect.width + 22,
          height: 10,
        ),
        const Radius.circular(4),
      );
      canvas.drawRRect(sillRect, Paint()..color = sillColor);
    }
  }

  void _drawShearCurtains(
    Canvas canvas,
    Rect winRect, {
    Color curtainColor = const Color(0xD9FFFDF9),
    Color rodColor = const Color(0xFF5C4033),
  }) {
    final sway = math.sin(_tau) * 12;
    canvas.drawLine(
      Offset(winRect.left - 18, winRect.top - 8),
      Offset(winRect.right + 18, winRect.top - 8),
      Paint()
        ..color = rodColor
        ..strokeWidth = 4
        ..strokeCap = StrokeCap.round,
    );
    canvas.drawCircle(
      Offset(winRect.left - 18, winRect.top - 8),
      5,
      Paint()..color = rodColor,
    );
    canvas.drawCircle(
      Offset(winRect.right + 18, winRect.top - 8),
      5,
      Paint()..color = rodColor,
    );

    final w = winRect.width * 0.24;
    final bottomY = winRect.bottom + 24;
    final paint = Paint()..color = curtainColor;

    final leftPath =
        Path()
          ..moveTo(winRect.left - 10, winRect.top - 6)
          ..lineTo(winRect.left + w, winRect.top - 6)
          ..quadraticBezierTo(
            winRect.left + w * 0.55 + sway,
            winRect.center.dy,
            winRect.left + w * 0.75 + sway * 1.3,
            bottomY,
          )
          ..lineTo(winRect.left - 12 + sway * 0.4, bottomY)
          ..close();

    final rightPath =
        Path()
          ..moveTo(winRect.right + 10, winRect.top - 6)
          ..lineTo(winRect.right - w, winRect.top - 6)
          ..quadraticBezierTo(
            winRect.right - w * 0.55 + sway * 0.8,
            winRect.center.dy,
            winRect.right - w * 0.75 + sway,
            bottomY,
          )
          ..lineTo(winRect.right + 12 + sway * 0.4, bottomY)
          ..close();

    canvas.drawPath(leftPath, paint);
    canvas.drawPath(rightPath, paint);

    final foldPaint =
        Paint()
          ..color = const Color(0x33A59484)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.2;
    canvas.drawPath(leftPath, foldPaint);
    canvas.drawPath(rightPath, foldPaint);
  }

  void _drawSunOrMoonGlow(
    Canvas canvas,
    Offset center,
    double radius,
    Color color, {
    bool isCrescent = false,
    Color? crescentCutColor,
  }) {
    final pulse = 1.0 + 0.08 * math.sin(_tau);
    final haloPaint =
        Paint()
          ..shader = RadialGradient(
            colors: [
              color.withValues(alpha: 0.58),
              color.withValues(alpha: 0.20),
              Colors.transparent,
            ],
          ).createShader(
            Rect.fromCircle(center: center, radius: radius * 3.4 * pulse),
          );
    canvas.drawCircle(center, radius * 3.4 * pulse, haloPaint);

    final bodyPaint = Paint()..color = color.withValues(alpha: 0.96);
    canvas.drawCircle(center, radius, bodyPaint);

    if (isCrescent) {
      final cutPaint = Paint()..color = crescentCutColor ?? scene.skyTop;
      canvas.drawCircle(
        center + Offset(radius * 0.38, -radius * 0.16),
        radius * 0.84,
        cutPaint,
      );
    }
  }

  void _drawTwinklingStars(
    Canvas canvas,
    Rect area, {
    int count = 34,
    bool shootingStar = false,
  }) {
    final starPaint = Paint()..color = Colors.white;
    for (var i = 0; i < count; i++) {
      final seed = i * 137.5;
      final fx = ((seed * 0.618) % 1.0);
      final fy = ((seed * 0.382) % 1.0);
      final x = area.left + area.width * fx;
      final y = area.top + area.height * fy;
      final twinkle = 0.3 + 0.7 * (0.5 + 0.5 * math.sin(_tau * 2 + i * 1.3));
      final r = (i % 5 == 0 ? 2.5 : 1.4) * (0.8 + 0.25 * twinkle);
      starPaint.color = Colors.white.withValues(
        alpha: twinkle.clamp(0.18, 0.96),
      );
      canvas.drawCircle(Offset(x, y), r, starPaint);

      if (i % 6 == 0) {
        final arm = r * 2.4 * twinkle;
        final sparklePaint =
            Paint()
              ..color = Colors.white.withValues(alpha: twinkle * 0.65)
              ..strokeWidth = 1.0;
        canvas.drawLine(Offset(x - arm, y), Offset(x + arm, y), sparklePaint);
        canvas.drawLine(Offset(x, y - arm), Offset(x, y + arm), sparklePaint);
      }
    }

    if (shootingStar) {
      final cycle = (progress * 2.0) % 1.0;
      if (cycle < 0.35) {
        final t = cycle / 0.35;
        final sx = area.left + area.width * (0.78 - 0.48 * t);
        final sy = area.top + area.height * (0.10 + 0.26 * t);
        final tailPaint =
            Paint()
              ..shader = LinearGradient(
                colors: [
                  Colors.white.withValues(alpha: (1 - t) * 0.95),
                  Colors.white.withValues(alpha: 0.0),
                ],
              ).createShader(
                Rect.fromPoints(Offset(sx, sy), Offset(sx + 52, sy - 28)),
              )
              ..strokeWidth = 2.2
              ..strokeCap = StrokeCap.round;
        canvas.drawLine(Offset(sx, sy), Offset(sx + 48, sy - 26), tailPaint);
        canvas.drawCircle(
          Offset(sx, sy),
          2.2,
          Paint()..color = Colors.white.withValues(alpha: 1 - t),
        );
      }
    }
  }

  /// Draws full-bleed rolling hills/mountains that always close cleanly at the
  /// bottom of `bounds` (defaulting to the full canvas).
  void _drawRollingHills(
    Canvas canvas,
    Size size, {
    required double baseY,
    required Color color,
    double amplitude = 22,
    double frequency = 1.5,
    double phaseShift = 0.0,
    double? bottomY,
  }) {
    final fillBottom = bottomY ?? size.height;
    final path = Path()..moveTo(0, fillBottom);
    for (var x = 0.0; x <= size.width + 8; x += 8) {
      final clampedX = x.clamp(0.0, size.width);
      final nx = clampedX / size.width;
      final y =
          baseY +
          math.sin(nx * math.pi * frequency + phaseShift) * amplitude +
          math.cos(nx * math.pi * (frequency * 0.55) - phaseShift) *
              (amplitude * 0.42);
      path.lineTo(clampedX, y);
    }
    path
      ..lineTo(size.width, fillBottom)
      ..close();
    canvas.drawPath(path, Paint()..color = color);
  }

  void _drawFluffyCloud(
    Canvas canvas,
    Offset center,
    double scale,
    Color color,
  ) {
    final shadowPaint =
        Paint()
          ..color = Color.lerp(
            color,
            const Color(0xFF9DB4C0),
            0.28,
          )!.withValues(alpha: color.a);
    final paint = Paint()..color = color;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: center + Offset(0, 12 * scale),
          width: 72 * scale,
          height: 20 * scale,
        ),
        Radius.circular(10 * scale),
      ),
      shadowPaint,
    );

    canvas.drawCircle(center, 24 * scale, paint);
    canvas.drawCircle(
      center + Offset(-22 * scale, 5 * scale),
      18 * scale,
      paint,
    );
    canvas.drawCircle(
      center + Offset(22 * scale, 4 * scale),
      19 * scale,
      paint,
    );
    canvas.drawCircle(
      center + Offset(-9 * scale, -10 * scale),
      19 * scale,
      paint,
    );
    canvas.drawCircle(
      center + Offset(11 * scale, -8 * scale),
      17 * scale,
      paint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: center + Offset(0, 9 * scale),
          width: 70 * scale,
          height: 20 * scale,
        ),
        Radius.circular(10 * scale),
      ),
      paint,
    );
  }

  void _drawDriftingClouds(
    Canvas canvas,
    Rect area, {
    int count = 4,
    Color color = const Color(0xEBFFFFFF),
    double scaleMultiplier = 1.0,
  }) {
    for (var i = 0; i < count; i++) {
      final speed = (i.isEven ? 1.0 : 0.6);
      final fx = ((i * 0.29 + progress * speed) % 1.36) - 0.18;
      final fy = 0.18 + (i % 3) * 0.20;
      final scale = (0.78 + (i % 3) * 0.28) * scaleMultiplier;
      _drawFluffyCloud(
        canvas,
        Offset(area.left + area.width * fx, area.top + area.height * fy),
        scale,
        color,
      );
    }
  }

  /// Heavy, multi-layered rain with background sheets, bright foreground streaks,
  /// winding water rivulets on window glass, glistening beads, and sill splashes.
  void _drawRaindrops(
    Canvas canvas,
    Rect area, {
    int count = 96,
    bool glassBeads = true,
  }) {
    // 1. Background dense rain sheet
    final farPaint =
        Paint()
          ..color = const Color(0xFFCAE9FF).withValues(alpha: 0.36)
          ..strokeWidth = 1.1
          ..strokeCap = StrokeCap.round;
    for (var i = 0; i < count; i++) {
      final seed = i * 97.3;
      final fx = (seed * 0.37) % 1.08;
      final fy = ((seed * 0.23 + progress * 4.0) % 1.0);
      final x = area.left + area.width * fx - fy * 22;
      final y = area.top + area.height * fy;
      canvas.drawLine(Offset(x, y), Offset(x - 5.5, y + 24), farPaint);
    }

    // 2. Foreground bright heavy rain streaks
    final nearPaint =
        Paint()
          ..color = Colors.white.withValues(alpha: 0.72)
          ..strokeWidth = 1.8
          ..strokeCap = StrokeCap.round;
    final nearCount = (count * 0.6).round();
    for (var i = 0; i < nearCount; i++) {
      final seed = i * 131.7;
      final fx = (seed * 0.43) % 1.08;
      final fy = ((seed * 0.31 + progress * 5.0) % 1.0);
      final x = area.left + area.width * fx - fy * 28;
      final y = area.top + area.height * fy;
      canvas.drawLine(Offset(x, y), Offset(x - 8.0, y + 36), nearPaint);
    }

    // 3. Splashes at the bottom of the window / ground
    final splashPaint =
        Paint()
          ..color = Colors.white.withValues(alpha: 0.55)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.2;
    for (var i = 0; i < 12; i++) {
      final phase = (progress * 4.0 + i * 0.27) % 1.0;
      if (phase < 0.65) {
        final sx = area.left + area.width * ((i * 0.083 + 0.05) % 0.92);
        final sy = area.bottom - 4 - (i % 3) * 3.0;
        final r = phase * 9.0;
        canvas.drawOval(
          Rect.fromCenter(
            center: Offset(sx, sy),
            width: r * 2.2,
            height: r * 0.7,
          ),
          splashPaint
            ..color = Colors.white.withValues(alpha: (0.65 - phase) * 0.8),
        );
      }
    }

    // 4. Window glass rivulets & glistening raindrops
    if (glassBeads) {
      final rivuletPaint =
          Paint()
            ..color = Colors.white.withValues(alpha: 0.24)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1.3;
      for (var r = 0; r < 7; r++) {
        final rx = area.left + area.width * (0.12 + r * 0.13);
        final path = Path()..moveTo(rx, area.top);
        for (var step = 1; step <= 6; step++) {
          final sy = area.top + area.height * (step / 6);
          final wiggle = math.sin(step * 1.7 + r + _tau) * 4.5;
          path.lineTo(rx + wiggle, sy);
        }
        canvas.drawPath(path, rivuletPaint);
      }

      final beadPaint = Paint()..color = Colors.white.withValues(alpha: 0.76);
      final shadowPaint =
          Paint()..color = const Color(0xFF1D3557).withValues(alpha: 0.35);
      for (var i = 0; i < 38; i++) {
        final seed = i * 61.7;
        final fx = (seed * 0.41) % 0.92 + 0.04;
        final fy =
            ((seed * 0.29 + progress * (0.8 + (i % 3) * 0.4)) % 0.92) + 0.04;
        final pos = Offset(
          area.left + area.width * fx + math.sin(fy * 12 + i) * 2.5,
          area.top + area.height * fy,
        );
        final radius = 1.8 + (i % 3) * 0.9;
        canvas.drawCircle(pos + const Offset(0, 1.2), radius, shadowPaint);
        canvas.drawCircle(pos, radius, beadPaint);
      }
    }
  }

  void _drawSnowflakes(Canvas canvas, Rect area, {int count = 32}) {
    final paint = Paint()..color = Colors.white.withValues(alpha: 0.82);
    for (var i = 0; i < count; i++) {
      final seed = i * 73.1;
      final fy = ((seed * 0.19 + progress * 1.5) % 1.0);
      final fx = ((seed * 0.43) % 1.0) + 0.03 * math.sin(_tau + i);
      final x = area.left + area.width * fx;
      final y = area.top + area.height * fy;
      final r = 1.6 + (i % 3) * 1.0;
      if (area.contains(Offset(x, y))) {
        canvas.drawCircle(Offset(x, y), r, paint);
      }
    }
  }

  void _drawSteamWisps(
    Canvas canvas,
    Offset origin, {
    int wisps = 3,
    double height = 30,
  }) {
    for (var i = 0; i < wisps; i++) {
      final t = (progress * 2.0 + i * (1.0 / wisps)) % 1.0;
      final alpha = math.sin(t * math.pi) * 0.55;
      final paint =
          Paint()
            ..color = Colors.white.withValues(alpha: alpha.clamp(0.0, 0.65))
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2.2
            ..strokeCap = StrokeCap.round;

      final path = Path();
      final startX = origin.dx + (i - 1) * 7.0;
      final startY = origin.dy - t * (height * 0.85);
      path.moveTo(startX, startY);
      path.quadraticBezierTo(
        startX + math.sin(_tau * 2 + i) * 9,
        startY - height * 0.4,
        startX - math.cos(_tau * 2 + i) * 7,
        startY - height * 0.85,
      );
      canvas.drawPath(path, paint);
    }
  }

  void _drawFloatingMotes(
    Canvas canvas,
    Rect area, {
    int count = 20,
    Color color = const Color(0xFFFFF3B0),
  }) {
    final paint = Paint();
    for (var i = 0; i < count; i++) {
      final seed = i * 53.7;
      final fx = ((seed * 0.31) % 1.0) + 0.04 * math.sin(_tau + i);
      final fy = ((seed * 0.47 - progress * 0.8) % 1.0 + 1.0) % 1.0;
      final alpha = 0.28 + 0.58 * (0.5 + 0.5 * math.sin(_tau * 2 + i));
      paint.color = color.withValues(alpha: alpha);
      final r = 1.6 + (i % 3) * 0.9;
      canvas.drawCircle(
        Offset(area.left + area.width * fx, area.top + area.height * fy),
        r,
        paint,
      );
    }
  }

  void _drawSleepingCat(
    Canvas canvas,
    Offset center,
    double scale,
    Color color, {
    Color earInnerColor = const Color(0xFFFFB5A7),
  }) {
    final breathe = 1.0 + 0.045 * math.sin(_tau * 2);
    final paint = Paint()..color = color;

    canvas.drawOval(
      Rect.fromCenter(
        center: center + Offset(0, 9 * scale),
        width: 38 * scale,
        height: 8 * scale,
      ),
      Paint()..color = Colors.black.withValues(alpha: 0.18),
    );

    canvas.drawOval(
      Rect.fromCenter(
        center: center,
        width: 36 * scale * breathe,
        height: 23 * scale * breathe,
      ),
      paint,
    );

    final headCenter = center + Offset(-12 * scale, -3 * scale);
    canvas.drawCircle(headCenter, 10.5 * scale, paint);

    final earPath =
        Path()
          ..moveTo(headCenter.dx - 8 * scale, headCenter.dy - 5 * scale)
          ..lineTo(headCenter.dx - 4 * scale, headCenter.dy - 16 * scale)
          ..lineTo(headCenter.dx + 1 * scale, headCenter.dy - 8 * scale)
          ..moveTo(headCenter.dx + 1 * scale, headCenter.dy - 8 * scale)
          ..lineTo(headCenter.dx + 7 * scale, headCenter.dy - 15 * scale)
          ..lineTo(headCenter.dx + 9 * scale, headCenter.dy - 4 * scale)
          ..close();
    canvas.drawPath(earPath, paint);

    final innerEar =
        Path()
          ..moveTo(headCenter.dx - 6 * scale, headCenter.dy - 6 * scale)
          ..lineTo(headCenter.dx - 3.8 * scale, headCenter.dy - 13 * scale)
          ..lineTo(headCenter.dx - 0.5 * scale, headCenter.dy - 7.5 * scale)
          ..close();
    canvas.drawPath(
      innerEar,
      Paint()..color = earInnerColor.withValues(alpha: 0.65),
    );

    canvas.drawArc(
      Rect.fromCenter(
        center: headCenter + Offset(-3 * scale, 1 * scale),
        width: 5 * scale,
        height: 3 * scale,
      ),
      0,
      math.pi,
      false,
      Paint()
        ..color = Colors.white.withValues(alpha: 0.65)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2 * scale,
    );

    final tailSway = math.sin(_tau) * 3.5 * scale;
    final tailPaint =
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = 4.8 * scale
          ..strokeCap = StrokeCap.round;
    final tailPath =
        Path()
          ..moveTo(center.dx + 14 * scale, center.dy + 4 * scale)
          ..quadraticBezierTo(
            center.dx + 26 * scale,
            center.dy + 2 * scale + tailSway,
            center.dx + 20 * scale,
            center.dy - 8 * scale + tailSway,
          );
    canvas.drawPath(tailPath, tailPaint);
  }

  void _drawDogCompanion(
    Canvas canvas,
    Offset center,
    double scale,
    Color color, {
    bool sitting = true,
    Color collarColor = const Color(0xFFE07A5F),
  }) {
    final paint = Paint()..color = color;
    canvas.drawOval(
      Rect.fromCenter(
        center: center + Offset(0, (sitting ? 20 : 9) * scale),
        width: 36 * scale,
        height: 8 * scale,
      ),
      Paint()..color = Colors.black.withValues(alpha: 0.20),
    );

    if (sitting) {
      canvas.drawOval(
        Rect.fromCenter(
          center: center + Offset(0, 6 * scale),
          width: 24 * scale,
          height: 32 * scale,
        ),
        paint,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: center + Offset(-6 * scale, 18 * scale),
            width: 6 * scale,
            height: 12 * scale,
          ),
          Radius.circular(3 * scale),
        ),
        paint,
      );
      final head = center + Offset(-2 * scale, -13 * scale);
      canvas.drawCircle(head, 10.5 * scale, paint);
      canvas.drawOval(
        Rect.fromCenter(
          center: head + Offset(-8 * scale, 2 * scale),
          width: 12 * scale,
          height: 7.5 * scale,
        ),
        paint,
      );
      canvas.drawCircle(
        head + Offset(-13 * scale, 1 * scale),
        2.0 * scale,
        Paint()..color = const Color(0xFF1A1A1A),
      );
      canvas.drawLine(
        head + Offset(-4 * scale, 9 * scale),
        head + Offset(6 * scale, 10 * scale),
        Paint()
          ..color = collarColor
          ..strokeWidth = 3 * scale
          ..strokeCap = StrokeCap.round,
      );
      canvas.drawOval(
        Rect.fromCenter(
          center: head + Offset(5 * scale, 3 * scale),
          width: 6.5 * scale,
          height: 13 * scale,
        ),
        Paint()..color = Color.lerp(color, Colors.black, 0.22)!,
      );
      final wag = math.sin(_tau * 3) * 4.5 * scale;
      canvas.drawLine(
        center + Offset(9 * scale, 14 * scale),
        center + Offset(21 * scale, 5 * scale + wag),
        Paint()
          ..color = color
          ..strokeWidth = 4.2 * scale
          ..strokeCap = StrokeCap.round,
      );
    } else {
      final breathe = 1.0 + 0.035 * math.sin(_tau * 2);
      canvas.drawOval(
        Rect.fromCenter(
          center: center,
          width: 42 * scale * breathe,
          height: 19 * scale * breathe,
        ),
        paint,
      );
      final head = center + Offset(-17 * scale, -5 * scale);
      canvas.drawCircle(head, 9.5 * scale, paint);
      canvas.drawOval(
        Rect.fromCenter(
          center: head + Offset(-8 * scale, 2 * scale),
          width: 11 * scale,
          height: 6.5 * scale,
        ),
        paint,
      );
      canvas.drawOval(
        Rect.fromCenter(
          center: head + Offset(4 * scale, 2 * scale),
          width: 6 * scale,
          height: 11 * scale,
        ),
        Paint()..color = Color.lerp(color, Colors.black, 0.22)!,
      );
    }
  }

  void _drawTeacup(Canvas canvas, Offset center, double scale, Color color) {
    final paint = Paint()..color = color;
    canvas.drawOval(
      Rect.fromCenter(
        center: center + Offset(0, 10 * scale),
        width: 32 * scale,
        height: 6 * scale,
      ),
      Paint()..color = Colors.black.withValues(alpha: 0.18),
    );
    canvas.drawArc(
      Rect.fromCenter(
        center: center + Offset(10 * scale, 0),
        width: 10 * scale,
        height: 10 * scale,
      ),
      -math.pi * 0.5,
      math.pi,
      false,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.6 * scale,
    );
    canvas.drawRRect(
      RRect.fromRectAndCorners(
        Rect.fromCenter(center: center, width: 22 * scale, height: 16 * scale),
        bottomLeft: Radius.circular(9 * scale),
        bottomRight: Radius.circular(9 * scale),
        topLeft: Radius.circular(2.5 * scale),
        topRight: Radius.circular(2.5 * scale),
      ),
      paint,
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: center + Offset(0, -6.5 * scale),
        width: 18 * scale,
        height: 3.5 * scale,
      ),
      Paint()..color = const Color(0xFF8B5E3C),
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: center + Offset(0, 8.5 * scale),
        width: 30 * scale,
        height: 5.5 * scale,
      ),
      paint,
    );
    _drawSteamWisps(canvas, center + Offset(0, -10 * scale));
  }

  void _drawPineTree(
    Canvas canvas,
    Offset base,
    double height,
    Color color, {
    bool snowCapped = false,
  }) {
    canvas.drawRect(
      Rect.fromCenter(
        center: Offset(base.dx, base.dy - height * 0.12),
        width: math.max(4, height * 0.08),
        height: height * 0.26,
      ),
      Paint()..color = const Color(0xFF3E2723),
    );

    final paint = Paint()..color = color;
    for (var i = 0; i < 3; i++) {
      final tierTop = base.dy - height + i * (height * 0.22);
      final tierBottom = base.dy - height * 0.22 + i * (height * 0.11);
      final halfWidth = height * (0.24 + i * 0.08);
      final path =
          Path()
            ..moveTo(base.dx, tierTop)
            ..lineTo(base.dx - halfWidth, tierBottom)
            ..lineTo(base.dx + halfWidth, tierBottom)
            ..close();
      canvas.drawPath(path, paint);

      if (snowCapped) {
        final snowPath =
            Path()
              ..moveTo(base.dx, tierTop)
              ..lineTo(
                base.dx - halfWidth * 0.48,
                tierTop + (tierBottom - tierTop) * 0.42,
              )
              ..lineTo(
                base.dx + halfWidth * 0.48,
                tierTop + (tierBottom - tierTop) * 0.42,
              )
              ..close();
        canvas.drawPath(
          snowPath,
          Paint()..color = Colors.white.withValues(alpha: 0.82),
        );
      }
    }
  }

  void _drawTinyCabin(
    Canvas canvas,
    Offset center,
    double scale, {
    Color wallColor = const Color(0xFF6B4423),
    Color roofColor = const Color(0xFF3E2723),
    bool smokeFromChimney = true,
  }) {
    final w = 58 * scale;
    final h = 38 * scale;

    final chimneyCenter = center + Offset(w * 0.26, -h * 0.82);
    canvas.drawRect(
      Rect.fromCenter(
        center: chimneyCenter,
        width: 9 * scale,
        height: 18 * scale,
      ),
      Paint()..color = const Color(0xFF4A3531),
    );
    if (smokeFromChimney) {
      _drawSteamWisps(
        canvas,
        chimneyCenter + Offset(0, -10 * scale),
        wisps: 2,
        height: 24 * scale,
      );
    }

    final wallRect = Rect.fromCenter(center: center, width: w, height: h);
    canvas.drawRect(wallRect, Paint()..color = wallColor);

    final logPaint =
        Paint()
          ..color = Colors.black.withValues(alpha: 0.14)
          ..strokeWidth = 1;
    for (var i = 1; i < 4; i++) {
      final y = wallRect.top + wallRect.height * (i / 4);
      canvas.drawLine(
        Offset(wallRect.left, y),
        Offset(wallRect.right, y),
        logPaint,
      );
    }

    final roof =
        Path()
          ..moveTo(center.dx - w * 0.65, center.dy - h * 0.48)
          ..lineTo(center.dx, center.dy - h * 1.18)
          ..lineTo(center.dx + w * 0.65, center.dy - h * 0.48)
          ..close();
    canvas.drawPath(roof, Paint()..color = roofColor);

    final doorRect = Rect.fromLTWH(
      center.dx - w * 0.30,
      center.dy - h * 0.08,
      w * 0.22,
      h * 0.58,
    );
    canvas.drawRRect(
      RRect.fromRectAndCorners(
        doorRect,
        topLeft: Radius.circular(4 * scale),
        topRight: Radius.circular(4 * scale),
      ),
      Paint()..color = roofColor,
    );

    final glowAlpha = 0.82 + 0.18 * math.sin(_tau * 2);
    final windowRect = Rect.fromCenter(
      center: center + Offset(w * 0.14, 0),
      width: 16 * scale,
      height: 15 * scale,
    );
    canvas.drawCircle(
      windowRect.center,
      28 * scale,
      Paint()
        ..shader = RadialGradient(
          colors: [
            const Color(0xFFFFD166).withValues(alpha: 0.48 * glowAlpha),
            Colors.transparent,
          ],
        ).createShader(
          Rect.fromCircle(center: windowRect.center, radius: 28 * scale),
        ),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(windowRect, Radius.circular(2.5 * scale)),
      Paint()..color = const Color(0xFFFFE082).withValues(alpha: glowAlpha),
    );
    final panePaint =
        Paint()
          ..color = roofColor
          ..strokeWidth = 1.4 * scale;
    canvas.drawLine(
      Offset(windowRect.center.dx, windowRect.top),
      Offset(windowRect.center.dx, windowRect.bottom),
      panePaint,
    );
    canvas.drawLine(
      Offset(windowRect.left, windowRect.center.dy),
      Offset(windowRect.right, windowRect.center.dy),
      panePaint,
    );
  }

  void _drawPottedPlant(
    Canvas canvas,
    Offset baseCenter,
    double scale, {
    Color potColor = const Color(0xFFC87D55),
    Color leafColor = const Color(0xFF4F772D),
    Color? flowerColor,
  }) {
    final potPath =
        Path()
          ..moveTo(baseCenter.dx - 11 * scale, baseCenter.dy - 18 * scale)
          ..lineTo(baseCenter.dx + 11 * scale, baseCenter.dy - 18 * scale)
          ..lineTo(baseCenter.dx + 8 * scale, baseCenter.dy)
          ..lineTo(baseCenter.dx - 8 * scale, baseCenter.dy)
          ..close();
    canvas.drawPath(potPath, Paint()..color = potColor);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: baseCenter + Offset(0, -19 * scale),
          width: 25 * scale,
          height: 4.5 * scale,
        ),
        Radius.circular(2 * scale),
      ),
      Paint()..color = Color.lerp(potColor, Colors.black, 0.12)!,
    );

    final sway = math.sin(_tau * 1.5) * 2.5 * scale;
    final leafPaint = Paint()..color = leafColor;
    final offsets = [
      Offset(-9 * scale + sway, -28 * scale),
      Offset(0 + sway, -34 * scale),
      Offset(9 * scale + sway, -27 * scale),
      Offset(-4 * scale + sway, -24 * scale),
      Offset(5 * scale + sway, -23 * scale),
    ];
    for (final off in offsets) {
      canvas.drawOval(
        Rect.fromCenter(
          center: baseCenter + off,
          width: 11 * scale,
          height: 15 * scale,
        ),
        leafPaint,
      );
    }

    if (flowerColor != null) {
      for (var i = -1; i <= 1; i++) {
        final fc =
            baseCenter +
            Offset(i * 7 * scale + sway, (-33 - (i == 0 ? 4 : 0)) * scale);
        canvas.drawCircle(fc, 4.5 * scale, Paint()..color = flowerColor);
        canvas.drawCircle(
          fc,
          1.8 * scale,
          Paint()..color = const Color(0xFFFFD166),
        );
      }
    }
  }

  void _drawWildflowersField(
    Canvas canvas,
    Rect area, {
    int count = 24,
    List<Color> petalColors = const [
      Color(0xFFFFB5A7),
      Color(0xFFFDE68A),
      Color(0xFFFFFFFF),
      Color(0xFFE0AAFF),
    ],
  }) {
    final stemPaint =
        Paint()
          ..color = const Color(0xFF2D6A4F).withValues(alpha: 0.7)
          ..strokeWidth = 1.4
          ..strokeCap = StrokeCap.round;

    for (var i = 0; i < count; i++) {
      final seed = i * 83.3;
      final fx = (seed * 0.39) % 0.92 + 0.04;
      final fy = (seed * 0.53) % 0.85 + 0.08;
      final base = Offset(
        area.left + area.width * fx,
        area.top + area.height * fy + 10,
      );
      final sway = math.sin(_tau * 1.6 + i) * 3.5;
      final head = Offset(base.dx + sway, base.dy - 11 - (i % 3) * 3);

      canvas.drawLine(base, head, stemPaint);
      final petalColor = petalColors[i % petalColors.length];
      final r = 2.8 + (i % 3) * 0.7;
      for (var p = 0; p < 5; p++) {
        final a = p * (math.pi * 2 / 5);
        canvas.drawCircle(
          head + Offset(math.cos(a) * r * 0.75, math.sin(a) * r * 0.75),
          r * 0.58,
          Paint()..color = petalColor,
        );
      }
      canvas.drawCircle(
        head,
        r * 0.45,
        Paint()..color = const Color(0xFFFFB703),
      );
    }
  }

  // ===========================================================================
  // 25 FULL-BLEED BESPOKE SCENE PAINTERS
  // ===========================================================================

  // 01: Lazy Morning — Buổi sáng lười biếng
  void _paintLazyMorning(Canvas canvas, Size size) {
    final fh = _focalHeight(size);
    final u = _unit(size);
    _drawInteriorRoom(
      canvas,
      size,
      wallTop: const Color(0xFFF7F2EA),
      wallBottom: const Color(0xFFEBE2D5),
      floorTop: const Color(0xFFD5BDAF),
      floorBottom: const Color(0xFFB08968),
      floorYRatio: 0.66,
    );

    // Wall decor around window
    _drawWallShelfWithTrailingVines(
      canvas,
      Offset(size.width * 0.14, fh * 0.24),
      size.width * 0.20,
      vinesOnRight: false,
    );
    _drawFramedWallArt(
      canvas,
      Offset(size.width * 0.88, fh * 0.28),
      scale: 0.75,
      verticalPair: true,
    );

    final winRect = Rect.fromCenter(
      center: Offset(size.width * 0.5, fh * 0.34),
      width: size.width * 0.58,
      height: fh * 0.40,
    );

    _drawWindowWithOutdoorView(
      canvas,
      winRect,
      frameColor: const Color(0xFFD5BDAF),
      sillColor: const Color(0xFFC3A995),
      paintOutdoor: () {
        _drawSunOrMoonGlow(
          canvas,
          Offset(winRect.right - winRect.width * 0.24, winRect.top + 42),
          u * 0.065,
          const Color(0xFFFFF3B0),
        );
        _drawDriftingClouds(canvas, winRect, count: 3);
        _drawRollingHills(
          canvas,
          size,
          baseY: winRect.bottom - winRect.height * 0.36,
          bottomY: winRect.bottom,
          color: const Color(0xFF95B8A6),
          amplitude: 16,
        );
        _drawRollingHills(
          canvas,
          size,
          baseY: winRect.bottom - winRect.height * 0.20,
          bottomY: winRect.bottom,
          color: const Color(0xFF52796F),
          amplitude: 12,
          phaseShift: 1.4,
        );
        final mistShift = math.sin(_tau) * 18;
        for (var i = 0; i < 2; i++) {
          canvas.drawOval(
            Rect.fromCenter(
              center: Offset(
                winRect.center.dx + mistShift * (i == 0 ? 1 : -0.8),
                winRect.bottom - 24 - i * 15,
              ),
              width: winRect.width * 0.85,
              height: 16,
            ),
            Paint()..color = Colors.white.withValues(alpha: 0.48),
          );
        }
      },
    );

    _drawShearCurtains(canvas, winRect);
    _drawWindowLightBeams(canvas, winRect, size, alpha: 0.24);

    // Cozy woven rug under the bed
    _drawCozyWovenRug(
      canvas,
      Offset(size.width * 0.5, fh * 0.82),
      size.width * 0.84,
      fh * 0.16,
      baseColor: const Color(0xFFF5EBE0),
      patternColor: const Color(0xFFD5BDAF),
    );

    // Corner potted plant + bedside nightstand with mug & lamp
    _drawPottedPlant(
      canvas,
      Offset(size.width * 0.10, fh * 0.67),
      1.15,
      flowerColor: const Color(0xFFFFB5A7),
    );
    final standRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(size.width * 0.88, fh * 0.66),
        width: 44,
        height: 46,
      ),
      const Radius.circular(6),
    );
    canvas.drawRRect(standRect, Paint()..color = const Color(0xFFB08968));
    _drawTeacup(
      canvas,
      Offset(size.width * 0.88, fh * 0.59),
      0.85,
      const Color(0xFFFFF8F0),
    );

    final bedCenter = Offset(size.width * 0.48, fh * 0.72);
    final bedW = size.width * 0.68;
    final bedH = fh * 0.22;

    canvas.drawRRect(
      RRect.fromRectAndCorners(
        Rect.fromCenter(
          center: Offset(bedCenter.dx, bedCenter.dy - bedH * 0.48),
          width: bedW * 0.92,
          height: bedH * 0.48,
        ),
        topLeft: const Radius.circular(18),
        topRight: const Radius.circular(18),
      ),
      Paint()..color = const Color(0xFFC3A68F),
    );

    for (final dx in [-bedW * 0.22, bedW * 0.22]) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: Offset(bedCenter.dx + dx, bedCenter.dy - bedH * 0.32),
            width: bedW * 0.34,
            height: 22,
          ),
          const Radius.circular(11),
        ),
        Paint()..color = const Color(0xFFF8F9FA),
      );
    }

    // Aesthetic cozy person waking up & stretching in bed
    _drawPersonStretchingInBed(
      canvas,
      Offset(bedCenter.dx - bedW * 0.06, bedCenter.dy - bedH * 0.40),
      1.05,
    );

    final mattressRect = Rect.fromCenter(
      center: bedCenter,
      width: bedW,
      height: bedH * 0.78,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(mattressRect, const Radius.circular(24)),
      Paint()..color = const Color(0xFFFFFFFF),
    );
    canvas.drawRRect(
      RRect.fromRectAndCorners(
        Rect.fromLTWH(
          mattressRect.left,
          mattressRect.top + mattressRect.height * 0.32,
          mattressRect.width,
          mattressRect.height * 0.68,
        ),
        bottomLeft: const Radius.circular(24),
        bottomRight: const Radius.circular(24),
        topLeft: const Radius.circular(14),
        topRight: const Radius.circular(14),
      ),
      Paint()..color = const Color(0xFFF3EFEA),
    );

    _drawFloatingMotes(canvas, Offset.zero & size, count: 28);
  }

  // 02: The Book Room — Căn phòng của những cuốn sách
  void _paintBookRoom(Canvas canvas, Size size) {
    final fh = _focalHeight(size);
    _drawInteriorRoom(
      canvas,
      size,
      wallTop: const Color(0xFF2D232E),
      wallBottom: const Color(0xFF3D2E3C),
      floorTop: const Color(0xFF4A342B),
      floorBottom: const Color(0xFF2E1F18),
      baseboardColor: const Color(0xFF5C4033),
      floorYRatio: 0.66,
    );

    final archRect = Rect.fromCenter(
      center: Offset(size.width * 0.62, fh * 0.34),
      width: size.width * 0.44,
      height: fh * 0.44,
    );
    _drawWindowWithOutdoorView(
      canvas,
      archRect,
      arched: true,
      frameColor: const Color(0xFF5C4033),
      sillColor: const Color(0xFF4A3228),
      paintOutdoor: () {
        _drawTwinklingStars(canvas, archRect, count: 28, shootingStar: true);
        _drawSunOrMoonGlow(
          canvas,
          Offset(
            archRect.center.dx + 16,
            archRect.top + archRect.height * 0.26,
          ),
          16,
          const Color(0xFFFDE68A),
          isCrescent: true,
          crescentCutColor: scene.skyTop,
        );
        _drawRollingHills(
          canvas,
          size,
          baseY: archRect.bottom - 26,
          bottomY: archRect.bottom,
          color: const Color(0xFF1A1B2F),
          amplitude: 10,
        );
      },
    );

    final shelfRect = Rect.fromLTWH(
      size.width * 0.06,
      fh * 0.14,
      size.width * 0.28,
      fh * 0.52,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(shelfRect, const Radius.circular(6)),
      Paint()..color = const Color(0xFF3E2723),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(shelfRect.deflate(5), const Radius.circular(4)),
      Paint()..color = const Color(0xFF291916),
    );
    final bookColors = [
      const Color(0xFFE07A5F),
      const Color(0xFF81B29A),
      const Color(0xFFF2CC8F),
      const Color(0xFFD4A373),
      const Color(0xFFB5838D),
    ];
    for (var row = 0; row < 5; row++) {
      final sy = shelfRect.top + (row + 1) * (shelfRect.height / 5.2);
      canvas.drawRect(
        Rect.fromLTWH(shelfRect.left + 4, sy, shelfRect.width - 8, 4),
        Paint()..color = const Color(0xFF5D4037),
      );
      final bookAreaW = shelfRect.width - 18;
      const bookCount = 6;
      final bw = bookAreaW / bookCount;
      for (var b = 0; b < bookCount; b++) {
        final bh = (shelfRect.height / 6.8) * (0.75 + (b % 3) * 0.12);
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(shelfRect.left + 9 + b * bw, sy - bh, bw - 2.0, bh),
            const Radius.circular(1.5),
          ),
          Paint()..color = bookColors[(row * 2 + b) % bookColors.length],
        );
      }
    }

    final lampX = size.width * 0.88;
    final floorY = fh * 0.66;
    canvas.drawLine(
      Offset(lampX, fh * 0.36),
      Offset(lampX, floorY + 12),
      Paint()
        ..color = const Color(0xFFD4A373)
        ..strokeWidth = 3,
    );
    canvas.drawOval(
      Rect.fromCenter(center: Offset(lampX, floorY + 12), width: 26, height: 7),
      Paint()..color = const Color(0xFFD4A373),
    );
    _drawSunOrMoonGlow(
      canvas,
      Offset(lampX, fh * 0.36),
      20,
      const Color(0xFFFFB703),
    );
    final lampShade =
        Path()
          ..moveTo(lampX - 18, fh * 0.38)
          ..lineTo(lampX + 18, fh * 0.38)
          ..lineTo(lampX + 11, fh * 0.32)
          ..lineTo(lampX - 11, fh * 0.32)
          ..close();
    canvas.drawPath(lampShade, Paint()..color = const Color(0xFFF2CC8F));

    _drawCozyWovenRug(
      canvas,
      Offset(size.width * 0.56, fh * 0.78),
      size.width * 0.70,
      fh * 0.13,
      baseColor: const Color(0xFF7F5539),
      patternColor: const Color(0xFFD4A373),
    );

    final sofaCenter = Offset(size.width * 0.56, fh * 0.68);
    final sofaW = size.width * 0.56;
    final sofaH = fh * 0.17;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: sofaCenter + Offset(0, -sofaH * 0.25),
          width: sofaW * 0.92,
          height: sofaH * 0.75,
        ),
        const Radius.circular(20),
      ),
      Paint()..color = const Color(0xFF8D5B4C),
    );

    // Aesthetic Lo-Fi reader curled up on sofa with book
    _drawPersonCurledReading(
      canvas,
      sofaCenter + Offset(-sofaW * 0.08, -sofaH * 0.16),
      1.05,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: sofaCenter + Offset(0, sofaH * 0.18),
          width: sofaW,
          height: sofaH * 0.58,
        ),
        const Radius.circular(18),
      ),
      Paint()..color = const Color(0xFFA47148),
    );
    _drawSleepingCat(
      canvas,
      Offset(size.width * 0.24, fh * 0.76),
      0.95,
      const Color(0xFFD4A373),
    );
    _drawFloatingMotes(canvas, Offset.zero & size, count: 24);
  }

  // 03: The Softest Sofa — Chiếc sofa êm nhất
  void _paintSoftestSofa(Canvas canvas, Size size) {
    final fh = _focalHeight(size);
    _drawInteriorRoom(
      canvas,
      size,
      wallTop: const Color(0xFF4A5568),
      wallBottom: const Color(0xFF5A6578),
      floorTop: const Color(0xFF7F5539),
      floorBottom: const Color(0xFF583101),
      baseboardColor: const Color(0xFF9C6644),
      floorYRatio: 0.64,
    );

    // Wall shelves & framed art for cozy living room feel
    _drawWallShelfWithTrailingVines(
      canvas,
      Offset(size.width * 0.14, fh * 0.22),
      size.width * 0.22,
      vinesOnRight: false,
    );
    _drawFramedWallArt(
      canvas,
      Offset(size.width * 0.88, fh * 0.24),
      scale: 0.72,
      verticalPair: true,
    );

    final winRect = Rect.fromCenter(
      center: Offset(size.width * 0.5, fh * 0.30),
      width: size.width * 0.60,
      height: fh * 0.38,
    );
    _drawWindowWithOutdoorView(
      canvas,
      winRect,
      cols: 3,
      rows: 2,
      frameColor: const Color(0xFFEDE0D4),
      sillColor: const Color(0xFFDDB892),
      paintOutdoor: () {
        _drawRollingHills(
          canvas,
          size,
          baseY: winRect.bottom - 38,
          bottomY: winRect.bottom,
          color: const Color(0xFF33415C),
          amplitude: 14,
        );
        _drawRaindrops(canvas, winRect, count: 110);
      },
    );
    _drawShearCurtains(canvas, winRect, curtainColor: const Color(0xCCEDE0D4));

    // Warm floor lamp on the right casting golden light
    final lampX = size.width * 0.88;
    _drawSunOrMoonGlow(
      canvas,
      Offset(lampX, fh * 0.42),
      26,
      const Color(0xFFFFB703),
    );
    canvas.drawLine(
      Offset(lampX, fh * 0.42),
      Offset(lampX, fh * 0.65),
      Paint()
        ..color = const Color(0xFFD4A373)
        ..strokeWidth = 3,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(lampX, fh * 0.40),
          width: 28,
          height: 18,
        ),
        const Radius.circular(5),
      ),
      Paint()..color = const Color(0xFFFFF1E6),
    );
    _drawPottedPlant(
      canvas,
      Offset(size.width * 0.10, fh * 0.65),
      1.18,
      flowerColor: const Color(0xFFF2CC8F),
    );

    _drawCozyWovenRug(
      canvas,
      Offset(size.width * 0.5, fh * 0.80),
      size.width * 0.84,
      fh * 0.17,
    );

    final sofaCenter = Offset(size.width * 0.5, fh * 0.63);
    final sofaW = size.width * 0.72;
    final sofaH = fh * 0.20;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: sofaCenter + Offset(0, -sofaH * 0.28),
          width: sofaW * 0.94,
          height: sofaH * 0.72,
        ),
        const Radius.circular(22),
      ),
      Paint()..color = const Color(0xFFC89F7B),
    );
    // Throw pillows on sofa
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: sofaCenter + Offset(-sofaW * 0.32, -sofaH * 0.14),
          width: 28,
          height: 24,
        ),
        const Radius.circular(8),
      ),
      Paint()..color = const Color(0xFFE07A5F),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: sofaCenter + Offset(sofaW * 0.30, -sofaH * 0.14),
          width: 28,
          height: 24,
        ),
        const Radius.circular(8),
      ),
      Paint()..color = const Color(0xFF81B29A),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: sofaCenter + Offset(0, sofaH * 0.16),
          width: sofaW,
          height: sofaH * 0.62,
        ),
        const Radius.circular(22),
      ),
      Paint()..color = const Color(0xFFDDB892),
    );
    final blanketPath =
        Path()
          ..moveTo(sofaCenter.dx + sofaW * 0.08, sofaCenter.dy - sofaH * 0.55)
          ..lineTo(sofaCenter.dx + sofaW * 0.36, sofaCenter.dy - sofaH * 0.50)
          ..quadraticBezierTo(
            sofaCenter.dx + sofaW * 0.40,
            sofaCenter.dy + sofaH * 0.10,
            sofaCenter.dx + sofaW * 0.30,
            sofaCenter.dy + sofaH * 0.52,
          )
          ..lineTo(sofaCenter.dx + sofaW * 0.12, sofaCenter.dy + sofaH * 0.46)
          ..close();
    canvas.drawPath(blanketPath, Paint()..color = const Color(0xFFF4EDE4));

    _drawSleepingCat(
      canvas,
      sofaCenter + Offset(-sofaW * 0.14, -2),
      1.15,
      const Color(0xFF6C462F),
    );

    final tableCenter = Offset(size.width * 0.52, fh * 0.79);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: tableCenter + const Offset(-38, 18),
          width: 6,
          height: 28,
        ),
        const Radius.circular(3),
      ),
      Paint()..color = const Color(0xFF5C4033),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: tableCenter + const Offset(38, 18),
          width: 6,
          height: 28,
        ),
        const Radius.circular(3),
      ),
      Paint()..color = const Color(0xFF5C4033),
    );
    canvas.drawOval(
      Rect.fromCenter(center: tableCenter, width: 124, height: 26),
      Paint()..color = const Color(0xFF8B5E3C),
    );
    _drawTeacup(
      canvas,
      tableCenter + const Offset(14, -8),
      1.05,
      const Color(0xFFFFF8F0),
    );
    // Open book on coffee table
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: tableCenter + const Offset(-22, -4),
          width: 28,
          height: 10,
        ),
        const Radius.circular(2),
      ),
      Paint()..color = const Color(0xFFFFF1E6),
    );
    _drawFloatingMotes(canvas, Offset.zero & size, count: 22);
  }

  // 04: Slow Kitchen — Căn bếp chậm rãi
  void _paintSlowKitchen(Canvas canvas, Size size) {
    final fh = _focalHeight(size);
    canvas.drawRect(
      Offset.zero & size,
      Paint()..color = const Color(0xFFFAF6EE),
    );
    final tilePaint =
        Paint()
          ..color = const Color(0xFFE9E2D4)
          ..strokeWidth = 1;
    for (var y = fh * 0.38; y < fh * 0.62; y += 16) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), tilePaint);
    }
    for (var x = 0.0; x < size.width; x += 28) {
      canvas.drawLine(Offset(x, fh * 0.38), Offset(x, fh * 0.62), tilePaint);
    }

    _drawFairyStringLights(canvas, size, y: fh * 0.07);
    _drawWallShelfWithTrailingVines(
      canvas,
      Offset(size.width * 0.14, fh * 0.24),
      size.width * 0.22,
      vinesOnRight: false,
    );
    _drawWallShelfWithTrailingVines(
      canvas,
      Offset(size.width * 0.86, fh * 0.24),
      size.width * 0.22,
      vinesOnRight: true,
    );

    final winRect = Rect.fromCenter(
      center: Offset(size.width * 0.5, fh * 0.28),
      width: size.width * 0.52,
      height: fh * 0.36,
    );
    _drawWindowWithOutdoorView(
      canvas,
      winRect,
      frameColor: const Color(0xFFA3B18A),
      sillColor: const Color(0xFF849669),
      paintOutdoor: () {
        _drawSunOrMoonGlow(
          canvas,
          Offset(winRect.left + 44, winRect.top + 36),
          20,
          const Color(0xFFFFF3B0),
        );
        _drawRollingHills(
          canvas,
          size,
          baseY: winRect.bottom - 48,
          bottomY: winRect.bottom,
          color: const Color(0xFF74C69D),
          amplitude: 14,
        );
        _drawRollingHills(
          canvas,
          size,
          baseY: winRect.bottom - 24,
          bottomY: winRect.bottom,
          color: const Color(0xFF40916C),
          amplitude: 10,
          phaseShift: 1.8,
        );
        _drawRaindrops(canvas, winRect, count: 40);
      },
    );
    _drawWindowLightBeams(canvas, winRect, size, alpha: 0.22);

    final counterTopY = fh * 0.58;
    canvas.drawRect(
      Rect.fromLTWH(0, counterTopY, size.width, size.height - counterTopY),
      Paint()..color = const Color(0xFF8FA682),
    );
    const doorCount = 3;
    final doorW = (size.width - 36) / doorCount;
    for (var i = 0; i < doorCount; i++) {
      final r = Rect.fromLTWH(
        12 + i * (doorW + 6),
        counterTopY + 26,
        doorW,
        size.height - counterTopY - 38,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(r, const Radius.circular(6)),
        Paint()
          ..color = const Color(0xFF6B8360)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.5,
      );
      canvas.drawCircle(
        Offset(r.left + 14, r.top + 22),
        3.5,
        Paint()..color = const Color(0xFFD4A373),
      );
    }
    canvas.drawRect(
      Rect.fromLTWH(0, counterTopY - 8, size.width, 18),
      Paint()..color = const Color(0xFFD4A373),
    );

    final breadCenter = Offset(size.width * 0.34, counterTopY - 18);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: breadCenter + const Offset(0, 12),
          width: 82,
          height: 8,
        ),
        const Radius.circular(4),
      ),
      Paint()..color = const Color(0xFF9C6644),
    );
    canvas.drawOval(
      Rect.fromCenter(center: breadCenter, width: 64, height: 32),
      Paint()..color = const Color(0xFFBC6C25),
    );
    final scorePaint =
        Paint()
          ..color = const Color(0xFFF2CC8F)
          ..strokeWidth = 2
          ..strokeCap = StrokeCap.round;
    for (var s = -1; s <= 1; s++) {
      canvas.drawLine(
        breadCenter + Offset(s * 12.0 - 4, -6),
        breadCenter + Offset(s * 12.0 + 4, 4),
        scorePaint,
      );
    }
    _drawSteamWisps(canvas, breadCenter + const Offset(0, -16), wisps: 4);

    // Copper kettle & teacup on counter
    _drawTeacup(
      canvas,
      Offset(size.width * 0.14, counterTopY - 16),
      0.95,
      const Color(0xFFFFF8F0),
    );

    final vaseCenter = Offset(size.width * 0.68, counterTopY - 26);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: vaseCenter, width: 32, height: 44),
        const Radius.circular(12),
      ),
      Paint()..color = const Color(0xFFFFF8F0),
    );
    final sway = math.sin(_tau) * 3;
    for (var i = -2; i <= 2; i++) {
      final stemTop =
          vaseCenter + Offset(i * 9.0 + sway, -34 - (2 - i.abs()) * 5.0);
      canvas.drawLine(
        vaseCenter + const Offset(0, -18),
        stemTop,
        Paint()
          ..color = const Color(0xFF4F772D)
          ..strokeWidth = 2,
      );
      canvas.drawCircle(stemTop, 7, Paint()..color = Colors.white);
      canvas.drawCircle(stemTop, 3, Paint()..color = const Color(0xFFFFB703));
    }
    _drawFloatingMotes(canvas, Offset.zero & size, count: 24);
  }

  // 05: Rainy Window — Ngày mưa không cần đi đâu
  void _paintRainyWindow(Canvas canvas, Size size) {
    final fh = _focalHeight(size);
    _drawInteriorRoom(
      canvas,
      size,
      wallTop: const Color(0xFF28363D),
      wallBottom: const Color(0xFF33444C),
      floorTop: const Color(0xFF4A3B32),
      floorBottom: const Color(0xFF2F241E),
      baseboardColor: const Color(0xFF5C4B40),
      floorYRatio: 0.68,
    );

    _drawWallShelfWithTrailingVines(
      canvas,
      Offset(size.width * 0.14, fh * 0.22),
      size.width * 0.20,
      vinesOnRight: false,
    );
    _drawFramedWallArt(
      canvas,
      Offset(size.width * 0.88, fh * 0.25),
      scale: 0.72,
      verticalPair: true,
    );

    final winRect = Rect.fromCenter(
      center: Offset(size.width * 0.5, fh * 0.34),
      width: size.width * 0.64,
      height: fh * 0.46,
    );
    _drawWindowWithOutdoorView(
      canvas,
      winRect,
      cols: 2,
      rows: 2,
      frameColor: const Color(0xFF1F292E),
      sillColor: const Color(0xFF38474F),
      paintOutdoor: () {
        _drawRollingHills(
          canvas,
          size,
          baseY: winRect.bottom - 65,
          bottomY: winRect.bottom,
          color: const Color(0xFF1B4332).withValues(alpha: 0.65),
          amplitude: 16,
        );
        for (var i = 0; i < 8; i++) {
          _drawPineTree(
            canvas,
            Offset(
              winRect.left + winRect.width * (0.08 + i * 0.12),
              winRect.bottom,
            ),
            winRect.height * (0.52 + (i % 3) * 0.12),
            i.isEven ? const Color(0xFF1B4332) : const Color(0xFF2D6A4F),
          );
        }
        final fogShift = math.sin(_tau) * 16;
        canvas.drawOval(
          Rect.fromCenter(
            center: Offset(winRect.center.dx + fogShift, winRect.bottom - 34),
            width: winRect.width * 0.95,
            height: 24,
          ),
          Paint()..color = Colors.white.withValues(alpha: 0.28),
        );
        _drawRaindrops(canvas, winRect, count: 120);
      },
    );
    _drawShearCurtains(canvas, winRect, curtainColor: const Color(0xB3E2ECE9));
    // Steaming mug & candle on window sill
    _drawTeacup(
      canvas,
      Offset(winRect.left + 38, winRect.bottom - 4),
      0.85,
      const Color(0xFFFFF8F0),
    );

    final lampPos = Offset(size.width * 0.14, fh * 0.62);
    _drawSunOrMoonGlow(canvas, lampPos, 22, const Color(0xFFFFD166));
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: lampPos + const Offset(0, 22),
          width: 34,
          height: 32,
        ),
        const Radius.circular(6),
      ),
      Paint()..color = const Color(0xFF5C4033),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: lampPos, width: 20, height: 24),
        const Radius.circular(6),
      ),
      Paint()..color = const Color(0xFFFFF3B0),
    );

    _drawPottedPlant(
      canvas,
      Offset(size.width * 0.88, fh * 0.68),
      1.15,
      flowerColor: const Color(0xFFFFB5A7),
    );
    _drawCozyWovenRug(
      canvas,
      Offset(size.width * 0.54, fh * 0.84),
      size.width * 0.78,
      fh * 0.14,
      baseColor: const Color(0xFFD8E2DC),
      patternColor: const Color(0xFF84A59D),
    );

    final bedRect = Rect.fromCenter(
      center: Offset(size.width * 0.52, fh * 0.75),
      width: size.width * 0.68,
      height: fh * 0.19,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        bedRect.inflate(4).shift(const Offset(0, 6)),
        const Radius.circular(20),
      ),
      Paint()..color = const Color(0xFF6B4F3B),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(bedRect.left + bedRect.width * 0.26, bedRect.top + 4),
          width: bedRect.width * 0.32,
          height: 20,
        ),
        const Radius.circular(10),
      ),
      Paint()..color = const Color(0xFFE9ECEF),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(bedRect.left + bedRect.width * 0.68, bedRect.top + 4),
          width: bedRect.width * 0.32,
          height: 20,
        ),
        const Radius.circular(10),
      ),
      Paint()..color = const Color(0xFFE9ECEF),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(bedRect, const Radius.circular(22)),
      Paint()..color = const Color(0xFFF8F9FA),
    );
    // Folded sage blanket across bottom of bed + sleeping cat
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          bedRect.left + 8,
          bedRect.top + bedRect.height * 0.48,
          bedRect.width - 16,
          bedRect.height * 0.48,
        ),
        const Radius.circular(16),
      ),
      Paint()..color = const Color(0xFF52796F),
    );
    _drawSleepingCat(
      canvas,
      Offset(bedRect.center.dx + 18, bedRect.center.dy + 4),
      0.95,
      const Color(0xFFF4A261),
    );
  }

  // 06: Little Attic — Căn gác mái bí mật
  void _paintLittleAttic(Canvas canvas, Size size) {
    final fh = _focalHeight(size);
    _drawInteriorRoom(
      canvas,
      size,
      wallTop: const Color(0xFF4A3525),
      wallBottom: const Color(0xFF5C4230),
      floorTop: const Color(0xFF6F4E37),
      floorBottom: const Color(0xFF4A3222),
      baseboardColor: const Color(0xFF3E2723),
      floorYRatio: 0.66,
      fairyLights: false,
    );

    final leftCeiling =
        Path()
          ..moveTo(0, 0)
          ..lineTo(size.width * 0.5, 0)
          ..lineTo(size.width * 0.5, fh * 0.05)
          ..lineTo(0, fh * 0.44)
          ..close();
    final rightCeiling =
        Path()
          ..moveTo(size.width, 0)
          ..lineTo(size.width * 0.5, 0)
          ..lineTo(size.width * 0.5, fh * 0.05)
          ..lineTo(size.width, fh * 0.44)
          ..close();
    canvas.drawPath(leftCeiling, Paint()..color = const Color(0xFF3A2618));
    canvas.drawPath(rightCeiling, Paint()..color = const Color(0xFF3A2618));

    final beamPaint =
        Paint()
          ..color = const Color(0xFF2B1B12)
          ..strokeWidth = 9
          ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(0, fh * 0.44),
      Offset(size.width * 0.5, fh * 0.05),
      beamPaint,
    );
    canvas.drawLine(
      Offset(size.width, fh * 0.44),
      Offset(size.width * 0.5, fh * 0.05),
      beamPaint,
    );

    final skyRect = Rect.fromCenter(
      center: Offset(size.width * 0.5, fh * 0.36),
      width: size.width * 0.48,
      height: fh * 0.26,
    );
    _drawWindowWithOutdoorView(
      canvas,
      skyRect,
      frameColor: const Color(0xFF3E2723),
      sillColor: const Color(0xFF2B1B12),
      paintOutdoor: () {
        canvas.drawRect(skyRect, Paint()..color = const Color(0xFF8ECAE6));
        _drawDriftingClouds(canvas, skyRect, count: 3, scaleMultiplier: 0.85);
      },
    );
    _drawWindowLightBeams(canvas, skyRect, size, alpha: 0.20);

    for (var i = 0; i < 13; i++) {
      final fx = 0.08 + i * 0.07;
      final fy = 0.42 - (0.5 - (fx - 0.5).abs()) * 0.58;
      final glow = 0.55 + 0.45 * math.sin(_tau * 2 + i);
      final pos = Offset(size.width * fx, fh * fy);
      canvas.drawCircle(
        pos,
        10,
        Paint()..color = const Color(0xFFFFD166).withValues(alpha: glow * 0.32),
      );
      canvas.drawCircle(
        pos,
        3.4,
        Paint()..color = const Color(0xFFFFF3B0).withValues(alpha: glow),
      );
    }

    _drawWallShelfWithTrailingVines(
      canvas,
      Offset(size.width * 0.16, fh * 0.48),
      size.width * 0.20,
      vinesOnRight: false,
    );
    _drawPottedPlant(
      canvas,
      Offset(size.width * 0.86, fh * 0.67),
      1.05,
      flowerColor: const Color(0xFFFDE68A),
    );

    final matCenter = Offset(size.width * 0.5, fh * 0.72);
    final matW = size.width * 0.66;
    _drawCozyWovenRug(
      canvas,
      matCenter + const Offset(0, 14),
      matW * 1.22,
      54,
      baseColor: const Color(0xFFB5838D),
      patternColor: const Color(0xFFFFF1E6),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: matCenter, width: matW, height: 42),
        const Radius.circular(18),
      ),
      Paint()..color = const Color(0xFFFFF1E6),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: matCenter + Offset(-matW * 0.24, -14),
          width: 54,
          height: 20,
        ),
        const Radius.circular(10),
      ),
      Paint()..color = const Color(0xFFE07A5F),
    );
    // Aesthetic person curled reading on the attic mattress
    _drawPersonCurledReading(
      canvas,
      matCenter + const Offset(-10, -12),
      0.95,
      sweaterColor: const Color(0xFFF2CC8F),
      blanketColor: const Color(0xFF81B29A),
    );

    final bookBase = Offset(size.width * 0.14, fh * 0.74);
    for (var b = 0; b < 4; b++) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: bookBase + Offset(0, -b * 8.0),
            width: 34 - b * 3.0,
            height: 7,
          ),
          const Radius.circular(2),
        ),
        Paint()
          ..color =
              b.isEven ? const Color(0xFF81B29A) : const Color(0xFFE07A5F),
      );
    }
    _drawTeacup(
      canvas,
      Offset(size.width * 0.82, fh * 0.75),
      0.92,
      const Color(0xFFFFF8F0),
    );
    _drawFloatingMotes(canvas, Offset.zero & size, count: 24);
  }

  // 07: Winter Fireplace — Mùa đông bên lò sưởi
  void _paintWinterFireplace(Canvas canvas, Size size) {
    final fh = _focalHeight(size);
    _drawInteriorRoom(
      canvas,
      size,
      wallTop: const Color(0xFF3B2822),
      wallBottom: const Color(0xFF4D342C),
      floorTop: const Color(0xFF5C3A28),
      floorBottom: const Color(0xFF3A2218),
      baseboardColor: const Color(0xFF6E473B),
      floorYRatio: 0.65,
    );

    final winRect = Rect.fromLTWH(
      size.width * 0.08,
      fh * 0.16,
      size.width * 0.38,
      fh * 0.38,
    );
    _drawWindowWithOutdoorView(
      canvas,
      winRect,
      frameColor: const Color(0xFF5C4033),
      sillColor: const Color(0xFFEDE0D4),
      paintOutdoor: () {
        canvas.drawRect(winRect, Paint()..color = const Color(0xFF1D3557));
        _drawRollingHills(
          canvas,
          size,
          baseY: winRect.bottom - 28,
          bottomY: winRect.bottom,
          color: const Color(0xFFE0FBFC),
          amplitude: 8,
        );
        _drawPineTree(
          canvas,
          Offset(winRect.left + winRect.width * 0.35, winRect.bottom - 8),
          winRect.height * 0.62,
          const Color(0xFF2A4D69),
          snowCapped: true,
        );
        _drawPineTree(
          canvas,
          Offset(winRect.left + winRect.width * 0.72, winRect.bottom - 4),
          winRect.height * 0.50,
          const Color(0xFF1E3A52),
          snowCapped: true,
        );
        _drawSnowflakes(canvas, winRect, count: 40);
      },
    );
    _drawShearCurtains(canvas, winRect, curtainColor: const Color(0xCCFAF0CA));

    final floorY = fh * 0.65;
    final fpCenterX = size.width * 0.72;
    final fpW = size.width * 0.36;
    final fpH = fh * 0.32;

    canvas.drawRect(
      Rect.fromCenter(
        center: Offset(fpCenterX, (floorY - fpH) * 0.5),
        width: fpW * 0.72,
        height: floorY - fpH,
      ),
      Paint()..color = const Color(0xFF5A382E),
    );
    final fpRect = Rect.fromLTWH(fpCenterX - fpW * 0.5, floorY - fpH, fpW, fpH);
    canvas.drawRRect(
      RRect.fromRectAndRadius(fpRect, const Radius.circular(8)),
      Paint()..color = const Color(0xFF6D453A),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(fpCenterX, fpRect.top),
          width: fpW + 18,
          height: 12,
        ),
        const Radius.circular(4),
      ),
      Paint()..color = const Color(0xFF3E2723),
    );
    // Mantelpiece decor: candles & trailing garland
    _drawPottedPlant(
      canvas,
      Offset(fpCenterX - fpW * 0.30, fpRect.top - 6),
      0.65,
      flowerColor: const Color(0xFFE63946),
    );

    final fireboxRect = Rect.fromCenter(
      center: Offset(fpCenterX, floorY - fpH * 0.38),
      width: fpW * 0.66,
      height: fpH * 0.66,
    );
    canvas.drawRRect(
      RRect.fromRectAndCorners(
        fireboxRect,
        topLeft: Radius.circular(fireboxRect.width * 0.45),
        topRight: Radius.circular(fireboxRect.width * 0.45),
      ),
      Paint()..color = const Color(0xFF1E1210),
    );

    final flicker = 1.0 + 0.14 * math.sin(_tau * 4);
    _drawSunOrMoonGlow(
      canvas,
      Offset(fpCenterX, floorY - 18),
      38 * flicker,
      const Color(0xFFFF9F1C),
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(fpCenterX, floorY - 10),
          width: fireboxRect.width * 0.65,
          height: 8,
        ),
        const Radius.circular(4),
      ),
      Paint()..color = const Color(0xFF4A2C2A),
    );
    final outerFlame =
        Path()
          ..moveTo(fpCenterX - 20, floorY - 12)
          ..quadraticBezierTo(
            fpCenterX - 12,
            floorY - 46 * flicker,
            fpCenterX,
            floorY - 56 * flicker,
          )
          ..quadraticBezierTo(
            fpCenterX + 14,
            floorY - 42 * flicker,
            fpCenterX + 20,
            floorY - 12,
          )
          ..close();
    canvas.drawPath(outerFlame, Paint()..color = const Color(0xFFFF7B00));
    final innerFlame =
        Path()
          ..moveTo(fpCenterX - 10, floorY - 12)
          ..quadraticBezierTo(
            fpCenterX - 5,
            floorY - 32 * flicker,
            fpCenterX + 1,
            floorY - 38 * flicker,
          )
          ..quadraticBezierTo(
            fpCenterX + 8,
            floorY - 28 * flicker,
            fpCenterX + 10,
            floorY - 12,
          )
          ..close();
    canvas.drawPath(innerFlame, Paint()..color = const Color(0xFFFFD166));

    final chairCenter = Offset(size.width * 0.28, fh * 0.67);
    _drawCozyWovenRug(
      canvas,
      Offset(size.width * 0.48, fh * 0.78),
      size.width * 0.76,
      fh * 0.15,
      baseColor: const Color(0xFF9E2A2B),
      patternColor: const Color(0xFFF2CC8F),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: chairCenter + const Offset(0, -24),
          width: 78,
          height: 58,
        ),
        const Radius.circular(20),
      ),
      Paint()..color = const Color(0xFFB56576),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: chairCenter, width: 92, height: 38),
        const Radius.circular(16),
      ),
      Paint()..color = const Color(0xFFE56B6F),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: chairCenter + const Offset(14, 4),
          width: 36,
          height: 44,
        ),
        const Radius.circular(10),
      ),
      Paint()..color = const Color(0xFFFAF0CA),
    );
    _drawSleepingCat(
      canvas,
      Offset(size.width * 0.56, fh * 0.76),
      1.05,
      const Color(0xFFF4A261),
    );
    _drawFloatingMotes(
      canvas,
      Offset.zero & size,
      count: 24,
      color: const Color(0xFFFFB703),
    );
  }

  // 08: Midnight Bath — Bồn tắm dưới ánh trăng
  void _paintMidnightBath(Canvas canvas, Size size) {
    final fh = _focalHeight(size);
    _drawInteriorRoom(
      canvas,
      size,
      wallTop: const Color(0xFF1B2432),
      wallBottom: const Color(0xFF263345),
      floorTop: const Color(0xFF344357),
      floorBottom: const Color(0xFF1F2937),
      baseboardColor: const Color(0xFF47586E),
      floorYRatio: 0.66,
      woodPlanks: false,
    );

    _drawWallShelfWithTrailingVines(
      canvas,
      Offset(size.width * 0.14, fh * 0.25),
      size.width * 0.18,
      vinesOnRight: false,
    );
    _drawWallShelfWithTrailingVines(
      canvas,
      Offset(size.width * 0.86, fh * 0.25),
      size.width * 0.18,
      vinesOnRight: true,
    );

    final archRect = Rect.fromCenter(
      center: Offset(size.width * 0.5, fh * 0.33),
      width: size.width * 0.58,
      height: fh * 0.46,
    );
    _drawWindowWithOutdoorView(
      canvas,
      archRect,
      arched: true,
      cols: 2,
      rows: 2,
      frameColor: const Color(0xFF47586E),
      sillColor: const Color(0xFF5B6E87),
      paintOutdoor: () {
        _drawTwinklingStars(canvas, archRect, count: 32, shootingStar: true);
        _drawSunOrMoonGlow(
          canvas,
          Offset(archRect.center.dx, archRect.top + archRect.height * 0.25),
          20,
          const Color(0xFFF8F9FA),
        );
        final lakeTop = archRect.bottom - archRect.height * 0.34;
        _drawRollingHills(
          canvas,
          size,
          baseY: lakeTop,
          bottomY: archRect.bottom,
          color: const Color(0xFF1D3557),
          amplitude: 12,
        );
        canvas.drawRect(
          Rect.fromLTWH(
            archRect.left,
            lakeTop + 8,
            archRect.width,
            archRect.bottom - lakeTop,
          ),
          Paint()..color = const Color(0xFF0F203C),
        );
        for (var i = 0; i < 6; i++) {
          final w = 48.0 - i * 6 + math.sin(_tau * 2 + i) * 8;
          final y = lakeTop + 16 + i * 8.0;
          canvas.drawLine(
            Offset(archRect.center.dx - w / 2, y),
            Offset(archRect.center.dx + w / 2, y),
            Paint()
              ..color = Colors.white.withValues(alpha: 0.48)
              ..strokeWidth = 2,
          );
        }
      },
    );
    _drawWindowLightBeams(
      canvas,
      archRect,
      size,
      color: const Color(0xFFCAE9FF),
      alpha: 0.14,
    );

    _drawPottedPlant(
      canvas,
      Offset(size.width * 0.10, fh * 0.67),
      1.12,
      flowerColor: const Color(0xFFFF8FA3),
    );

    final tubCenter = Offset(size.width * 0.5, fh * 0.72);
    final tubW = size.width * 0.72;
    final tubH = fh * 0.18;

    _drawCozyWovenRug(
      canvas,
      tubCenter + Offset(0, tubH * 0.58),
      tubW * 0.96,
      32,
      baseColor: const Color(0xFFE2ECE9),
      patternColor: const Color(0xFF8ECAE6),
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: tubCenter + Offset(0, -tubH * 0.42),
        width: tubW * 0.94,
        height: 22,
      ),
      Paint()..color = const Color(0xFF8ECAE6),
    );
    for (var i = 0; i < 9; i++) {
      final dx = (i - 4) * (tubW * 0.09) + math.sin(_tau + i) * 4;
      final dy = -tubH * 0.42 + (i.isEven ? -2.0 : 2.5);
      canvas.drawOval(
        Rect.fromCenter(
          center: tubCenter + Offset(dx, dy),
          width: 9,
          height: 5,
        ),
        Paint()..color = const Color(0xFFFF8FA3),
      );
    }
    canvas.drawRRect(
      RRect.fromRectAndCorners(
        Rect.fromCenter(center: tubCenter, width: tubW, height: tubH * 0.85),
        bottomLeft: const Radius.circular(42),
        bottomRight: const Radius.circular(42),
        topLeft: const Radius.circular(10),
        topRight: const Radius.circular(10),
      ),
      Paint()..color = const Color(0xFFFDF8F2),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: tubCenter + Offset(0, -tubH * 0.40),
          width: tubW * 1.04,
          height: 10,
        ),
        const Radius.circular(5),
      ),
      Paint()..color = Colors.white,
    );
    final candlePos = tubCenter + Offset(tubW * 0.36, -tubH * 0.52);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: candlePos, width: 10, height: 14),
        const Radius.circular(2),
      ),
      Paint()..color = const Color(0xFFFFF1E6),
    );
    _drawSunOrMoonGlow(
      canvas,
      candlePos + const Offset(0, -10),
      8,
      const Color(0xFFFFB703),
    );

    _drawSteamWisps(
      canvas,
      tubCenter + Offset(-tubW * 0.22, -tubH * 0.5),
      wisps: 4,
    );
    _drawSteamWisps(
      canvas,
      tubCenter + Offset(tubW * 0.10, -tubH * 0.5),
      wisps: 4,
    );
    _drawFloatingMotes(canvas, Offset.zero & size, count: 24);
  }

  // 09: The Flower Hill — Ngôi nhà giữa đồi hoa
  void _paintFlowerHill(Canvas canvas, Size size) {
    final fh = _focalHeight(size);
    _drawTwinklingStars(
      canvas,
      Rect.fromLTWH(0, 0, size.width, fh * 0.56),
      count: 48,
      shootingStar: true,
    );
    _drawSunOrMoonGlow(
      canvas,
      Offset(size.width * 0.22, fh * 0.18),
      20,
      const Color(0xFFFDE68A),
      isCrescent: true,
    );

    _drawRollingHills(
      canvas,
      size,
      baseY: fh * 0.44,
      color: const Color(0xFF352F52),
      amplitude: 28,
      frequency: 1.4,
    );
    _drawRollingHills(
      canvas,
      size,
      baseY: fh * 0.53,
      color: const Color(0xFF463F66),
      amplitude: 22,
      frequency: 1.8,
      phaseShift: 1.2,
    );
    _drawRollingHills(
      canvas,
      size,
      baseY: fh * 0.61,
      color: const Color(0xFF3A5A40),
      amplitude: 20,
      frequency: 1.2,
      phaseShift: 0.5,
    );
    _drawRollingHills(
      canvas,
      size,
      baseY: fh * 0.72,
      color: const Color(0xFF2D4732),
      amplitude: 14,
      frequency: 1.5,
      phaseShift: 2.2,
    );

    final path =
        Path()
          ..moveTo(size.width * 0.48, fh * 0.59)
          ..quadraticBezierTo(
            size.width * 0.40,
            fh * 0.76,
            size.width * 0.54,
            size.height,
          )
          ..lineTo(size.width * 0.66, size.height)
          ..quadraticBezierTo(
            size.width * 0.48,
            fh * 0.76,
            size.width * 0.53,
            fh * 0.59,
          )
          ..close();
    canvas.drawPath(
      path,
      Paint()..color = const Color(0xFFD4A373).withValues(alpha: 0.42),
    );

    _drawTinyCabin(canvas, Offset(size.width * 0.5, fh * 0.56), 1.15);

    _drawWildflowersField(
      canvas,
      Rect.fromLTWH(0, fh * 0.62, size.width, size.height - fh * 0.62),
      count: 42,
    );
    _drawFloatingMotes(canvas, Offset.zero & size, count: 28);
  }

  // 10: Cloud Watching — Nằm ngắm mây
  void _paintCloudWatching(Canvas canvas, Size size) {
    final fh = _focalHeight(size);
    _drawFluffyCloud(
      canvas,
      Offset(size.width * (0.28 + 0.06 * math.sin(_tau * 0.5)), fh * 0.24),
      1.65,
      Colors.white.withValues(alpha: 0.94),
    );
    _drawFluffyCloud(
      canvas,
      Offset(size.width * (0.74 - 0.05 * math.cos(_tau * 0.5)), fh * 0.34),
      1.45,
      Colors.white.withValues(alpha: 0.90),
    );
    _drawDriftingClouds(
      canvas,
      Rect.fromLTWH(0, 0, size.width, fh * 0.52),
      count: 4,
    );

    _drawRollingHills(
      canvas,
      size,
      baseY: fh * 0.58,
      color: const Color(0xFF74A57F),
      amplitude: 18,
    );
    _drawRollingHills(
      canvas,
      size,
      baseY: fh * 0.67,
      color: const Color(0xFF4F7756),
      amplitude: 14,
      phaseShift: 1.9,
    );

    _drawWildflowersField(
      canvas,
      Rect.fromLTWH(0, fh * 0.61, size.width, size.height - fh * 0.61),
      count: 38,
      petalColors: const [Colors.white, Color(0xFFFFF8E7)],
    );

    // Woven picnic mat in the daisy meadow
    final center = Offset(size.width * 0.5, fh * 0.72);
    _drawCozyWovenRug(
      canvas,
      center + const Offset(0, 4),
      138,
      42,
      baseColor: const Color(0xFFFFF8F0),
      patternColor: const Color(0xFFE07A5F),
    );

    // Aesthetic daydreamer lying on the mat with flowing hair & straw hat
    const hairColor = Color(0xFF2B1B17);
    const skinColor = Color(0xFFFADECD);
    final breathe = math.sin(_tau * 2) * 1.2;

    // Flowing wavy hair spread on pillow
    canvas.drawOval(
      Rect.fromCenter(
        center: center + const Offset(-34, -2),
        width: 30,
        height: 22,
      ),
      Paint()..color = hairColor,
    );
    canvas.drawCircle(
      center + const Offset(-28, -2),
      10,
      Paint()..color = skinColor,
    );
    // Peaceful closed eye & rosy cheek
    canvas.drawCircle(
      center + const Offset(-26, -4),
      2.5,
      Paint()..color = const Color(0xFFFF8FA3).withValues(alpha: 0.55),
    );
    // Soft linen dress & skirt
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: center + Offset(-6, 1 + breathe * 0.5),
          width: 34,
          height: 18,
        ),
        const Radius.circular(9),
      ),
      Paint()..color = const Color(0xFFFFF1E6),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: center + const Offset(24, 3),
          width: 40,
          height: 16,
        ),
        const Radius.circular(8),
      ),
      Paint()..color = const Color(0xFF81B29A),
    );
    // Straw sunhat with ribbon beside them
    final hatPos = center + const Offset(-14, 18);
    canvas.drawOval(
      Rect.fromCenter(center: hatPos, width: 30, height: 12),
      Paint()..color = const Color(0xFFF2CC8F),
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: hatPos + const Offset(0, -2),
        width: 15,
        height: 7,
      ),
      Paint()..color = const Color(0xFFE07A5F),
    );
    _drawFloatingMotes(
      canvas,
      Offset.zero & size,
      count: 24,
      color: Colors.white,
    );
  }

  // 11: The Lakeside Cabin — Căn nhà bên hồ
  void _paintLakesideCabin(Canvas canvas, Size size) {
    final fh = _focalHeight(size);
    _drawTwinklingStars(
      canvas,
      Rect.fromLTWH(0, 0, size.width, fh * 0.44),
      count: 38,
      shootingStar: true,
    );
    final moonX = size.width * 0.74;
    _drawSunOrMoonGlow(
      canvas,
      Offset(moonX, fh * 0.20),
      22,
      const Color(0xFFFFF8E7),
    );

    final shoreY = fh * 0.54;
    _drawRollingHills(
      canvas,
      size,
      baseY: fh * 0.44,
      bottomY: shoreY + 10,
      color: const Color(0xFF283845),
      amplitude: 20,
    );
    _drawRollingHills(
      canvas,
      size,
      baseY: fh * 0.50,
      bottomY: shoreY + 10,
      color: const Color(0xFF1F2D3A),
      amplitude: 12,
      phaseShift: 1.5,
    );

    final lakeRect = Rect.fromLTWH(0, shoreY, size.width, size.height - shoreY);
    canvas.drawRect(
      lakeRect,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF1B263B), Color(0xFF0D1B2A)],
        ).createShader(lakeRect),
    );

    final bankPath =
        Path()
          ..moveTo(0, shoreY - 12)
          ..quadraticBezierTo(
            size.width * 0.28,
            shoreY - 8,
            size.width * 0.42,
            shoreY + 16,
          )
          ..lineTo(0, shoreY + 26)
          ..close();
    canvas.drawPath(bankPath, Paint()..color = const Color(0xFF1B3022));

    _drawPineTree(
      canvas,
      Offset(size.width * 0.10, shoreY - 2),
      fh * 0.16,
      const Color(0xFF132A13),
    );
    _drawTinyCabin(canvas, Offset(size.width * 0.25, shoreY - 14), 1.05);

    for (var i = 0; i < 4; i++) {
      final y = shoreY + 18 + i * 7.0;
      final w = 24.0 - i * 4 + math.sin(_tau * 2 + i) * 4;
      canvas.drawLine(
        Offset(size.width * 0.27 - w / 2, y),
        Offset(size.width * 0.27 + w / 2, y),
        Paint()
          ..color = const Color(0xFFFFD166).withValues(alpha: 0.35)
          ..strokeWidth = 2,
      );
    }

    final dockY = shoreY + 14;
    final dockLeft = size.width * 0.34;
    final dockRight = size.width * 0.56;
    for (var px = dockLeft + 8; px <= dockRight; px += 18) {
      canvas.drawLine(
        Offset(px, dockY - 4),
        Offset(px, dockY + 14),
        Paint()
          ..color = const Color(0xFF4A3222)
          ..strokeWidth = 3.5,
      );
    }
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(dockLeft, dockY - 4, dockRight - dockLeft, 6),
        const Radius.circular(2),
      ),
      Paint()..color = const Color(0xFF8B5E3C),
    );

    final bob = math.sin(_tau * 1.5) * 2.5;
    final boatCenter = Offset(dockRight + 24, dockY + 10 + bob);
    final boatPath =
        Path()
          ..moveTo(boatCenter.dx - 22, boatCenter.dy - 4)
          ..lineTo(boatCenter.dx + 22, boatCenter.dy - 4)
          ..lineTo(boatCenter.dx + 15, boatCenter.dy + 6)
          ..lineTo(boatCenter.dx - 15, boatCenter.dy + 6)
          ..close();
    canvas.drawPath(boatPath, Paint()..color = const Color(0xFF6F4E37));

    for (var i = 0; i < 10; i++) {
      final y = shoreY + 14 + i * ((size.height - shoreY - 24) / 10);
      final w = 64.0 - i * 4.5 + math.sin(_tau * 2 + i) * 10;
      canvas.drawLine(
        Offset(moonX - w / 2, y),
        Offset(moonX + w / 2, y),
        Paint()
          ..color = const Color(0xFFFFF8E7).withValues(alpha: 0.52 - i * 0.03)
          ..strokeWidth = 2.4
          ..strokeCap = StrokeCap.round,
      );
    }
    _drawFloatingMotes(canvas, Offset.zero & size, count: 22);
  }

  // 12: Under the Old Tree — Dưới tán cây già
  void _paintUnderOldTree(Canvas canvas, Size size) {
    final fh = _focalHeight(size);
    final sunX = size.width * 0.68;
    final lakeTop = fh * 0.52;
    _drawSunOrMoonGlow(
      canvas,
      Offset(sunX, lakeTop - 16),
      34,
      const Color(0xFFFFB703),
    );

    _drawRollingHills(
      canvas,
      size,
      baseY: lakeTop - 8,
      bottomY: lakeTop + 20,
      color: const Color(0xFF5E548E),
      amplitude: 16,
    );

    canvas.drawRect(
      Rect.fromLTWH(0, lakeTop, size.width, size.height - lakeTop),
      Paint()..color = const Color(0xFF9F86C0),
    );
    for (var i = 0; i < 5; i++) {
      final y = lakeTop + 10 + i * 8.0;
      final w = 54.0 - i * 6 + math.sin(_tau * 2 + i) * 8;
      canvas.drawLine(
        Offset(sunX - w / 2, y),
        Offset(sunX + w / 2, y),
        Paint()
          ..color = const Color(0xFFFFD166).withValues(alpha: 0.65)
          ..strokeWidth = 2.2,
      );
    }

    _drawRollingHills(
      canvas,
      size,
      baseY: fh * 0.64,
      color: const Color(0xFF385A44),
      amplitude: 22,
      frequency: 1.1,
    );
    _drawWildflowersField(
      canvas,
      Rect.fromLTWH(0, fh * 0.64, size.width, size.height - fh * 0.64),
      count: 32,
      petalColors: const [Colors.white, Color(0xFFFFF8F0)],
    );

    const treeColor = Color(0xFF231942);
    final trunkBaseY = fh * 0.70;
    final trunkX = size.width * 0.18;
    final trunkPath =
        Path()
          ..moveTo(trunkX - 28, trunkBaseY + 12)
          ..quadraticBezierTo(trunkX - 14, fh * 0.45, trunkX - 12, fh * 0.20)
          ..lineTo(trunkX + 18, fh * 0.20)
          ..quadraticBezierTo(
            trunkX + 16,
            fh * 0.45,
            trunkX + 32,
            trunkBaseY + 12,
          )
          ..close();
    canvas.drawPath(trunkPath, Paint()..color = treeColor);

    final branchY = fh * 0.25;
    final branchPath =
        Path()
          ..moveTo(trunkX, branchY + 8)
          ..quadraticBezierTo(
            size.width * 0.34,
            branchY - 6,
            size.width * 0.54,
            branchY + 4,
          )
          ..lineTo(size.width * 0.54, branchY + 12)
          ..quadraticBezierTo(
            size.width * 0.34,
            branchY + 6,
            trunkX,
            branchY + 24,
          )
          ..close();
    canvas.drawPath(branchPath, Paint()..color = treeColor);

    final canopyClusters = [
      (Offset(size.width * 0.12, fh * 0.12), size.width * 0.22),
      (Offset(size.width * 0.28, fh * 0.14), size.width * 0.20),
      (Offset(size.width * 0.44, fh * 0.18), size.width * 0.16),
      (Offset(size.width * 0.04, fh * 0.22), size.width * 0.16),
    ];
    for (final (c, r) in canopyClusters) {
      canvas.drawCircle(c, r, Paint()..color = treeColor);
    }

    final pivot = Offset(size.width * 0.40, branchY + 6);
    final angle = math.sin(_tau) * 0.12;
    final ropeLen = fh * 0.23;
    final seatCenter =
        pivot + Offset(math.sin(angle) * ropeLen, math.cos(angle) * ropeLen);
    final ropePaint =
        Paint()
          ..color = const Color(0xFFD4A373)
          ..strokeWidth = 2.0;
    canvas.drawLine(
      pivot + const Offset(-10, 0),
      seatCenter + const Offset(-12, 0),
      ropePaint,
    );
    canvas.drawLine(
      pivot + const Offset(10, 0),
      seatCenter + const Offset(12, 0),
      ropePaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: seatCenter, width: 32, height: 6),
        const Radius.circular(3),
      ),
      Paint()..color = const Color(0xFF9C6644),
    );
    _drawFloatingMotes(canvas, Offset.zero & size, count: 26);
  }

  // 13: Seaside Hideaway — Góc nhỏ bên biển
  void _paintSeasideHideaway(Canvas canvas, Size size) {
    final fh = _focalHeight(size);
    _drawDriftingClouds(
      canvas,
      Rect.fromLTWH(0, 0, size.width, fh * 0.44),
      count: 4,
    );
    _drawSunOrMoonGlow(
      canvas,
      Offset(size.width * 0.78, fh * 0.18),
      24,
      const Color(0xFFFFF3B0),
    );

    final gullPaint =
        Paint()
          ..color = Colors.white.withValues(alpha: 0.75)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.6;
    for (var i = 0; i < 4; i++) {
      final gx = size.width * (0.58 + i * 0.09);
      final gy = fh * (0.22 + (i % 2) * 0.04) + math.sin(_tau + i) * 3;
      final path =
          Path()
            ..moveTo(gx - 7, gy)
            ..quadraticBezierTo(gx - 3, gy - 4, gx, gy)
            ..quadraticBezierTo(gx + 3, gy - 4, gx + 7, gy);
      canvas.drawPath(path, gullPaint);
    }

    final seaTop = fh * 0.48;
    final seaRect = Rect.fromLTWH(0, seaTop, size.width, size.height - seaTop);
    canvas.drawRect(
      seaRect,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF0077B6), Color(0xFF023E8A)],
        ).createShader(seaRect),
    );

    for (var i = 0; i < 9; i++) {
      final y = seaTop + 16 + i * ((size.height - seaTop - 24) / 9);
      final shift = math.sin(_tau + i * 1.1) * 14;
      canvas.drawLine(
        Offset(size.width * 0.42 + shift, y),
        Offset(size.width * 0.86 + shift, y),
        Paint()
          ..color = Colors.white.withValues(alpha: 0.45)
          ..strokeWidth = 2.2
          ..strokeCap = StrokeCap.round,
      );
    }

    final cliffPath =
        Path()
          ..moveTo(0, fh * 0.56)
          ..quadraticBezierTo(
            size.width * 0.36,
            fh * 0.54,
            size.width * 0.56,
            fh * 0.64,
          )
          ..quadraticBezierTo(
            size.width * 0.62,
            size.height * 0.82,
            size.width * 0.48,
            size.height,
          )
          ..lineTo(0, size.height)
          ..close();
    canvas.drawPath(cliffPath, Paint()..color = const Color(0xFF6B705C));

    final grassCap =
        Path()
          ..moveTo(0, fh * 0.55)
          ..quadraticBezierTo(
            size.width * 0.34,
            fh * 0.53,
            size.width * 0.55,
            fh * 0.63,
          )
          ..lineTo(size.width * 0.48, fh * 0.68)
          ..lineTo(0, fh * 0.64)
          ..close();
    canvas.drawPath(grassCap, Paint()..color = const Color(0xFF588157));

    _drawTinyCabin(
      canvas,
      Offset(size.width * 0.24, fh * 0.51),
      1.15,
      wallColor: const Color(0xFFF8F9FA),
      roofColor: const Color(0xFF0077B6),
      smokeFromChimney: false,
    );

    final chairPos = Offset(size.width * 0.42, fh * 0.57);
    final chairPaint =
        Paint()
          ..color = const Color(0xFFD4A373)
          ..strokeWidth = 3.2
          ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      chairPos + const Offset(-10, -12),
      chairPos + const Offset(4, 6),
      chairPaint,
    );
    canvas.drawLine(
      chairPos + const Offset(-2, 0),
      chairPos + const Offset(14, 0),
      chairPaint,
    );
    canvas.drawLine(
      chairPos + const Offset(10, 0),
      chairPos + const Offset(14, 8),
      chairPaint,
    );
  }

  // 14: The Secret Garden — Khu vườn bí mật
  void _paintSecretGarden(Canvas canvas, Size size) {
    final fh = _focalHeight(size);
    _drawSunOrMoonGlow(
      canvas,
      Offset(size.width * 0.25, fh * 0.16),
      28,
      const Color(0xFFFFF3B0),
    );

    _drawRollingHills(
      canvas,
      size,
      baseY: fh * 0.48,
      color: const Color(0xFF74C69D),
      amplitude: 16,
    );
    _drawRollingHills(
      canvas,
      size,
      baseY: fh * 0.58,
      color: const Color(0xFF40916C),
      amplitude: 12,
      phaseShift: 1.4,
    );

    final fenceBaseY = fh * 0.56;
    final fencePaint = Paint()..color = const Color(0xFFF8F9FA);
    canvas.drawRect(
      Rect.fromLTWH(0, fenceBaseY - 22, size.width, 4),
      fencePaint,
    );
    canvas.drawRect(
      Rect.fromLTWH(0, fenceBaseY - 10, size.width, 4),
      fencePaint,
    );
    for (var x = 8.0; x < size.width; x += 18) {
      if ((x - size.width * 0.5).abs() > 68) {
        canvas.drawRRect(
          RRect.fromRectAndCorners(
            Rect.fromLTWH(x, fenceBaseY - 30, 8, 32),
            topLeft: const Radius.circular(4),
            topRight: const Radius.circular(4),
          ),
          fencePaint,
        );
      }
    }

    final archCenterX = size.width * 0.5;
    final archBottomY = fh * 0.62;
    const archW = 144.0;
    const archH = 148.0;
    final archPath =
        Path()
          ..moveTo(archCenterX - archW * 0.5, archBottomY)
          ..lineTo(archCenterX - archW * 0.5, archBottomY - archH * 0.52)
          ..arcToPoint(
            Offset(archCenterX + archW * 0.5, archBottomY - archH * 0.52),
            radius: const Radius.circular(archW * 0.5),
          )
          ..lineTo(archCenterX + archW * 0.5, archBottomY);
    canvas.drawPath(
      archPath,
      Paint()
        ..color = const Color(0xFF2D6A4F)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 14
        ..strokeCap = StrokeCap.round,
    );

    for (var i = 0; i <= 10; i++) {
      final a = math.pi + (i / 10) * math.pi;
      final rx = archCenterX + math.cos(a) * (archW * 0.5);
      final ry = (archBottomY - archH * 0.52) + math.sin(a) * (archW * 0.5);
      canvas.drawCircle(
        Offset(rx, ry),
        7,
        Paint()
          ..color =
              i.isEven ? const Color(0xFFFF8FA3) : const Color(0xFFFFB5A7),
      );
    }

    final benchCenter = Offset(archCenterX, archBottomY - 18);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: benchCenter + const Offset(0, -10),
          width: 78,
          height: 14,
        ),
        const Radius.circular(4),
      ),
      Paint()..color = const Color(0xFF8B5E3C),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: benchCenter, width: 84, height: 8),
        const Radius.circular(3),
      ),
      Paint()..color = const Color(0xFFA47148),
    );
    for (final dx in [-34.0, 34.0]) {
      canvas.drawRect(
        Rect.fromLTWH(benchCenter.dx + dx - 2.5, benchCenter.dy + 4, 5, 16),
        Paint()..color = const Color(0xFF5C4033),
      );
    }

    for (var i = 0; i < 6; i++) {
      final t = i / 5.0;
      final sy = archBottomY + 12 + t * (size.height - archBottomY - 26);
      final sx = archCenterX + math.sin(t * math.pi * 1.4) * 22;
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(sx, sy),
          width: 34 + t * 24,
          height: 11 + t * 7,
        ),
        Paint()..color = const Color(0xFFD6CCC2),
      );
    }

    _drawWildflowersField(
      canvas,
      Rect.fromLTWH(0, fh * 0.60, size.width, size.height - fh * 0.60),
      count: 34,
    );
    _drawFloatingMotes(
      canvas,
      Offset.zero & size,
      count: 26,
      color: const Color(0xFFFFB5A7),
    );
  }

  // 15: Forest Hideout — Chốn trú ẩn trong rừng
  void _paintForestHideout(Canvas canvas, Size size) {
    final fh = _focalHeight(size);
    _drawRollingHills(
      canvas,
      size,
      baseY: fh * 0.50,
      color: const Color(0xFF1B4332),
      amplitude: 18,
    );
    _drawRollingHills(
      canvas,
      size,
      baseY: fh * 0.60,
      color: const Color(0xFF2D6A4F),
      amplitude: 14,
      phaseShift: 1.5,
    );
    _drawRollingHills(
      canvas,
      size,
      baseY: fh * 0.70,
      color: const Color(0xFF1E3F2B),
      amplitude: 10,
      phaseShift: 0.7,
    );

    for (var i = 0; i < 9; i++) {
      final tx = size.width * (0.06 + i * 0.11);
      if ((tx - size.width * 0.5).abs() > 36) {
        _drawPineTree(
          canvas,
          Offset(tx, fh * (0.62 + (i % 2) * 0.04)),
          fh * (0.34 + (i % 3) * 0.07),
          i.isEven ? const Color(0xFF081C15) : const Color(0xFF1B4332),
        );
      }
    }

    _drawTinyCabin(canvas, Offset(size.width * 0.5, fh * 0.57), 1.1);

    final streamPath =
        Path()
          ..moveTo(size.width * 0.28, fh * 0.66)
          ..quadraticBezierTo(
            size.width * 0.42,
            size.height * 0.78,
            size.width * 0.22,
            size.height,
          )
          ..lineTo(size.width * 0.48, size.height)
          ..quadraticBezierTo(
            size.width * 0.58,
            size.height * 0.78,
            size.width * 0.38,
            fh * 0.66,
          )
          ..close();
    canvas.drawPath(streamPath, Paint()..color = const Color(0xFF48CAE4));
    for (var i = 0; i < 5; i++) {
      final ry = fh * 0.70 + i * ((size.height - fh * 0.70) / 5.5);
      final rx = size.width * 0.36 + math.sin(_tau + i) * 6;
      canvas.drawLine(
        Offset(rx - 10, ry),
        Offset(rx + 10, ry),
        Paint()
          ..color = Colors.white.withValues(alpha: 0.55)
          ..strokeWidth = 1.8,
      );
    }

    for (var i = 0; i < 5; i++) {
      final sy = fh * 0.64 + i * ((size.height - fh * 0.64) / 6);
      final sx = size.width * (0.54 + i * 0.035);
      canvas.drawOval(
        Rect.fromCenter(center: Offset(sx, sy), width: 26, height: 10),
        Paint()..color = const Color(0xFF52B788),
      );
    }

    for (var i = 0; i < 3; i++) {
      final dx = math.sin(_tau + i * 1.8) * 24;
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(size.width * 0.5 + dx, fh * (0.44 + i * 0.1)),
          width: size.width * 0.85,
          height: 18,
        ),
        Paint()..color = Colors.white.withValues(alpha: 0.22),
      );
    }
    _drawFloatingMotes(canvas, Offset.zero & size, count: 24);
  }

  // 16: Good Cat — Một chiều bên mèo
  void _paintGoodCat(Canvas canvas, Size size) {
    final fh = _focalHeight(size);
    _drawInteriorRoom(
      canvas,
      size,
      wallTop: const Color(0xFF3D2B3D),
      wallBottom: const Color(0xFF4E384E),
      floorTop: const Color(0xFF5E4352),
      floorBottom: const Color(0xFF3A2633),
      baseboardColor: const Color(0xFF735365),
      floorYRatio: 0.68,
    );

    _drawWallShelfWithTrailingVines(
      canvas,
      Offset(size.width * 0.14, fh * 0.22),
      size.width * 0.20,
      vinesOnRight: false,
    );
    _drawFramedWallArt(
      canvas,
      Offset(size.width * 0.88, fh * 0.24),
      scale: 0.72,
      verticalPair: true,
    );

    final winRect = Rect.fromCenter(
      center: Offset(size.width * 0.5, fh * 0.36),
      width: size.width * 0.64,
      height: fh * 0.44,
    );
    _drawWindowWithOutdoorView(
      canvas,
      winRect,
      cols: 2,
      rows: 1,
      frameColor: const Color(0xFF5E4352),
      sillColor: const Color(0xFFDDB892),
      paintOutdoor: () {
        _drawSunOrMoonGlow(
          canvas,
          Offset(winRect.center.dx, winRect.bottom - 52),
          36,
          const Color(0xFFFFAFCC),
        );
        _drawDriftingClouds(
          canvas,
          winRect,
          count: 3,
          color: const Color(0xB3FFE5EC),
        );
        _drawRollingHills(
          canvas,
          size,
          baseY: winRect.bottom - 26,
          bottomY: winRect.bottom,
          color: const Color(0xFF4A304D),
          amplitude: 12,
        );
      },
    );
    _drawShearCurtains(canvas, winRect, curtainColor: const Color(0xB3FFE5EC));
    _drawWindowLightBeams(
      canvas,
      winRect,
      size,
      color: const Color(0xFFFFAFCC),
      alpha: 0.18,
    );

    final sillY = winRect.bottom;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(size.width * 0.5, sillY + 6),
          width: winRect.width + 32,
          height: 16,
        ),
        const Radius.circular(6),
      ),
      Paint()..color = const Color(0xFFD4A373),
    );

    _drawPottedPlant(
      canvas,
      Offset(winRect.left + 30, sillY),
      0.95,
      flowerColor: const Color(0xFFFFB5A7),
    );

    _drawSleepingCat(
      canvas,
      Offset(size.width * 0.46, sillY - 6),
      1.22,
      const Color(0xFF2B2D42),
    );

    // Aesthetic Lo-Fi person sitting by the window gazing at the cat & sunset
    _drawPersonByWindow(
      canvas,
      Offset(winRect.right - 34, sillY + 26),
      1.12,
      sweaterColor: const Color(0xFFE07A5F),
      facingLeft: true,
    );

    _drawCozyWovenRug(
      canvas,
      Offset(size.width * 0.5, fh * 0.82),
      size.width * 0.76,
      fh * 0.13,
      baseColor: const Color(0xFFFFE5EC),
      patternColor: const Color(0xFFB5838D),
    );
    _drawFloatingMotes(canvas, Offset.zero & size, count: 24);
  }

  // 17: Dog Friend — Người bạn bốn chân
  void _paintDogFriend(Canvas canvas, Size size) {
    final fh = _focalHeight(size);
    _drawTwinklingStars(
      canvas,
      Rect.fromLTWH(0, 0, size.width, fh * 0.56),
      count: 38,
      shootingStar: true,
    );
    _drawSunOrMoonGlow(
      canvas,
      Offset(size.width * 0.76, fh * 0.18),
      18,
      const Color(0xFFFDE68A),
      isCrescent: true,
    );

    _drawRollingHills(
      canvas,
      size,
      baseY: fh * 0.52,
      color: const Color(0xFF2B2D42),
      amplitude: 22,
    );
    _drawRollingHills(
      canvas,
      size,
      baseY: fh * 0.62,
      color: const Color(0xFF1F2438),
      amplitude: 16,
      phaseShift: 1.2,
    );

    final ridgeY = fh * 0.61;
    // Aesthetic person sitting on the starry hill with flowing hair & scarf
    _drawPersonByWindow(
      canvas,
      Offset(size.width * 0.43, ridgeY - 2),
      1.05,
      sweaterColor: const Color(0xFFE07A5F),
      facingLeft: false,
    );

    _drawDogCompanion(
      canvas,
      Offset(size.width * 0.58, ridgeY + 2),
      1.15,
      const Color(0xFFD4A373),
      sitting: true,
    );
    _drawWildflowersField(
      canvas,
      Rect.fromLTWH(0, fh * 0.65, size.width, size.height - fh * 0.65),
      count: 22,
    );
    _drawFloatingMotes(canvas, Offset.zero & size, count: 20);
  }

  // 18: Afternoon Nap — Giấc ngủ trưa
  void _paintAfternoonNap(Canvas canvas, Size size) {
    final fh = _focalHeight(size);
    _drawInteriorRoom(
      canvas,
      size,
      wallTop: const Color(0xFFF6EFE6),
      wallBottom: const Color(0xFFEADBC8),
      floorTop: const Color(0xFFC8A98E),
      floorBottom: const Color(0xFF9C7A5B),
      baseboardColor: const Color(0xFFD8C3B0),
      floorYRatio: 0.65,
    );

    _drawWallShelfWithTrailingVines(
      canvas,
      Offset(size.width * 0.14, fh * 0.22),
      size.width * 0.20,
      vinesOnRight: false,
    );
    _drawFramedWallArt(
      canvas,
      Offset(size.width * 0.88, fh * 0.24),
      scale: 0.72,
      verticalPair: true,
    );

    final winRect = Rect.fromCenter(
      center: Offset(size.width * 0.5, fh * 0.30),
      width: size.width * 0.58,
      height: fh * 0.34,
    );
    _drawWindowWithOutdoorView(
      canvas,
      winRect,
      frameColor: const Color(0xFFD8C3B0),
      sillColor: const Color(0xFFC4A78E),
      paintOutdoor: () {
        _drawSunOrMoonGlow(
          canvas,
          Offset(winRect.left + 48, winRect.top + 36),
          24,
          const Color(0xFFFFF3B0),
        );
        _drawRollingHills(
          canvas,
          size,
          baseY: winRect.bottom - 26,
          bottomY: winRect.bottom,
          color: const Color(0xFF95D5B2),
          amplitude: 10,
        );
      },
    );
    _drawShearCurtains(canvas, winRect);
    _drawWindowLightBeams(canvas, winRect, size, alpha: 0.28);

    _drawPottedPlant(
      canvas,
      Offset(size.width * 0.10, fh * 0.66),
      1.15,
      flowerColor: const Color(0xFFFFB5A7),
    );

    final sofaCenter = Offset(size.width * 0.5, fh * 0.62);
    final sofaW = size.width * 0.72;
    final sofaH = fh * 0.18;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: sofaCenter + Offset(0, -sofaH * 0.25),
          width: sofaW * 0.94,
          height: sofaH * 0.68,
        ),
        const Radius.circular(20),
      ),
      Paint()..color = const Color(0xFFC69C72),
    );
    // Plush pillow
    canvas.drawOval(
      Rect.fromCenter(
        center: sofaCenter + Offset(-sofaW * 0.26, -6),
        width: 34,
        height: 18,
      ),
      Paint()..color = const Color(0xFFFFF8F0),
    );
    // Aesthetic napping person with wavy hair, closed eyelash, and cozy blanket
    final napHead = sofaCenter + Offset(-sofaW * 0.18, -10);
    canvas.drawOval(
      Rect.fromCenter(
        center: napHead + const Offset(-4, 2),
        width: 24,
        height: 18,
      ),
      Paint()..color = const Color(0xFF3B2314),
    );
    canvas.drawCircle(
      napHead + const Offset(2, 0),
      9.5,
      Paint()..color = const Color(0xFFFADECD),
    );
    canvas.drawArc(
      Rect.fromCenter(
        center: napHead + const Offset(4, 1),
        width: 4.5,
        height: 2.5,
      ),
      0.1,
      math.pi * 0.8,
      false,
      Paint()
        ..color = const Color(0xFF3B2314)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2,
    );
    final breathe = math.sin(_tau * 2) * 1.5;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: sofaCenter + Offset(12, -4 + breathe * 0.5),
          width: sofaW * 0.54,
          height: 24,
        ),
        const Radius.circular(12),
      ),
      Paint()..color = const Color(0xFFA3B18A),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: sofaCenter + Offset(0, sofaH * 0.20),
          width: sofaW,
          height: sofaH * 0.55,
        ),
        const Radius.circular(18),
      ),
      Paint()..color = const Color(0xFFD4A373),
    );

    _drawCozyWovenRug(
      canvas,
      Offset(size.width * 0.52, fh * 0.78),
      size.width * 0.70,
      46,
      baseColor: const Color(0xFFFAF0CA),
      patternColor: const Color(0xFFD4A373),
    );
    _drawDogCompanion(
      canvas,
      Offset(size.width * 0.52, fh * 0.76),
      1.15,
      const Color(0xFF7F5539),
      sitting: false,
    );
    _drawFloatingMotes(canvas, Offset.zero & size, count: 28);
  }

  // 19: Little Picnic — Buổi picnic của hai người bạn
  void _paintLittlePicnic(Canvas canvas, Size size) {
    final fh = _focalHeight(size);
    _drawDriftingClouds(
      canvas,
      Rect.fromLTWH(0, 0, size.width, fh * 0.50),
      count: 4,
    );

    _drawRollingHills(
      canvas,
      size,
      baseY: fh * 0.54,
      color: const Color(0xFF70A95E),
      amplitude: 18,
    );
    _drawRollingHills(
      canvas,
      size,
      baseY: fh * 0.64,
      color: const Color(0xFF528943),
      amplitude: 12,
      phaseShift: 1.6,
    );

    _drawWildflowersField(
      canvas,
      Rect.fromLTWH(0, fh * 0.62, size.width, size.height - fh * 0.62),
      count: 28,
    );

    final blanketCenter = Offset(size.width * 0.5, fh * 0.73);
    final blanketPath =
        Path()
          ..moveTo(blanketCenter.dx - 76, blanketCenter.dy - 18)
          ..lineTo(blanketCenter.dx + 76, blanketCenter.dy - 18)
          ..lineTo(blanketCenter.dx + 102, blanketCenter.dy + 24)
          ..lineTo(blanketCenter.dx - 102, blanketCenter.dy + 24)
          ..close();
    canvas.drawPath(blanketPath, Paint()..color = const Color(0xFFFFF3D1));
    final checkPaint =
        Paint()
          ..color = const Color(0xFFE07A5F).withValues(alpha: 0.28)
          ..strokeWidth = 3;
    for (var i = -2; i <= 2; i++) {
      canvas.drawLine(
        Offset(blanketCenter.dx + i * 26.0, blanketCenter.dy - 18),
        Offset(blanketCenter.dx + i * 34.0, blanketCenter.dy + 24),
        checkPaint,
      );
    }

    final basketPos = blanketCenter + const Offset(-38, -4);
    canvas.drawOval(
      Rect.fromCenter(
        center: basketPos + const Offset(8, -12),
        width: 22,
        height: 9,
      ),
      Paint()..color = const Color(0xFFD4A373),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: basketPos, width: 34, height: 22),
        const Radius.circular(5),
      ),
      Paint()..color = const Color(0xFFBC6C25),
    );
    canvas.drawCircle(
      basketPos + const Offset(26, 8),
      5.5,
      Paint()..color = const Color(0xFFE63946),
    );
    canvas.drawCircle(
      basketPos + const Offset(36, 10),
      5.0,
      Paint()..color = const Color(0xFFFF9F1C),
    );

    // Aesthetic person sitting on the picnic blanket
    _drawPersonByWindow(
      canvas,
      blanketCenter + const Offset(6, -16),
      0.98,
      sweaterColor: const Color(0xFF457B9D),
      facingLeft: false,
    );

    _drawDogCompanion(
      canvas,
      blanketCenter + const Offset(44, -14),
      1.05,
      const Color(0xFF6C584C),
      sitting: true,
    );
    _drawFloatingMotes(
      canvas,
      Offset.zero & size,
      count: 22,
      color: Colors.white,
    );
  }

  // 20: Home Together — Có nhau là đủ
  void _paintHomeTogether(Canvas canvas, Size size) {
    final fh = _focalHeight(size);
    _drawInteriorRoom(
      canvas,
      size,
      wallTop: const Color(0xFF4A3540),
      wallBottom: const Color(0xFF5E4350),
      floorTop: const Color(0xFF6F4E37),
      floorBottom: const Color(0xFF4A3222),
      baseboardColor: const Color(0xFF8B635C),
      floorYRatio: 0.65,
    );

    _drawWallShelfWithTrailingVines(
      canvas,
      Offset(size.width * 0.16, fh * 0.24),
      size.width * 0.22,
      vinesOnRight: false,
    );
    _drawFramedWallArt(
      canvas,
      Offset(size.width * 0.52, fh * 0.24),
      scale: 0.92,
    );

    final lampX = size.width * 0.84;
    _drawSunOrMoonGlow(
      canvas,
      Offset(lampX, fh * 0.36),
      32,
      const Color(0xFFFFD166),
    );
    canvas.drawLine(
      Offset(lampX, fh * 0.36),
      Offset(lampX, fh * 0.65),
      Paint()
        ..color = const Color(0xFFD4A373)
        ..strokeWidth = 3,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(lampX, fh * 0.34),
          width: 28,
          height: 18,
        ),
        const Radius.circular(5),
      ),
      Paint()..color = const Color(0xFFFFF1E6),
    );
    _drawPottedPlant(
      canvas,
      Offset(size.width * 0.12, fh * 0.65),
      1.15,
      flowerColor: const Color(0xFFFFB5A7),
    );

    final sofaCenter = Offset(size.width * 0.5, fh * 0.61);
    final sofaW = size.width * 0.72;
    final sofaH = fh * 0.19;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: sofaCenter + Offset(0, -sofaH * 0.26),
          width: sofaW * 0.94,
          height: sofaH * 0.72,
        ),
        const Radius.circular(22),
      ),
      Paint()..color = const Color(0xFF9D6B75),
    );

    // Aesthetic couple leaning shoulders on the sofa (3/4 back view)
    _drawPersonByWindow(
      canvas,
      sofaCenter + const Offset(-16, -12),
      0.95,
      sweaterColor: const Color(0xFFE6CCB2),
      facingLeft: false,
    );
    _drawPersonByWindow(
      canvas,
      sofaCenter + const Offset(16, -10),
      0.92,
      sweaterColor: const Color(0xFFE07A5F),
      facingLeft: true,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: sofaCenter + Offset(0, sofaH * 0.18),
          width: sofaW,
          height: sofaH * 0.56,
        ),
        const Radius.circular(20),
      ),
      Paint()..color = const Color(0xFFB5838D),
    );

    final rugCenter = Offset(size.width * 0.5, fh * 0.78);
    _drawCozyWovenRug(
      canvas,
      rugCenter,
      size.width * 0.72,
      48,
      baseColor: const Color(0xFFFFF1E6),
      patternColor: const Color(0xFFB5838D),
    );
    _drawSleepingCat(
      canvas,
      rugCenter + const Offset(0, -4),
      1.05,
      const Color(0xFF5C4033),
    );
    _drawFloatingMotes(canvas, Offset.zero & size, count: 24);
  }

  // 21: Stargazing Rooftop — Đêm trên mái nhà
  void _paintStargazingRooftop(Canvas canvas, Size size) {
    final fh = _focalHeight(size);
    final milkyWay =
        Path()
          ..moveTo(0, fh * 0.42)
          ..quadraticBezierTo(
            size.width * 0.5,
            fh * 0.18,
            size.width,
            fh * 0.06,
          )
          ..lineTo(size.width, fh * 0.24)
          ..quadraticBezierTo(size.width * 0.5, fh * 0.34, 0, fh * 0.56)
          ..close();
    canvas.drawPath(
      milkyWay,
      Paint()..color = const Color(0xFFC7D2FE).withValues(alpha: 0.12),
    );

    _drawTwinklingStars(
      canvas,
      Rect.fromLTWH(0, 0, size.width, fh * 0.68),
      count: 52,
      shootingStar: true,
    );

    _drawRollingHills(
      canvas,
      size,
      baseY: fh * 0.68,
      color: const Color(0xFF17253B),
      amplitude: 16,
    );

    final ridgeY = fh * 0.56;
    final eaveY = fh * 0.76;
    final houseW = size.width * 0.72;
    final centerX = size.width * 0.5;

    canvas.drawRect(
      Rect.fromLTWH(
        centerX - houseW * 0.42,
        eaveY - 8,
        houseW * 0.84,
        size.height - eaveY + 8,
      ),
      Paint()..color = const Color(0xFF1E293B),
    );

    canvas.drawRect(
      Rect.fromLTWH(centerX - houseW * 0.26, ridgeY + 6, 18, 38),
      Paint()..color = const Color(0xFF334155),
    );

    final roof =
        Path()
          ..moveTo(centerX - houseW * 0.5, eaveY)
          ..lineTo(centerX, ridgeY)
          ..lineTo(centerX + houseW * 0.5, eaveY)
          ..close();
    canvas.drawPath(roof, Paint()..color = const Color(0xFF0F172A));

    final winCenter = Offset(centerX, ridgeY + (eaveY - ridgeY) * 0.58);
    _drawSunOrMoonGlow(canvas, winCenter, 16, const Color(0xFFFFD166));
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: winCenter, width: 22, height: 22),
        const Radius.circular(4),
      ),
      Paint()..color = const Color(0xFFFFE082),
    );

    // Aesthetic stargazer sitting on the rooftop ridge
    _drawPersonByWindow(
      canvas,
      Offset(centerX + 12, ridgeY - 6),
      0.92,
      sweaterColor: const Color(0xFFE07A5F),
      facingLeft: false,
    );
  }

  // 22: Sunset Balcony — Ban công lúc chiều buông
  void _paintSunsetBalcony(Canvas canvas, Size size) {
    final fh = _focalHeight(size);
    _drawSunOrMoonGlow(
      canvas,
      Offset(size.width * 0.34, fh * 0.32),
      32,
      const Color(0xFFFFB5A7),
    );
    _drawDriftingClouds(
      canvas,
      Rect.fromLTWH(0, 0, size.width, fh * 0.45),
      count: 3,
      color: const Color(0xB3FFD6E0),
    );

    final railTopY = fh * 0.56;
    final floorTopY = fh * 0.72;
    _drawRollingHills(
      canvas,
      size,
      baseY: fh * 0.44,
      bottomY: floorTopY + 10,
      color: const Color(0xFF6D597A),
      amplitude: 26,
    );
    _drawRollingHills(
      canvas,
      size,
      baseY: fh * 0.53,
      bottomY: floorTopY + 10,
      color: const Color(0xFF4A3E63),
      amplitude: 18,
      phaseShift: 1.5,
    );

    _drawFairyStringLights(canvas, size, y: railTopY);

    canvas.drawRect(
      Rect.fromLTWH(0, floorTopY, size.width, size.height - floorTopY),
      Paint()..color = const Color(0xFF5C4033),
    );
    canvas.drawRect(
      Rect.fromLTWH(0, floorTopY - 6, size.width, 8),
      Paint()..color = const Color(0xFF3E2723),
    );

    final railPaint =
        Paint()
          ..color = const Color(0xFF2B2D42)
          ..strokeWidth = 3.2;
    canvas.drawLine(
      Offset(0, railTopY),
      Offset(size.width, railTopY),
      railPaint,
    );
    for (var x = 14.0; x < size.width; x += 22) {
      canvas.drawLine(Offset(x, railTopY), Offset(x, floorTopY - 4), railPaint);
    }

    final chairCenter = Offset(size.width * 0.25, floorTopY - 12);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: chairCenter + const Offset(-6, -24),
          width: 48,
          height: 44,
        ),
        const Radius.circular(18),
      ),
      Paint()..color = const Color(0xFFD4A373),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: chairCenter, width: 56, height: 18),
        const Radius.circular(9),
      ),
      Paint()..color = const Color(0xFFFAF0CA),
    );

    final tableX = size.width * 0.52;
    canvas.drawLine(
      Offset(tableX, floorTopY - 28),
      Offset(tableX, floorTopY + 6),
      Paint()
        ..color = const Color(0xFF3E2723)
        ..strokeWidth = 4,
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(tableX, floorTopY - 28),
        width: 58,
        height: 12,
      ),
      Paint()..color = const Color(0xFFBC6C25),
    );
    _drawTeacup(
      canvas,
      Offset(tableX, floorTopY - 38),
      0.95,
      const Color(0xFFFFF1E6),
    );

    _drawPottedPlant(
      canvas,
      Offset(size.width * 0.76, floorTopY + 2),
      1.05,
      flowerColor: const Color(0xFFFF8FA3),
    );
    _drawPottedPlant(
      canvas,
      Offset(size.width * 0.88, floorTopY + 6),
      0.88,
      flowerColor: const Color(0xFFFDE68A),
    );
    _drawFloatingMotes(canvas, Offset.zero & size, count: 24);
  }

  // 23: Coffee & Rain — Cà phê ngày mưa
  void _paintCoffeeAndRain(Canvas canvas, Size size) {
    final fh = _focalHeight(size);
    _drawInteriorRoom(
      canvas,
      size,
      wallTop: const Color(0xFF2C1E18),
      wallBottom: const Color(0xFF3D2A22),
      floorTop: const Color(0xFF4A3228),
      floorBottom: const Color(0xFF2B1C16),
      baseboardColor: const Color(0xFF5C4033),
      floorYRatio: 0.70,
    );

    _drawWallShelfWithTrailingVines(
      canvas,
      Offset(size.width * 0.14, fh * 0.24),
      size.width * 0.20,
      vinesOnRight: false,
    );
    _drawFramedWallArt(
      canvas,
      Offset(size.width * 0.88, fh * 0.25),
      scale: 0.72,
      verticalPair: true,
    );

    final winRect = Rect.fromCenter(
      center: Offset(size.width * 0.5, fh * 0.36),
      width: size.width * 0.64,
      height: fh * 0.44,
    );
    _drawWindowWithOutdoorView(
      canvas,
      winRect,
      cols: 2,
      rows: 1,
      frameColor: const Color(0xFF3E2723),
      sillColor: const Color(0xFF4E342E),
      paintOutdoor: () {
        final roofs = [0.22, 0.48, 0.76];
        for (final rx in roofs) {
          final bx = winRect.left + winRect.width * rx;
          final by = winRect.bottom - 38;
          canvas.drawRect(
            Rect.fromCenter(center: Offset(bx, by), width: 64, height: 76),
            Paint()..color = const Color(0xFF1F242D),
          );
        }
        canvas.drawRect(
          Rect.fromLTWH(winRect.left, winRect.bottom - 26, winRect.width, 26),
          Paint()..color = const Color(0xFF161A22),
        );
        _drawSunOrMoonGlow(
          canvas,
          Offset(winRect.left + winRect.width * 0.28, winRect.bottom - 52),
          16,
          const Color(0xFFFFB703),
        );
        _drawSunOrMoonGlow(
          canvas,
          Offset(winRect.left + winRect.width * 0.72, winRect.bottom - 48),
          14,
          const Color(0xFFFB8500),
        );
        _drawRaindrops(canvas, winRect, count: 120);
      },
    );

    for (final lampX in [size.width * 0.36, size.width * 0.64]) {
      canvas.drawLine(
        Offset(lampX, 0),
        Offset(lampX, fh * 0.16),
        Paint()
          ..color = const Color(0xFF1F1410)
          ..strokeWidth = 2.5,
      );
      final shade =
          Path()
            ..moveTo(lampX - 20, fh * 0.20)
            ..lineTo(lampX + 20, fh * 0.20)
            ..lineTo(lampX + 8, fh * 0.15)
            ..lineTo(lampX - 8, fh * 0.15)
            ..close();
      canvas.drawPath(shade, Paint()..color = const Color(0xFF6F4E37));
      _drawSunOrMoonGlow(
        canvas,
        Offset(lampX, fh * 0.21),
        18,
        const Color(0xFFFFD166),
      );
    }

    final tableY = fh * 0.70;
    // Aesthetic cafe patron sitting by the rainy window
    _drawPersonByWindow(
      canvas,
      Offset(size.width * 0.24, tableY - 12),
      1.05,
      sweaterColor: const Color(0xFFD4A373),
      facingLeft: false,
    );

    canvas.drawRRect(
      RRect.fromRectAndCorners(
        Rect.fromLTWH(
          size.width * 0.12,
          tableY,
          size.width * 0.76,
          size.height - tableY,
        ),
        topLeft: const Radius.circular(18),
        topRight: const Radius.circular(18),
      ),
      Paint()..color = const Color(0xFF7F5539),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * 0.10, tableY - 4, size.width * 0.80, 12),
        const Radius.circular(6),
      ),
      Paint()..color = const Color(0xFF9C6644),
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(size.width * 0.42, tableY - 6),
          width: 46,
          height: 10,
        ),
        const Radius.circular(2),
      ),
      Paint()..color = const Color(0xFFFFF8F0),
    );

    _drawTeacup(
      canvas,
      Offset(size.width * 0.64, tableY - 14),
      1.2,
      const Color(0xFFEDE0D4),
    );
    _drawPottedPlant(
      canvas,
      Offset(size.width * 0.80, tableY - 4),
      0.78,
      flowerColor: const Color(0xFFFFB5A7),
    );
  }

  // 24: The Quiet Train — Chuyến tàu bình yên
  void _paintQuietTrain(Canvas canvas, Size size) {
    final fh = _focalHeight(size);
    _drawInteriorRoom(
      canvas,
      size,
      wallTop: const Color(0xFF3D405B),
      wallBottom: const Color(0xFF2F3247),
      floorTop: const Color(0xFF5C4033),
      floorBottom: const Color(0xFF3E2723),
      baseboardColor: const Color(0xFFD4A373),
      floorYRatio: 0.70,
      fairyLights: false,
    );

    // Overhead luggage rack with a vintage suitcase
    final rackY = fh * 0.11;
    canvas.drawLine(
      Offset(size.width * 0.08, rackY),
      Offset(size.width * 0.92, rackY),
      Paint()
        ..color = const Color(0xFFD4A373)
        ..strokeWidth = 3,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(size.width * 0.24, rackY - 11),
          width: 48,
          height: 20,
        ),
        const Radius.circular(4),
      ),
      Paint()..color = const Color(0xFF9C6644),
    );

    final winRect = Rect.fromCenter(
      center: Offset(size.width * 0.5, fh * 0.36),
      width: size.width * 0.68,
      height: fh * 0.40,
    );
    _drawWindowWithOutdoorView(
      canvas,
      winRect,
      cols: 1,
      rows: 1,
      frameColor: const Color(0xFFD4A373),
      sillColor: const Color(0xFFB08968),
      paintOutdoor: () {
        _drawDriftingClouds(canvas, winRect, count: 4);
        _drawRollingHills(
          canvas,
          size,
          baseY: winRect.bottom - 52,
          bottomY: winRect.bottom,
          color: const Color(0xFF74C69D),
          amplitude: 16,
          phaseShift: progress * math.pi * 4,
        );
        _drawRollingHills(
          canvas,
          size,
          baseY: winRect.bottom - 26,
          bottomY: winRect.bottom,
          color: const Color(0xFF40916C),
          amplitude: 10,
          phaseShift: progress * math.pi * 8,
        );
      },
    );
    _drawWindowLightBeams(canvas, winRect, size, alpha: 0.18);

    final seatBottomY = fh * 0.72;
    const seatColor = Color(0xFFE07A5F);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          size.width * 0.06,
          fh * 0.46,
          size.width * 0.22,
          seatBottomY - fh * 0.46,
        ),
        const Radius.circular(14),
      ),
      Paint()..color = seatColor,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          size.width * 0.72,
          fh * 0.46,
          size.width * 0.22,
          seatBottomY - fh * 0.46,
        ),
        const Radius.circular(14),
      ),
      Paint()..color = seatColor,
    );

    // Aesthetic Lo-Fi train passenger with headphones gazing out at the clouds
    _drawPersonByWindow(
      canvas,
      Offset(size.width * 0.66, fh * 0.58),
      1.05,
      sweaterColor: const Color(0xFFF2CC8F),
      facingLeft: true,
      headphones: true,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(size.width * 0.48, fh * 0.62),
          width: size.width * 0.28,
          height: 8,
        ),
        const Radius.circular(4),
      ),
      Paint()..color = const Color(0xFFD4A373),
    );
    _drawTeacup(
      canvas,
      Offset(size.width * 0.44, fh * 0.56),
      0.85,
      const Color(0xFFFFF8F0),
    );
    _drawFloatingMotes(canvas, Offset.zero & size, count: 22);
  }

  // 25: A Place Above the Clouds — Ngôi nhà trên mây
  void _paintAboveClouds(Canvas canvas, Size size) {
    final fh = _focalHeight(size);
    _drawSunOrMoonGlow(
      canvas,
      Offset(size.width * 0.5, fh * 0.28),
      38,
      const Color(0xFFFFE5B4),
    );

    _drawDriftingClouds(
      canvas,
      Rect.fromLTWH(0, fh * 0.40, size.width, fh * 0.32),
      count: 5,
      color: const Color(0xD9FFF1E6),
      scaleMultiplier: 1.25,
    );

    final hillPath =
        Path()
          ..moveTo(size.width * 0.12, fh * 0.74)
          ..quadraticBezierTo(
            size.width * 0.5,
            fh * 0.38,
            size.width * 0.88,
            fh * 0.74,
          )
          ..close();
    canvas.drawPath(hillPath, Paint()..color = const Color(0xFF52796F));

    _drawPineTree(
      canvas,
      Offset(size.width * 0.37, fh * 0.55),
      fh * 0.11,
      const Color(0xFF2D6A4F),
    );
    _drawTinyCabin(canvas, Offset(size.width * 0.52, fh * 0.52), 1.08);

    _drawRollingHills(
      canvas,
      size,
      baseY: fh * 0.66,
      color: const Color(0xF2FFFFFF),
      amplitude: 16,
      frequency: 2.2,
      phaseShift: _tau,
    );
    for (var i = 0; i < 6; i++) {
      final cx = size.width * (i * 0.2) + math.sin(_tau + i) * 18;
      final cy = fh * 0.68 + (i % 2) * (size.height - fh * 0.68) * 0.35;
      _drawFluffyCloud(
        canvas,
        Offset(cx, cy),
        1.35,
        Colors.white.withValues(alpha: 0.95),
      );
    }
    _drawFloatingMotes(canvas, Offset.zero & size, count: 26);
  }

  // 26: Christmas in a Gryffindor Private Room — Giáng sinh trong phòng riêng Gryffindor
  void _paintGryffindorChristmas(Canvas canvas, Size size) {
    final fh = _focalHeight(size);
    _drawInteriorRoom(
      canvas,
      size,
      wallTop: const Color(0xFF42161B),
      wallBottom: const Color(0xFF5A1F24),
      floorTop: const Color(0xFF4A2C1D),
      floorBottom: const Color(0xFF2B1810),
      baseboardColor: const Color(0xFF6E473B),
      floorYRatio: 0.65,
      fairyLights: true,
    );

    // Subtle stone tower blocks along upper wall
    final stonePaint =
        Paint()
          ..color = const Color(0x22000000)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.0;
    for (var row = 0; row < 6; row++) {
      final y = fh * 0.08 + row * (fh * 0.085);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), stonePaint);
      for (var col = 0; col < 7; col++) {
        final x = (col + (row.isEven ? 0.0 : 0.5)) * (size.width / 6.0);
        canvas.drawLine(Offset(x, y), Offset(x, y + fh * 0.085), stonePaint);
      }
    }

    // Gothic arched window on the left looking out at a snowy winter night
    final winRect = Rect.fromLTWH(
      size.width * 0.07,
      fh * 0.14,
      size.width * 0.30,
      fh * 0.40,
    );
    _drawWindowWithOutdoorView(
      canvas,
      winRect,
      arched: true,
      frameColor: const Color(0xFF3E2723),
      sillColor: const Color(0xFF5D4037),
      paintOutdoor: () {
        canvas.drawRect(winRect, Paint()..color = const Color(0xFF0F1E36));
        _drawTwinklingStars(canvas, winRect, count: 26);
        _drawSunOrMoonGlow(
          canvas,
          Offset(winRect.right - 28, winRect.top + 36),
          14,
          const Color(0xFFFFF3B0),
        );
        _drawRollingHills(
          canvas,
          size,
          baseY: winRect.bottom - 32,
          bottomY: winRect.bottom,
          color: const Color(0xFFD8E8F2),
          amplitude: 10,
        );
        _drawPineTree(
          canvas,
          Offset(winRect.left + winRect.width * 0.34, winRect.bottom - 8),
          winRect.height * 0.48,
          const Color(0xFF1F3B4D),
          snowCapped: true,
        );
        _drawPineTree(
          canvas,
          Offset(winRect.left + winRect.width * 0.72, winRect.bottom - 4),
          winRect.height * 0.40,
          const Color(0xFF162C3B),
          snowCapped: true,
        );
        _drawSnowflakes(canvas, winRect, count: 44);
      },
    );

    final floorY = fh * 0.65;

    // Decorated Christmas tree in center-left with twinkling lights & star topper
    final treeBase = Offset(size.width * 0.43, floorY + 6);
    final treeH = fh * 0.42;
    _drawPineTree(canvas, treeBase, treeH, const Color(0xFF1B4332));
    // Star topper
    final starCenter = Offset(treeBase.dx, treeBase.dy - treeH - 6);
    final starPulse = 0.85 + 0.15 * math.sin(_tau * 3);
    _drawSunOrMoonGlow(
      canvas,
      starCenter,
      14 * starPulse,
      const Color(0xFFFFD166),
    );
    // Christmas ornaments (scarlet & gold baubles + twinkling lights)
    final ornamentOffsets = <Offset>[
      Offset(-12, -treeH * 0.72),
      Offset(10, -treeH * 0.65),
      Offset(-20, -treeH * 0.52),
      Offset(4, -treeH * 0.48),
      Offset(22, -treeH * 0.44),
      Offset(-26, -treeH * 0.30),
      Offset(-4, -treeH * 0.26),
      Offset(18, -treeH * 0.24),
      Offset(28, -treeH * 0.16),
      Offset(-16, -treeH * 0.14),
    ];
    for (var i = 0; i < ornamentOffsets.length; i++) {
      final pos = treeBase + ornamentOffsets[i];
      final isGold = i.isEven;
      final twinkle = 0.65 + 0.35 * math.sin(_tau * 3 + i * 1.3);
      canvas.drawCircle(
        pos,
        isGold ? 4.2 : 4.8,
        Paint()
          ..color =
              isGold
                  ? const Color(0xFFFFD166).withValues(alpha: twinkle)
                  : const Color(0xFFC1121F),
      );
      if (isGold) {
        canvas.drawCircle(
          pos,
          9 * twinkle,
          Paint()..color = const Color(0x44FFD166),
        );
      }
    }
    // Wrapped Christmas gifts under tree
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: treeBase + const Offset(-18, 6),
          width: 24,
          height: 18,
        ),
        const Radius.circular(3),
      ),
      Paint()..color = const Color(0xFF9B2226),
    );
    canvas.drawLine(
      treeBase + const Offset(-18, -3),
      treeBase + const Offset(-18, 15),
      Paint()
        ..color = const Color(0xFFFFD166)
        ..strokeWidth = 3,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: treeBase + const Offset(14, 8),
          width: 20,
          height: 14,
        ),
        const Radius.circular(3),
      ),
      Paint()..color = const Color(0xFFD9A441),
    );

    // Grand Gryffindor Stone Hearth on the right
    final fpCenterX = size.width * 0.77;
    final fpW = size.width * 0.34;
    final fpH = fh * 0.34;
    // Chimney breast
    canvas.drawRect(
      Rect.fromCenter(
        center: Offset(fpCenterX, (floorY - fpH) * 0.5),
        width: fpW * 0.74,
        height: floorY - fpH,
      ),
      Paint()..color = const Color(0xFF4A2E2B),
    );
    // Gryffindor house banner above mantel (scarlet & gold crest pennant)
    final bannerTop = fh * 0.08;
    final bannerW = fpW * 0.42;
    final bannerH = fh * 0.16;
    final bannerPath =
        Path()
          ..moveTo(fpCenterX - bannerW * 0.5, bannerTop)
          ..lineTo(fpCenterX + bannerW * 0.5, bannerTop)
          ..lineTo(fpCenterX + bannerW * 0.5, bannerTop + bannerH * 0.75)
          ..lineTo(fpCenterX, bannerTop + bannerH)
          ..lineTo(fpCenterX - bannerW * 0.5, bannerTop + bannerH * 0.75)
          ..close();
    canvas.drawPath(bannerPath, Paint()..color = const Color(0xFF9B1B1B));
    canvas.drawPath(
      bannerPath,
      Paint()
        ..color = const Color(0xFFD9A441)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5,
    );
    // Golden lion emblem silhouette on banner
    canvas.drawCircle(
      Offset(fpCenterX, bannerTop + bannerH * 0.42),
      bannerW * 0.22,
      Paint()..color = const Color(0xFFFFD166),
    );

    final fpRect = Rect.fromLTWH(fpCenterX - fpW * 0.5, floorY - fpH, fpW, fpH);
    canvas.drawRRect(
      RRect.fromRectAndRadius(fpRect, const Radius.circular(8)),
      Paint()..color = const Color(0xFF5D3A33),
    );
    // Heavy carved wood mantelpiece
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(fpCenterX, fpRect.top),
          width: fpW + 18,
          height: 14,
        ),
        const Radius.circular(4),
      ),
      Paint()..color = const Color(0xFF3E221A),
    );
    // Glowing candles on the mantelpiece
    for (final dx in [-fpW * 0.32, fpW * 0.32]) {
      final candlePos = Offset(fpCenterX + dx, fpRect.top - 14);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(center: candlePos, width: 7, height: 16),
          const Radius.circular(2),
        ),
        Paint()..color = const Color(0xFFFFF8F0),
      );
      canvas.drawCircle(
        candlePos + const Offset(0, -11),
        4,
        Paint()..color = const Color(0xFFFFB703),
      );
    }

    // Firebox & crackling flames
    final fireboxRect = Rect.fromCenter(
      center: Offset(fpCenterX, floorY - fpH * 0.38),
      width: fpW * 0.64,
      height: fpH * 0.66,
    );
    canvas.drawRRect(
      RRect.fromRectAndCorners(
        fireboxRect,
        topLeft: Radius.circular(fireboxRect.width * 0.45),
        topRight: Radius.circular(fireboxRect.width * 0.45),
      ),
      Paint()..color = const Color(0xFF1A0E0C),
    );
    final flicker = 1.0 + 0.15 * math.sin(_tau * 4);
    _drawSunOrMoonGlow(
      canvas,
      Offset(fpCenterX, floorY - 18),
      44 * flicker,
      const Color(0xFFFF9F1C),
    );
    final outerFlame =
        Path()
          ..moveTo(fpCenterX - 22, floorY - 10)
          ..quadraticBezierTo(
            fpCenterX - 14,
            floorY - 48 * flicker,
            fpCenterX,
            floorY - 58 * flicker,
          )
          ..quadraticBezierTo(
            fpCenterX + 14,
            floorY - 44 * flicker,
            fpCenterX + 22,
            floorY - 10,
          )
          ..close();
    canvas.drawPath(outerFlame, Paint()..color = const Color(0xFFFF7B00));
    final innerFlame =
        Path()
          ..moveTo(fpCenterX - 11, floorY - 10)
          ..quadraticBezierTo(
            fpCenterX - 5,
            floorY - 34 * flicker,
            fpCenterX + 1,
            floorY - 40 * flicker,
          )
          ..quadraticBezierTo(
            fpCenterX + 8,
            floorY - 28 * flicker,
            fpCenterX + 11,
            floorY - 10,
          )
          ..close();
    canvas.drawPath(innerFlame, Paint()..color = const Color(0xFFFFD166));

    // Crimson & gold woven Gryffindor rug on floor
    _drawCozyWovenRug(
      canvas,
      Offset(size.width * 0.50, fh * 0.78),
      size.width * 0.74,
      64,
      baseColor: const Color(0xFF781D22),
      patternColor: const Color(0xFFD9A441),
    );

    // Plush crimson velvet wingback armchair with wool blanket
    final chairCenter = Offset(size.width * 0.26, fh * 0.71);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: chairCenter + const Offset(0, -24),
          width: 96,
          height: 76,
        ),
        const Radius.circular(24),
      ),
      Paint()..color = const Color(0xFF8B1E24),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: chairCenter, width: 108, height: 48),
        const Radius.circular(18),
      ),
      Paint()..color = const Color(0xFFA4242B),
    );
    // Warm wool blanket in scarlet & gold stripes draped over chair
    final blanketPath =
        Path()
          ..moveTo(chairCenter.dx + 6, chairCenter.dy - 54)
          ..lineTo(chairCenter.dx + 42, chairCenter.dy - 46)
          ..quadraticBezierTo(
            chairCenter.dx + 48,
            chairCenter.dy - 4,
            chairCenter.dx + 34,
            chairCenter.dy + 26,
          )
          ..lineTo(chairCenter.dx + 10, chairCenter.dy + 22)
          ..close();
    canvas.drawPath(blanketPath, Paint()..color = const Color(0xFFD9A441));

    // Stacks of ancient spellbooks & steaming mug on floor/table
    final bookBase = Offset(size.width * 0.52, fh * 0.77);
    final bookColors = [
      const Color(0xFF6B2737),
      const Color(0xFF3D5A45),
      const Color(0xFF8B5E3C),
      const Color(0xFF9B2226),
    ];
    for (var b = 0; b < 4; b++) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: bookBase + Offset((b.isEven ? 2.0 : -2.0), -b * 9.0),
            width: 44 - b * 3.0,
            height: 8.5,
          ),
          const Radius.circular(2.5),
        ),
        Paint()..color = bookColors[b],
      );
    }
    _drawTeacup(
      canvas,
      Offset(size.width * 0.63, fh * 0.76),
      1.0,
      const Color(0xFFFFF8F0),
    );
    _drawFloatingMotes(canvas, Offset.zero & size, count: 28);
  }

  // 27: Autumn Thanksgiving — Chiều thu biết ơn
  void _paintAutumnThanksgiving(Canvas canvas, Size size) {
    final fh = _focalHeight(size);
    _drawInteriorRoom(
      canvas,
      size,
      wallTop: const Color(0xFFF4E3CF),
      wallBottom: const Color(0xFFE6CCB2),
      floorTop: const Color(0xFF7F5539),
      floorBottom: const Color(0xFF583924),
      baseboardColor: const Color(0xFFB08968),
      floorYRatio: 0.64,
      fairyLights: true,
    );

    _drawWallShelfWithTrailingVines(
      canvas,
      Offset(size.width * 0.15, fh * 0.24),
      size.width * 0.22,
      vinesOnRight: false,
    );
    _drawWallShelfWithTrailingVines(
      canvas,
      Offset(size.width * 0.85, fh * 0.24),
      size.width * 0.22,
      vinesOnRight: true,
    );

    // Wide wooden window looking out at a red & orange autumn forest
    final winRect = Rect.fromCenter(
      center: Offset(size.width * 0.50, fh * 0.30),
      width: size.width * 0.56,
      height: fh * 0.36,
    );
    _drawWindowWithOutdoorView(
      canvas,
      winRect,
      frameColor: const Color(0xFF7F4F24),
      sillColor: const Color(0xFF9C6644),
      paintOutdoor: () {
        // Golden autumn afternoon sky
        canvas.drawRect(
          winRect,
          Paint()
            ..shader = const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFF9C784), Color(0xFFFCAF58), Color(0xFFE87A48)],
            ).createShader(winRect),
        );
        _drawSunOrMoonGlow(
          canvas,
          Offset(winRect.left + winRect.width * 0.72, winRect.top + 38),
          24,
          const Color(0xFFFFF3B0),
        );
        // Layered red-orange-amber autumn hills & maple foliage
        _drawRollingHills(
          canvas,
          size,
          baseY: winRect.bottom - 52,
          bottomY: winRect.bottom,
          color: const Color(0xFFD95D39),
          amplitude: 14,
        );
        _drawRollingHills(
          canvas,
          size,
          baseY: winRect.bottom - 28,
          bottomY: winRect.bottom,
          color: const Color(0xFF9B2226),
          amplitude: 10,
          phaseShift: 1.4,
        );
        // Autumn trees with crimson and amber canopies
        final treeColors = [
          const Color(0xFFBB3E03),
          const Color(0xFFE07A5F),
          const Color(0xFFEE9B00),
          const Color(0xFF9B2226),
        ];
        for (var i = 0; i < 4; i++) {
          final tx = winRect.left + winRect.width * (0.18 + i * 0.22);
          final ty = winRect.bottom - 18 - (i.isEven ? 8.0 : 2.0);
          canvas.drawLine(
            Offset(tx, ty + 20),
            Offset(tx, ty - 8),
            Paint()
              ..color = const Color(0xFF4A2C1D)
              ..strokeWidth = 4,
          );
          canvas.drawCircle(
            Offset(tx, ty - 14),
            20,
            Paint()..color = treeColors[i],
          );
        }
        // Drifting autumn leaves outside the window
        for (var i = 0; i < 14; i++) {
          final lx =
              winRect.left +
              ((i * 39 + progress * 90) % winRect.width) +
              math.sin(_tau + i) * 6;
          final ly = winRect.top + ((i * 29 + progress * 110) % winRect.height);
          canvas.drawOval(
            Rect.fromCenter(center: Offset(lx, ly), width: 7, height: 4),
            Paint()
              ..color =
                  i.isEven ? const Color(0xFFD62828) : const Color(0xFFF77F00),
          );
        }
      },
    );
    _drawWindowLightBeams(canvas, winRect, size, alpha: 0.25);

    // Warm wooden dining table in foreground
    final tableTopY = fh * 0.62;
    canvas.drawRect(
      Rect.fromLTWH(0, tableTopY, size.width, size.height - tableTopY),
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: const [Color(0xFF9C6644), Color(0xFF6F4518)],
        ).createShader(
          Rect.fromLTWH(0, tableTopY, size.width, size.height - tableTopY),
        ),
    );
    // Warm cream table runner
    final runnerPath =
        Path()
          ..moveTo(size.width * 0.14, tableTopY + 12)
          ..lineTo(size.width * 0.86, tableTopY + 12)
          ..lineTo(size.width * 0.94, tableTopY + 64)
          ..lineTo(size.width * 0.06, tableTopY + 64)
          ..close();
    canvas.drawPath(runnerPath, Paint()..color = const Color(0xFFFAF0CA));

    // Freshly baked Thanksgiving lattice pie in ceramic dish (center)
    final pieCenter = Offset(size.width * 0.48, tableTopY + 34);
    canvas.drawOval(
      Rect.fromCenter(
        center: pieCenter + const Offset(0, 6),
        width: 112,
        height: 36,
      ),
      Paint()..color = const Color(0xFFFFF8F0),
    );
    canvas.drawOval(
      Rect.fromCenter(center: pieCenter, width: 98, height: 28),
      Paint()..color = const Color(0xFFD97724),
    );
    final latticePaint =
        Paint()
          ..color = const Color(0xFFF3C68F)
          ..strokeWidth = 2.4
          ..strokeCap = StrokeCap.round;
    for (var s = -2; s <= 2; s++) {
      canvas.drawLine(
        pieCenter + Offset(s * 14.0 - 10, -8),
        pieCenter + Offset(s * 14.0 + 10, 8),
        latticePaint,
      );
      canvas.drawLine(
        pieCenter + Offset(s * 14.0 + 10, -8),
        pieCenter + Offset(s * 14.0 - 10, 8),
        latticePaint,
      );
    }
    _drawSteamWisps(canvas, pieCenter + const Offset(0, -16), wisps: 4);

    // Hot teapot & teacup on left of table
    final potCenter = Offset(size.width * 0.22, tableTopY + 26);
    canvas.drawOval(
      Rect.fromCenter(center: potCenter, width: 44, height: 34),
      Paint()..color = const Color(0xFFD4A373),
    );
    canvas.drawCircle(
      potCenter + const Offset(0, -18),
      5,
      Paint()..color = const Color(0xFFBC6C25),
    );
    _drawTeacup(
      canvas,
      Offset(size.width * 0.32, tableTopY + 42),
      0.95,
      const Color(0xFFFFF8F0),
    );

    // Glowing pillar candles & mini pumpkin on right of table
    final flicker = 0.9 + 0.1 * math.sin(_tau * 4);
    for (var c = 0; c < 2; c++) {
      final candleCenter = Offset(
        size.width * (0.74 + c * 0.08),
        tableTopY + 20 + c * 8.0,
      );
      final candleH = 34.0 - c * 8.0;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(center: candleCenter, width: 16, height: candleH),
          const Radius.circular(4),
        ),
        Paint()..color = const Color(0xFFFFF3E0),
      );
      final flamePos = candleCenter + Offset(0, -candleH * 0.5 - 6);
      _drawSunOrMoonGlow(
        canvas,
        flamePos,
        18 * flicker,
        const Color(0xFFFFB703),
      );
      canvas.drawOval(
        Rect.fromCenter(center: flamePos, width: 6, height: 11 * flicker),
        Paint()..color = const Color(0xFFFFD166),
      );
    }
    _drawFloatingMotes(canvas, Offset.zero & size, count: 24);
  }

  // 28: A Peaceful Tết Morning — Sáng Tết bình yên
  void _paintTetMorning(Canvas canvas, Size size) {
    final fh = _focalHeight(size);
    _drawInteriorRoom(
      canvas,
      size,
      wallTop: const Color(0xFFF9EFE2),
      wallBottom: const Color(0xFFEDD9C0),
      floorTop: const Color(0xFF9C523B),
      floorBottom: const Color(0xFF6E3524),
      baseboardColor: const Color(0xFF5C3317),
      floorYRatio: 0.64,
      fairyLights: false,
    );

    // Traditional Vietnamese wooden doorway/window opening to a sunny spring courtyard
    final winRect = Rect.fromCenter(
      center: Offset(size.width * 0.48, fh * 0.31),
      width: size.width * 0.60,
      height: fh * 0.40,
    );
    _drawWindowWithOutdoorView(
      canvas,
      winRect,
      frameColor: const Color(0xFF5C2E14),
      sillColor: const Color(0xFF7A3E1D),
      paintOutdoor: () {
        // Warm golden spring morning sky
        canvas.drawRect(
          winRect,
          Paint()
            ..shader = const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFFFF3D1), Color(0xFFFFE5B4), Color(0xFFFAD2A7)],
            ).createShader(winRect),
        );
        _drawSunOrMoonGlow(
          canvas,
          Offset(winRect.left + winRect.width * 0.28, winRect.top + 38),
          28,
          const Color(0xFFFFD166),
        );
        // Peaceful courtyard wall & lush spring garden trees
        canvas.drawRect(
          Rect.fromLTWH(winRect.left, winRect.bottom - 48, winRect.width, 48),
          Paint()..color = const Color(0xFFE6CCB2),
        );
        _drawRollingHills(
          canvas,
          size,
          baseY: winRect.bottom - 50,
          bottomY: winRect.bottom - 22,
          color: const Color(0xFF74C69D),
          amplitude: 8,
        );
        // Courtyard terracotta tiles
        canvas.drawRect(
          Rect.fromLTWH(winRect.left, winRect.bottom - 24, winRect.width, 24),
          Paint()..color = const Color(0xFFC86D51),
        );
      },
    );
    // Warm golden spring sunlight rays streaming into the home
    _drawWindowLightBeams(canvas, winRect, size, alpha: 0.28);

    // Traditional wooden tea table (bàn trà) in the foreground
    final tableTopY = fh * 0.63;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          size.width * 0.06,
          tableTopY,
          size.width * 0.88,
          size.height - tableTopY,
        ),
        const Radius.circular(14),
      ),
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: const [Color(0xFF6F381C), Color(0xFF47210E)],
        ).createShader(
          Rect.fromLTWH(0, tableTopY, size.width, size.height - tableTopY),
        ),
    );

    // Blue-and-white ceramic vase with blossoming pink Tết Peach Branch (Cành Đào)
    final vaseCenter = Offset(size.width * 0.72, tableTopY + 12);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: vaseCenter, width: 46, height: 68),
        const Radius.circular(18),
      ),
      Paint()..color = const Color(0xFFF8F9FA),
    );
    // Blue ceramic floral motif on vase
    canvas.drawCircle(vaseCenter, 11, Paint()..color = const Color(0xFF3A6EA5));

    final sway = math.sin(_tau) * 3.0;
    final branchBase = vaseCenter + const Offset(0, -32);
    final branchPaint =
        Paint()
          ..color = const Color(0xFF4A2511)
          ..strokeWidth = 3.5
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round;

    final mainBranch =
        Path()
          ..moveTo(branchBase.dx, branchBase.dy)
          ..quadraticBezierTo(
            branchBase.dx - 18,
            branchBase.dy - 65,
            branchBase.dx - 44 + sway,
            branchBase.dy - 125,
          );
    final sideBranchRight =
        Path()
          ..moveTo(branchBase.dx - 10, branchBase.dy - 40)
          ..quadraticBezierTo(
            branchBase.dx + 18,
            branchBase.dy - 78,
            branchBase.dx + 32 + sway,
            branchBase.dy - 108,
          );
    final sideBranchLeft =
        Path()
          ..moveTo(branchBase.dx - 20, branchBase.dy - 68)
          ..quadraticBezierTo(
            branchBase.dx - 55,
            branchBase.dy - 88,
            branchBase.dx - 78 + sway,
            branchBase.dy - 102,
          );
    canvas.drawPath(mainBranch, branchPaint);
    canvas.drawPath(sideBranchRight, branchPaint);
    canvas.drawPath(sideBranchLeft, branchPaint);

    // Pink peach blossoms (Hoa Đào) along the branches
    final blossomOffsets = <Offset>[
      Offset(-12, -48),
      Offset(-26, -74),
      Offset(-38 + sway, -104),
      Offset(-44 + sway, -124),
      Offset(8, -64),
      Offset(22 + sway, -88),
      Offset(32 + sway, -108),
      Offset(-48, -82),
      Offset(-66 + sway, -96),
      Offset(-78 + sway, -102),
      Offset(-6, -92),
      Offset(12 + sway, -102),
    ];
    for (var i = 0; i < blossomOffsets.length; i++) {
      final bPos = branchBase + blossomOffsets[i];
      canvas.drawCircle(
        bPos,
        7.5,
        Paint()
          ..color =
              i.isEven ? const Color(0xFFFF8FA3) : const Color(0xFFFFB3C1),
      );
      canvas.drawCircle(bPos, 2.8, Paint()..color = const Color(0xFFFFD166));
    }

    // Red & gold lucky envelopes (Bao lì xì) hanging gently from the peach branch
    for (final envOffset in [Offset(-54 + sway, -76), Offset(18 + sway, -68)]) {
      final envPos = branchBase + envOffset;
      canvas.drawLine(
        envPos + const Offset(0, -10),
        envPos,
        Paint()
          ..color = const Color(0xFFFFD166)
          ..strokeWidth = 1.2,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: envPos + const Offset(0, 7),
            width: 11,
            height: 16,
          ),
          const Radius.circular(2),
        ),
        Paint()..color = const Color(0xFFD62828),
      );
      canvas.drawCircle(
        envPos + const Offset(0, 7),
        2.5,
        Paint()..color = const Color(0xFFFFD166),
      );
    }

    // Porcelain teapot & teacups on a bamboo tray (left/center of tea table)
    final teaTrayCenter = Offset(size.width * 0.34, tableTopY + 34);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: teaTrayCenter, width: 128, height: 24),
        const Radius.circular(8),
      ),
      Paint()..color = const Color(0xFFD4A373),
    );
    // Teapot
    canvas.drawOval(
      Rect.fromCenter(
        center: teaTrayCenter + const Offset(-22, -10),
        width: 38,
        height: 28,
      ),
      Paint()..color = const Color(0xFFFFF8F0),
    );
    _drawSteamWisps(canvas, teaTrayCenter + const Offset(-22, -26), wisps: 3);
    // Two small porcelain teacups
    _drawTeacup(
      canvas,
      teaTrayCenter + const Offset(16, -8),
      0.78,
      const Color(0xFFFFF8F0),
    );
    _drawTeacup(
      canvas,
      teaTrayCenter + const Offset(42, -6),
      0.78,
      const Color(0xFFFFF8F0),
    );

    // Drifting pink peach petals in the gentle spring morning air
    for (var i = 0; i < 12; i++) {
      final px =
          (size.width * ((i * 0.11 + progress * 0.25) % 1.0)) +
          math.sin(_tau + i) * 10;
      final py = fh * ((i * 0.13 + progress * 0.35) % 0.78);
      canvas.drawOval(
        Rect.fromCenter(center: Offset(px, py), width: 7, height: 4.5),
        Paint()..color = const Color(0xCCFF8FA3),
      );
    }
    _drawFloatingMotes(canvas, Offset.zero & size, count: 24);
  }

  @override
  bool shouldRepaint(covariant _ComfortScenePainter oldDelegate) {
    return oldDelegate.scene.id != scene.id ||
        oldDelegate.progress != progress ||
        oldDelegate.showVignette != showVignette;
  }
}
