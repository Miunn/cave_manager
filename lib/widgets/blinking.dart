import 'package:flutter/cupertino.dart';

class BlinkingWidget extends StatefulWidget {
  const BlinkingWidget({super.key, required this.child, this.duration});

  final Widget child;
  final Duration? duration;

  @override
  State<BlinkingWidget> createState() => _BlinkingWidgetState();
}

class _BlinkingWidgetState extends State<BlinkingWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration ?? const Duration(milliseconds: 500),
      reverseDuration: widget.duration ?? const Duration(milliseconds: 500),
      vsync: this,
      lowerBound: 0.2,
    )..repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _controller,
      child: widget.child,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}