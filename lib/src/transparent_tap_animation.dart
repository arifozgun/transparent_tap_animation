import 'package:flutter/material.dart';

/// A lightweight iOS-style tap animation widget.
///
/// Reduces the child widget's opacity to 50% on press, creating a
/// native iOS-style feedback effect. Includes scroll-aware gesture
/// detection, double-tap, and long-press support.
///
/// Example:
/// ```dart
/// TransparentTapAnimation(
///   onTap: () => print('Tapped!'),
///   child: MyButton(),
/// )
/// ```
class TransparentTapAnimation extends StatefulWidget {
  /// The widget to wrap with tap animation.
  final Widget child;

  /// Called when the widget is tapped.
  final void Function()? onTap;

  /// Called when the widget is double-tapped.
  final void Function()? onDoubleTap;

  /// Called when the widget is long-pressed.
  final void Function()? onLongPress;

  const TransparentTapAnimation({
    super.key,
    required this.child,
    this.onTap,
    this.onDoubleTap,
    this.onLongPress,
  });

  @override
  State<TransparentTapAnimation> createState() =>
      _TransparentTapAnimationState();
}

class _TransparentTapAnimationState extends State<TransparentTapAnimation> {
  Offset? _initialButtonPosition;
  Size? _buttonSize;
  bool _isPressed = false;
  double _opacity = 1.0;
  bool _disposed = false;
  bool _isLongPress = false;

  // Double tap tracking
  DateTime? _lastTapTime;
  bool _isDoubleTap = false;

  // Button movement tolerance (pixels)
  static const double _positionTolerance = 5.0;

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  void _safeSetState(VoidCallback fn) {
    if (!mounted || _disposed) return;
    setState(fn);
  }

  void _updateButtonMetrics() {
    if (!mounted || _disposed) return;
    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox != null && renderBox.hasSize) {
      _initialButtonPosition = renderBox.localToGlobal(Offset.zero);
      _buttonSize = renderBox.size;
    }
  }

  Offset? _getCurrentButtonPosition() {
    if (!mounted || _disposed) return null;
    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox != null && renderBox.hasSize) {
      return renderBox.localToGlobal(Offset.zero);
    }
    return null;
  }

  bool _hasButtonMoved() {
    if (_initialButtonPosition == null) return false;
    final currentPosition = _getCurrentButtonPosition();
    if (currentPosition == null) return true;

    final distance = (_initialButtonPosition! - currentPosition).distance;
    return distance > _positionTolerance;
  }

  bool _isPointerInsideButton(Offset globalPosition) {
    final currentPosition = _getCurrentButtonPosition();
    if (currentPosition == null || _buttonSize == null) return false;

    return globalPosition.dx >= currentPosition.dx &&
        globalPosition.dx <= currentPosition.dx + _buttonSize!.width &&
        globalPosition.dy >= currentPosition.dy &&
        globalPosition.dy <= currentPosition.dy + _buttonSize!.height;
  }

  void _handlePointerDown(PointerDownEvent event) {
    if (!mounted || _disposed) return;
    _updateButtonMetrics();
    _isPressed = true;
    _isLongPress = false;
    _isDoubleTap = false;
    _safeSetState(() => _opacity = 0.5);

    // Double tap check
    if (widget.onDoubleTap != null) {
      final now = DateTime.now();
      if (_lastTapTime != null &&
          now.difference(_lastTapTime!).inMilliseconds < 300) {
        _isDoubleTap = true;
        widget.onDoubleTap?.call();
        _lastTapTime = null;
      } else {
        _lastTapTime = now;
      }
    }

    // Long press timer
    if (widget.onLongPress != null) {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (_isPressed && !_disposed && !_isDoubleTap && !_hasButtonMoved()) {
          _isLongPress = true;
          widget.onLongPress?.call();
        }
      });
    }
  }

  void _handlePointerMove(PointerMoveEvent event) {
    if (!mounted || _disposed || !_isPressed) return;

    final buttonMoved = _hasButtonMoved();
    final insideButton = _isPointerInsideButton(event.position);

    if (buttonMoved || !insideButton) {
      if (_opacity != 1.0) {
        _safeSetState(() => _opacity = 1.0);
      }
    } else {
      if (_opacity != 0.5) {
        _safeSetState(() => _opacity = 0.5);
      }
    }
  }

  void _handlePointerUp(PointerUpEvent event) {
    if (!mounted || _disposed || !_isPressed) return;
    _isPressed = false;

    final buttonMoved = _hasButtonMoved();
    final insideButton = _isPointerInsideButton(event.position);

    if (!buttonMoved && insideButton && !_isLongPress && !_isDoubleTap) {
      if (widget.onDoubleTap != null) {
        Future.delayed(const Duration(milliseconds: 300), () {
          if (!_isDoubleTap && !_disposed) {
            widget.onTap?.call();
          }
        });
      } else {
        widget.onTap?.call();
      }
    }

    _safeSetState(() {
      _opacity = 1.0;
      _isLongPress = false;
    });
  }

  void _handlePointerCancel(PointerCancelEvent event) {
    if (!mounted || _disposed) return;
    _isPressed = false;
    _safeSetState(() {
      _opacity = 1.0;
      _isLongPress = false;
      _isDoubleTap = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: DecoratedBox(
        decoration: const BoxDecoration(),
        child: Semantics(
          button: true,
          enabled: true,
          child: Listener(
            behavior: HitTestBehavior.translucent,
            onPointerDown: _handlePointerDown,
            onPointerMove: _handlePointerMove,
            onPointerUp: _handlePointerUp,
            onPointerCancel: _handlePointerCancel,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 100),
              curve: Curves.linear,
              opacity: _opacity,
              child: widget.child,
            ),
          ),
        ),
      ),
    );
  }
}
