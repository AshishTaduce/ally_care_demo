import 'package:flutter/material.dart';
import 'dart:math' as math;

class AnimatedBottomWaves extends StatefulWidget {
  final double height;
  final double minWaveHeight;
  final List<Color> gradientColors;
  final double animationSpeed;
  final int waveCount;

  const AnimatedBottomWaves({
    Key? key,
    this.height = 200,
    this.minWaveHeight = 40.0,
    this.gradientColors = const [
      Color(0xFF4A90E2),
      Color(0xFF7BB3F0),
      Color(0xFF5BA3F5),
    ],
    this.animationSpeed = 1.0,
    this.waveCount = 3,
  }) : super(key: key);

  @override
  State<AnimatedBottomWaves> createState() => _AnimatedBottomWavesState();
}

class _AnimatedBottomWavesState extends State<AnimatedBottomWaves>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: (40000 / widget.animationSpeed).round()),
      vsync: this,
    );
    // Start the continuous animation
    _animationController.repeat();
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
        return CustomPaint(
          painter: WavePainter(
            animationValue: _animationController.value,
            gradientColors: widget.gradientColors,
            waveCount: widget.waveCount,
            minWaveHeight: widget.minWaveHeight,
          ),
          size: Size(double.infinity, widget.height),
        );
      },
    );
  }
}

class WavePainter extends CustomPainter {
  final double animationValue;
  final List<Color> gradientColors;
  final int waveCount;
  final double minWaveHeight;

  WavePainter({
    required this.animationValue,
    required this.gradientColors,
    required this.waveCount,
    required this.minWaveHeight,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    // Create gradient
    final gradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: gradientColors,
    );

    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    paint.shader = gradient.createShader(rect);

    // Draw multiple wave layers
    for (int i = 0; i < waveCount; i++) {
      final path = Path();
      final waveHeight = math.max(minWaveHeight * 0.3, 15.0 + (i * 8.0));
      final frequency = 0.008 + (i * 0.002);
      final phase = (animationValue * 2 * math.pi) + (i * 1.2);
      final opacity = 1.0 - (i * 0.15);
      final baseOffset = (i * 20.0) + 25.0;

      // Start from bottom left
      path.moveTo(0, size.height);

      // Create wave using sine function with reduced curve
      for (double x = 0; x <= size.width; x++) {
        final mainWave = waveHeight * math.sin((x * frequency) + phase);
        final secondaryWave = (waveHeight * 0.3) * math.sin((x * frequency * 2.2) + phase * 1.1);
        final tertiaryWave = (waveHeight * 0.15) * math.sin((x * frequency * 3.5) + phase * 0.8);

        final y = size.height - mainWave - secondaryWave - tertiaryWave - baseOffset;
        path.lineTo(x, y);
      }

      // Close the path to fill the bottom area
      path.lineTo(size.width, size.height);
      path.close();

      // Apply opacity to paint
      paint.color = Color.lerp(
        Colors.transparent,
        Colors.white,
        opacity,
      )!;

      // Use blend mode for layered effect
      paint.blendMode = i == 0 ? BlendMode.srcOver : BlendMode.multiply;

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant WavePainter oldDelegate) {
    return animationValue != oldDelegate.animationValue;
  }
}