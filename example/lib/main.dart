import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:transparent_tap_animation/transparent_tap_animation.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TransparentTapAnimation',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF000000),
      ),
      home: const ExampleScreen(),
    );
  }
}

class ExampleScreen extends StatefulWidget {
  const ExampleScreen({super.key});

  @override
  State<ExampleScreen> createState() => _ExampleScreenState();
}

class _ExampleScreenState extends State<ExampleScreen> {
  String _event = 'Tap something below';

  void _fire(String msg) {
    HapticFeedback.selectionClick();
    setState(() => _event = msg);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 48),

                // Title

                // Event label
                Center(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: Text(
                      _event,
                      key: ValueKey(_event),
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF0A84FF),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Gesture examples using SpeakBlend styles
                _SpeakBlendButton(
                  icon: Icons.touch_app_rounded,
                  color: const Color(0xFF1C1C1E),
                  textColor: Colors.white,
                  title: 'Single Tap',
                  onTap: () => _fire('Single tap'),
                ),
                const SizedBox(height: 16),
                _SpeakBlendButton(
                  icon: Icons.layers_rounded,
                  color: const Color(0xFF1C1C1E),
                  textColor: Colors.white,
                  title: 'Double Tap',
                  onTap: () => _fire('Single tap'),
                  onDoubleTap: () => _fire('Double tap'),
                ),
                const SizedBox(height: 16),
                _SpeakBlendButton(
                  icon: Icons.timer_rounded,
                  color: const Color(0xFF1C1C1E),
                  textColor: Colors.white,
                  title: 'Long Press',
                  onTap: () => _fire('Single tap'),
                  onLongPress: () => _fire('Long press'),
                ),

                const SizedBox(height: 32),

                // Colored buttons list
                const Padding(
                  padding: EdgeInsets.only(left: 4, bottom: 16),
                  child: Text(
                    'COLORS & SQUIRCLES',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.2,
                      color: Color(0xFF636366),
                    ),
                  ),
                ),

                ...List.generate(6, (i) {
                  final colors = [
                    const Color(0xFF0A84FF),
                    const Color(0xFFFF375F),
                    const Color(0xFFFF9F0A),
                    const Color(0xFF30D158),
                    const Color(0xFFBF5AF2),
                    const Color(0xFF64D2FF),
                  ];
                  final icons = [
                    Icons.bolt_rounded,
                    Icons.favorite_rounded,
                    Icons.star_rounded,
                    Icons.rocket_launch_rounded,
                    Icons.auto_awesome_rounded,
                    Icons.wb_sunny_rounded,
                  ];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _SpeakBlendButton(
                      icon: icons[i],
                      color: colors[i],
                      textColor: Colors.white,
                      title: 'Item ${i + 1}',
                      onTap: () => _fire('Item ${i + 1} tapped'),
                    ),
                  );
                }),

                const SizedBox(height: 48),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── SpeakBlend Style Button ──────────────────────────────────────────────────

class _SpeakBlendButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final Color textColor;
  final String title;
  final VoidCallback? onTap;
  final VoidCallback? onDoubleTap;
  final VoidCallback? onLongPress;

  const _SpeakBlendButton({
    required this.icon,
    required this.color,
    required this.textColor,
    required this.title,
    this.onTap,
    this.onDoubleTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return TransparentTapAnimation(
      onTap: onTap,
      onDoubleTap: onDoubleTap,
      onLongPress: onLongPress,
      child: Container(
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: const [0.1, 0.8],
            colors: [
              const Color(0xFF48484A), // SpeakBlend app gray tint for border
              color,
            ],
          ),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Container(
          height: 56,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(22),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: textColor, size: 24),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                  letterSpacing: -0.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
