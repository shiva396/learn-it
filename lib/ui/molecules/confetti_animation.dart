import 'dart:math';
import 'package:flutter/material.dart';

class ConfettiAnimation extends StatefulWidget {
  final Widget child;
  final bool shouldAnimate;
  final Duration duration;

  const ConfettiAnimation({
    super.key,
    required this.child,
    this.shouldAnimate = false,
    this.duration = const Duration(seconds: 3),
  });

  @override
  State<ConfettiAnimation> createState() => _ConfettiAnimationState();
}

class _ConfettiAnimationState extends State<ConfettiAnimation>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  final List<ConfettiParticle> _particles = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    if (widget.shouldAnimate) {
      _initializeParticles();
      _controller.forward();
    }
  }

  void _initializeParticles() {
    _particles.clear();
    for (int i = 0; i < 50; i++) {
      _particles.add(ConfettiParticle(
        color: _getRandomColor(),
        startX: _random.nextDouble(),
        startY: -0.1,
        endX: _random.nextDouble(),
        endY: 1.1,
        size: _random.nextDouble() * 8 + 4,
        rotation: _random.nextDouble() * 2 * pi,
      ));
    }
  }

  Color _getRandomColor() {
    final colors = [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.yellow,
      Colors.purple,
      Colors.orange,
      Colors.pink,
      Colors.cyan,
    ];
    return colors[_random.nextInt(colors.length)];
  }

  @override
  void didUpdateWidget(ConfettiAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.shouldAnimate && !oldWidget.shouldAnimate) {
      _initializeParticles();
      _controller.reset();
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (widget.shouldAnimate)
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return CustomPaint(
                  painter: ConfettiPainter(
                    particles: _particles,
                    progress: _controller.value,
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}

class ConfettiParticle {
  final Color color;
  final double startX;
  final double startY;
  final double endX;
  final double endY;
  final double size;
  final double rotation;

  ConfettiParticle({
    required this.color,
    required this.startX,
    required this.startY,
    required this.endX,
    required this.endY,
    required this.size,
    required this.rotation,
  });
}

class ConfettiPainter extends CustomPainter {
  final List<ConfettiParticle> particles;
  final double progress;

  ConfettiPainter({
    required this.particles,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final particle in particles) {
      final paint = Paint()
        ..color = particle.color.withOpacity(1.0 - progress)
        ..style = PaintingStyle.fill;

      final x = _lerp(particle.startX, particle.endX, progress) * size.width;
      final y = _lerp(particle.startY, particle.endY, progress) * size.height;

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(particle.rotation * progress * 4);
      
      // Draw square confetti
      canvas.drawRect(
        Rect.fromCenter(
          center: Offset.zero,
          width: particle.size,
          height: particle.size,
        ),
        paint,
      );
      
      canvas.restore();
    }
  }

  double _lerp(double start, double end, double t) {
    return start + (end - start) * t;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class CelebrationEffect extends StatefulWidget {
  final Widget child;
  final bool trigger;
  final VoidCallback? onComplete;

  const CelebrationEffect({
    super.key,
    required this.child,
    this.trigger = false,
    this.onComplete,
  });

  @override
  State<CelebrationEffect> createState() => _CelebrationEffectState();
}

class _CelebrationEffectState extends State<CelebrationEffect>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _confettiController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _confettiController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    ));

    if (widget.trigger) {
      _startCelebration();
    }
  }

  void _startCelebration() async {
    await _scaleController.forward();
    await _scaleController.reverse();
    _confettiController.forward();
    
    if (widget.onComplete != null) {
      Future.delayed(const Duration(seconds: 3), widget.onComplete!);
    }
  }

  @override
  void didUpdateWidget(CelebrationEffect oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.trigger && !oldWidget.trigger) {
      _startCelebration();
    }
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ConfettiAnimation(
      shouldAnimate: widget.trigger,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: widget.child,
          );
        },
      ),
    );
  }
}
