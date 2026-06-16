import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'email_login_screen.dart';

class SplashScreenNew extends StatefulWidget {
  const SplashScreenNew({super.key});

  @override
  State<SplashScreenNew> createState() => _SplashScreenNewState();
}

class _SplashScreenNewState extends State<SplashScreenNew>
    with TickerProviderStateMixin {
  late AnimationController _vanController;
  late AnimationController _fadeController;
  late Animation<double> _vanPosition;
  late Animation<double> _titleFade;
  late Animation<double> _subtitleFade;

  @override
  void initState() {
    super.initState();

    _vanController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3800),
    );

    _vanPosition = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: -0.55, end: 0.12)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 35,
      ),
      TweenSequenceItem(
        tween: ConstantTween(0.12),
        weight: 30,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 0.12, end: 1.1)
            .chain(CurveTween(curve: Curves.easeIn)),
        weight: 35,
      ),
    ]).animate(_vanController);

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _titleFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeIn),
    );
    _subtitleFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _fadeController,
        curve: const Interval(0.3, 1.0, curve: Curves.easeIn),
      ),
    );

    _vanController.forward();

    Future.delayed(const Duration(milliseconds: 1330), () {
      if (mounted) _fadeController.forward();
    });

    _vanController.addStatusListener((status) {
      if (status == AnimationStatus.completed && mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => const EmailLoginScreen(),
            transitionsBuilder: (_, animation, __, child) =>
                FadeTransition(opacity: animation, child: child),
            transitionDuration: const Duration(milliseconds: 500),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _vanController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF0F2FF), Color(0xFFE0E4FF), Color(0xFFD0D6FF)],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              bottom: size.height * 0.25,
              left: 0,
              right: 0,
              child: const _CitySkyline(),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: SizedBox(
                height: size.height * 0.28,
                child: CustomPaint(painter: _HillPainter()),
              ),
            ),
            Positioned(
              top: size.height * 0.08,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  FadeTransition(
                    opacity: _titleFade,
                    child: const Text(
                      'HoldMate',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 42,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF4A42CC),
                        letterSpacing: 0.5,
                        shadows: [
                          Shadow(
                            color: Color(0xFF6C63FF),
                            blurRadius: 20,
                            offset: Offset(0, 0),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  FadeTransition(
                    opacity: _subtitleFade,
                    child: const Text(
                      'Lock smart. Travel light.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF6C63FF),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            AnimatedBuilder(
              animation: _vanController,
              builder: (context, child) {
                return Positioned(
                  bottom: size.height * 0.16,
                  left: size.width * _vanPosition.value,
                  child: child!,
                );
              },
              child: const _VanWidget(width: 240),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── PRETTY VAN WIDGET ───────────────────────────────────────────
class _VanWidget extends StatelessWidget {
  final double width;
  const _VanWidget({required this.width});

  @override
  Widget build(BuildContext context) {
    final h = width * 0.50;
    return SizedBox(
      width: width,
      height: h,
      child: CustomPaint(painter: _PrettyVanPainter()),
    );
  }
}

class _PrettyVanPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // ── Colours ──
    final bodyPaint     = Paint()..color = Colors.white;
    final shadowPaint   = Paint()..color = Colors.black.withOpacity(0.12);
    final darkPurple    = Paint()..color = const Color(0xFF4A42CC);
    final midPurple     = Paint()..color = const Color(0xFF6C63FF);
    final lightPurple   = Paint()..color = const Color(0xFF8B84FF);
    final veryLightPurple = Paint()..color = const Color(0xFFA8A0FF);
    final windowGlow    = Paint()..color = const Color(0xFFB0A8FF);
    final glareWhite    = Paint()..color = Colors.white.withOpacity(0.5);
    final glareWhite30  = Paint()..color = Colors.white.withOpacity(0.3);
    final highlight     = Paint()..color = Colors.white.withOpacity(0.3);
    final tyreBlack     = Paint()..color = const Color(0xFF1A1A2E);
    final rimSilver     = Paint()..color = const Color(0xFF9A9ABE);
    final hubWhite      = Paint()..color = const Color(0xFFE8E8F0);
    final headlightGlow = Paint()..color = const Color(0xFFFEF9C3);
    final taillightRed  = Paint()..color = const Color(0xFFFF4758);
    final lugPaint      = Paint()..color = const Color(0xFF6C63FF);
    final outlinePaint  = Paint()
      ..color = const Color(0xFF3A32AA)
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.006;

    // ── Proportions ──
    const double bodyTop    = 0.06;
    const double bodyBot    = 0.72;
    const double bodyLeft   = 0.02;
    const double bodyRight  = 0.97;
    const double frontEdge  = 0.22;
    const double wheelY     = 0.84;
    const double frontWheelX = 0.20;
    const double rearWheelX  = 0.78;
    const double wheelR      = 0.10;

    // ── Shadow ──
    canvas.drawOval(
      Rect.fromLTWH(w * 0.08, h * 0.90, w * 0.84, h * 0.08),
      shadowPaint,
    );

    // ── Body ──
    final bodyRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * bodyLeft, h * bodyTop, w * (bodyRight - bodyLeft), h * (bodyBot - bodyTop)),
      const Radius.circular(8),
    );
    canvas.drawRRect(bodyRect, bodyPaint);
    canvas.drawRRect(bodyRect, outlinePaint);
    
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * bodyLeft + 2, h * bodyTop + 2, w * (bodyRight - bodyLeft) - 4, h * 0.04),
        const Radius.circular(6),
      ),
      highlight,
    );

    // ── Roof stripe ──
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * bodyLeft + 4, h * bodyTop + 2, w * (bodyRight - bodyLeft) - 8, h * 0.06),
        const Radius.circular(4),
      ),
      midPurple,
    );

    // ── Front face ──
    final frontRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * bodyLeft, h * bodyTop, w * (frontEdge - bodyLeft), h * (bodyBot - bodyTop)),
      const Radius.circular(8),
    );
    canvas.drawRRect(frontRect, Paint()..color = const Color(0xFFF5F0FF));
    canvas.drawLine(
      Offset(w * frontEdge, h * bodyTop),
      Offset(w * frontEdge, h * bodyBot),
      outlinePaint,
    );

    // ── Windshield ──
    final wsFront = w * (bodyLeft + 0.025);
    final wsRight = w * (frontEdge - 0.015);
    final wsTop   = h * (bodyTop + 0.10);
    final wsBot   = h * (bodyBot - 0.14);
    final wsRect  = RRect.fromRectAndRadius(
      Rect.fromLTRB(wsFront, wsTop, wsRight, wsBot),
      const Radius.circular(6),
    );
    canvas.drawRRect(wsRect, windowGlow);
    
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTRB(wsFront + 3, wsTop + 3, wsRight - 3, wsBot - 3),
        const Radius.circular(4),
      ),
      Paint()..color = const Color(0xFFC8C0FF),
    );
    
    final glarePath = Path()
      ..moveTo(wsFront + 6, wsTop + 6)
      ..lineTo(wsFront + (wsRight - wsFront) * 0.50, wsTop + 6)
      ..lineTo(wsFront + (wsRight - wsFront) * 0.25, wsBot - 6)
      ..lineTo(wsFront + 6, wsBot - 6)
      ..close();
    canvas.drawPath(glarePath, glareWhite);
    
    final glarePath2 = Path()
      ..moveTo(wsFront + (wsRight - wsFront) * 0.55, wsTop + 12)
      ..lineTo(wsFront + (wsRight - wsFront) * 0.75, wsTop + 12)
      ..lineTo(wsFront + (wsRight - wsFront) * 0.50, wsBot - 12)
      ..lineTo(wsFront + (wsRight - wsFront) * 0.35, wsBot - 12)
      ..close();
    canvas.drawPath(glarePath2, glareWhite30);

    // ── Side windows ──
    final winTop = h * (bodyTop + 0.10);
    final winBot = h * (bodyTop + 0.38);
    final winH   = winBot - winTop;
    final sideStart = w * (frontEdge + 0.025);
    final sideEnd   = w * (bodyRight - 0.035);
    final totalSideW = sideEnd - sideStart;
    final winW = totalSideW / 3.0 - w * 0.02;
    
    for (int i = 0; i < 3; i++) {
      final winLeft = sideStart + i * (winW + w * 0.02);
      final winRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(winLeft, winTop, winW, winH),
        const Radius.circular(6),
      );
      canvas.drawRRect(winRect, windowGlow);
      
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(winLeft + 3, winTop + 3, winW - 6, winH - 6),
          const Radius.circular(4),
        ),
        Paint()..color = const Color(0xFFC8C0FF),
      );
      
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(winLeft + 5, winTop + 5, winW * 0.20, winH - 10),
          const Radius.circular(2),
        ),
        glareWhite,
      );
    }

    // ── Door line ──
    final doorX = w * (frontEdge + (bodyRight - frontEdge) * 0.52);
    canvas.drawLine(
      Offset(doorX, h * (bodyTop + 0.04)),
      Offset(doorX, h * (bodyBot - 0.02)),
      outlinePaint,
    );
    
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(doorX + w * 0.015, h * (bodyTop + 0.44), w * 0.05, h * 0.035),
        const Radius.circular(3),
      ),
      midPurple,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(doorX + w * 0.018, h * (bodyTop + 0.435), w * 0.025, h * 0.015),
        const Radius.circular(2),
      ),
      highlight,
    );

    // ── Luggage ──
    final lugTop = h * (bodyTop + 0.45);
    _drawSuitcase(canvas,
      Rect.fromLTWH(w * (frontEdge + 0.04), lugTop, w * 0.09, h * 0.16),
      lugPaint, true,
    );
    _drawSuitcase(canvas,
      Rect.fromLTWH(w * (frontEdge + 0.15), lugTop - h * 0.04, w * 0.085, h * 0.20),
      lugPaint, true,
    );
    _drawRollerBag(canvas,
      Rect.fromLTWH(w * (frontEdge + 0.255), lugTop + h * 0.02, w * 0.075, h * 0.14),
      lugPaint,
    );
    _drawSuitcase(canvas,
      Rect.fromLTWH(w * (frontEdge + 0.34), lugTop + h * 0.06, w * 0.065, h * 0.12),
      Paint()..color = const Color(0xFF8B84FF),
      false,
    );

    // ── Headlight ──
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * (bodyLeft + 0.005), h * (bodyBot - 0.22),
            w * 0.03, h * 0.10),
        const Radius.circular(4),
      ),
      headlightGlow,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * (bodyLeft - 0.005), h * (bodyBot - 0.24),
            w * 0.05, h * 0.14),
        const Radius.circular(6),
      ),
      Paint()..color = const Color(0xFFFEF9C3).withOpacity(0.2),
    );
    
    // ── Taillight ──
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * (bodyRight - 0.035), h * (bodyBot - 0.22),
            w * 0.025, h * 0.10),
        const Radius.circular(4),
      ),
      taillightRed,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * (bodyRight - 0.02), h * (bodyBot - 0.24),
            w * 0.04, h * 0.14),
        const Radius.circular(6),
      ),
      Paint()..color = const Color(0xFFFF4758).withOpacity(0.15),
    );

    // ── Front bumper ──
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * bodyLeft, h * (bodyBot - 0.06),
            w * (frontEdge - bodyLeft), h * 0.06),
        const Radius.circular(4),
      ),
      darkPurple,
    );
    for (int i = 0; i < 4; i++) {
      final yPos = h * (bodyBot - 0.055 + i * 0.018);
      canvas.drawLine(
        Offset(w * (bodyLeft + 0.03), yPos),
        Offset(w * (frontEdge - 0.03), yPos),
        Paint()..color = Colors.white.withOpacity(0.15 + i * 0.05)..strokeWidth = 1.5,
      );
    }

    // ── Bottom chassis ──
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * bodyLeft, h * (bodyBot - 0.01),
            w * (bodyRight - bodyLeft), h * 0.06),
        const Radius.circular(4),
      ),
      darkPurple,
    );

    // ── Side skirt ──
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * (frontEdge + 0.01), h * (bodyBot - 0.02),
            w * (bodyRight - frontEdge - 0.02), h * 0.025),
        const Radius.circular(2),
      ),
      lightPurple,
    );

    // ── Wheels ──
    _drawWheel(canvas, Offset(w * frontWheelX, h * wheelY), w * wheelR,
        tyreBlack, rimSilver, hubWhite, lightPurple);
    _drawWheel(canvas, Offset(w * rearWheelX, h * wheelY), w * wheelR,
        tyreBlack, rimSilver, hubWhite, lightPurple);

    // ── Wheel arches ──
    final archPaint = Paint()
      ..color = const Color(0xFF3A32AA)
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.012;
    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(w * frontWheelX, h * wheelY),
        width: w * 0.28,
        height: w * 0.28,
      ),
      0.2, 2.3, false, archPaint,
    );
    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(w * rearWheelX, h * wheelY),
        width: w * 0.28,
        height: w * 0.28,
      ),
      0.2, 2.3, false, archPaint,
    );

    // ── Exhaust pipe ──
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * (bodyRight - 0.06), h * (bodyBot + 0.015),
            w * 0.04, h * 0.025),
        const Radius.circular(3),
      ),
      rimSilver,
    );

    // ── Side mirror ──
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * (frontEdge + 0.005), h * (bodyTop + 0.04),
            w * 0.04, h * 0.06),
        const Radius.circular(4),
      ),
      darkPurple,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * (frontEdge + 0.008), h * (bodyTop + 0.045),
            w * 0.025, h * 0.05),
        const Radius.circular(3),
      ),
      midPurple,
    );

    // ── Roof rack ──
    final rackPaint = Paint()
      ..color = const Color(0xFF3A32AA)
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.01;
    canvas.drawLine(
      Offset(w * (frontEdge + 0.02), h * (bodyTop + 0.015)),
      Offset(w * (bodyRight - 0.02), h * (bodyTop + 0.015)),
      rackPaint,
    );
    for (int i = 0; i < 4; i++) {
      final xPos = w * (frontEdge + 0.06 + i * 0.18);
      canvas.drawLine(
        Offset(xPos, h * (bodyTop + 0.005)),
        Offset(xPos, h * (bodyTop + 0.025)),
        rackPaint,
      );
    }
  }

  // ── Helpers ──
  void _drawSuitcase(Canvas canvas, Rect r, Paint paint, bool hasStripe) {
    canvas.drawRRect(RRect.fromRectAndRadius(r, const Radius.circular(4)), paint);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(r.left + 2, r.top + 2, r.width * 0.3, r.height * 0.1),
        const Radius.circular(2),
      ),
      Paint()..color = Colors.white.withOpacity(0.3),
    );
    final hp = Paint()
      ..color = paint.color
      ..style = PaintingStyle.stroke
      ..strokeWidth = r.width * 0.12;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(r.left + r.width * 0.2, r.top - r.height * 0.12,
            r.width * 0.60, r.height * 0.12),
        const Radius.circular(3),
      ),
      hp,
    );
    canvas.drawRect(
      Rect.fromLTWH(r.left + r.width * 0.35, r.top + r.height * 0.42,
          r.width * 0.30, r.height * 0.12),
      Paint()..color = Colors.white.withOpacity(0.5),
    );
    if (hasStripe) {
      canvas.drawRect(
        Rect.fromLTWH(r.left + 2, r.top + r.height * 0.55,
            r.width - 4, r.height * 0.08),
        Paint()..color = Colors.white.withOpacity(0.2),
      );
    }
  }

  void _drawRollerBag(Canvas canvas, Rect r, Paint paint) {
    canvas.drawRRect(RRect.fromRectAndRadius(r, const Radius.circular(4)), paint);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(r.left + 2, r.top + 2, r.width * 0.3, r.height * 0.1),
        const Radius.circular(2),
      ),
      Paint()..color = Colors.white.withOpacity(0.3),
    );
    final sp = Paint()
      ..color = paint.color
      ..style = PaintingStyle.stroke
      ..strokeWidth = r.width * 0.12;
    final hx1 = r.left + r.width * 0.25;
    final hx2 = r.left + r.width * 0.75;
    final hy  = r.top - r.height * 0.18;
    canvas.drawLine(Offset(hx1, r.top), Offset(hx1, hy), sp);
    canvas.drawLine(Offset(hx2, r.top), Offset(hx2, hy), sp);
    canvas.drawLine(Offset(hx1, hy), Offset(hx2, hy), sp);
    final wp = Paint()..color = paint.color;
    canvas.drawCircle(Offset(hx1, r.bottom + r.height * 0.07), r.width * 0.10, wp);
    canvas.drawCircle(Offset(hx2, r.bottom + r.height * 0.07), r.width * 0.10, wp);
  }

  void _drawWheel(Canvas canvas, Offset c, double r,
      Paint tyre, Paint rim, Paint hub, Paint accent) {
    canvas.drawCircle(c + Offset(r * 0.03, r * 0.03), r, 
      Paint()..color = Colors.black.withOpacity(0.15),
    );
    canvas.drawCircle(c, r, tyre);
    canvas.drawCircle(c, r * 0.85, 
      Paint()..color = const Color(0xFF2A2A4A)..style = PaintingStyle.stroke..strokeWidth = r * 0.05,
    );
    canvas.drawCircle(c, r * 0.65, rim);
    canvas.drawCircle(c, r * 0.40, 
      Paint()..color = const Color(0xFFB8B8D0)..style = PaintingStyle.stroke..strokeWidth = r * 0.04,
    );
    final spokePaint = Paint()
      ..color = const Color(0xFF8A8AAA)
      ..strokeWidth = r * 0.09
      ..style = PaintingStyle.stroke;
    for (int i = 0; i < 5; i++) {
      final angle = i * 3.14159 * 2 / 5;
      canvas.drawLine(
        c,
        Offset(c.dx + r * 0.55 * math.cos(angle), c.dy + r * 0.55 * math.sin(angle)),
        spokePaint,
      );
    }
    canvas.drawCircle(c, r * 0.22, hub);
    canvas.drawCircle(c, r * 0.10, accent);
    canvas.drawCircle(c, r * 0.04, 
      Paint()..color = const Color(0xFFE8E8F0),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ─── CITY SKYLINE ─────────────────────────────────────────────────
class _CitySkyline extends StatelessWidget {
  const _CitySkyline();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      child: CustomPaint(painter: _SkylinePainter()),
    );
  }
}

class _SkylinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final p1 = Paint()..color = const Color(0xFFD0D6FF).withOpacity(0.6);
    final p2 = Paint()..color = const Color(0xFFC0C8FF).withOpacity(0.45);

    final buildings2 = [
      [0.05, 0.5, 0.07, 1.0],
      [0.13, 0.3, 0.06, 1.0],
      [0.20, 0.45, 0.05, 1.0],
      [0.30, 0.20, 0.05, 1.0],
      [0.36, 0.35, 0.07, 1.0],
      [0.44, 0.15, 0.06, 1.0],
      [0.51, 0.28, 0.05, 1.0],
      [0.57, 0.10, 0.06, 1.0],
      [0.64, 0.22, 0.07, 1.0],
      [0.72, 0.32, 0.05, 1.0],
      [0.78, 0.18, 0.06, 1.0],
      [0.85, 0.38, 0.08, 1.0],
      [0.94, 0.26, 0.06, 1.0],
    ];
    for (final b in buildings2) {
      canvas.drawRect(
        Rect.fromLTWH(w * b[0], h * b[1], w * b[2], h * b[3]),
        p2,
      );
    }

    final buildings1 = [
      [0.0, 0.60, 0.08, 1.0],
      [0.09, 0.40, 0.07, 1.0],
      [0.17, 0.55, 0.06, 1.0],
      [0.24, 0.25, 0.06, 1.0],
      [0.31, 0.42, 0.07, 1.0],
      [0.39, 0.32, 0.05, 1.0],
      [0.45, 0.48, 0.06, 1.0],
      [0.52, 0.20, 0.07, 1.0],
      [0.60, 0.38, 0.06, 1.0],
      [0.67, 0.52, 0.07, 1.0],
      [0.75, 0.30, 0.06, 1.0],
      [0.82, 0.45, 0.08, 1.0],
      [0.91, 0.35, 0.09, 1.0],
    ];
    for (final b in buildings1) {
      canvas.drawRect(
        Rect.fromLTWH(w * b[0], h * b[1], w * b[2], h * b[3]),
        p1,
      );
    }

    final antennaPaint = Paint()
      ..color = const Color(0xFFB0B8FF).withOpacity(0.5)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;
    final spires = [
      [0.27, 0.25, 0.27, 0.06],
      [0.47, 0.20, 0.47, 0.04],
      [0.55, 0.20, 0.55, 0.03],
      [0.79, 0.30, 0.79, 0.06],
    ];
    for (final s in spires) {
      canvas.drawLine(
        Offset(w * s[0], h * s[1]),
        Offset(w * s[2], h * s[3]),
        antennaPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ─── HILL PAINTER ─────────────────────────────────────────────────
class _HillPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final hill1 = Path()
      ..moveTo(0, h * 0.5)
      ..quadraticBezierTo(w * 0.25, 0, w * 0.55, h * 0.3)
      ..quadraticBezierTo(w * 0.75, h * 0.55, w, h * 0.2)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();
    canvas.drawPath(
        hill1, Paint()..color = const Color(0xFF8B84FF).withOpacity(0.25));

    final hill2 = Path()
      ..moveTo(0, h * 0.65)
      ..quadraticBezierTo(w * 0.3, h * 0.40, w * 0.6, h * 0.55)
      ..quadraticBezierTo(w * 0.8, h * 0.65, w, h * 0.48)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();
    canvas.drawPath(
        hill2, Paint()..color = const Color(0xFF6C63FF).withOpacity(0.15));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
