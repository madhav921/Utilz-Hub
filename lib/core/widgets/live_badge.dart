import 'package:flutter/material.dart';

/// Animated pulsating LIVE badge for tools that use real-time data.
///
/// Shows a red dot with "LIVE" text. The dot pulsates to indicate
/// active live data connection.
class LiveBadge extends StatefulWidget {
  final double size;

  const LiveBadge({super.key, this.size = 10});

  @override
  State<LiveBadge> createState() => _LiveBadgeState();
}

class _LiveBadgeState extends State<LiveBadge>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Container(
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: _animation.value),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.red.withValues(alpha: _animation.value * 0.5),
                    blurRadius: widget.size * 0.8,
                    spreadRadius: widget.size * 0.2,
                  ),
                ],
              ),
            );
          },
        ),
        const SizedBox(width: 4),
        const Text(
          'LIVE',
          style: TextStyle(
            color: Colors.red,
            fontSize: 10,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}
