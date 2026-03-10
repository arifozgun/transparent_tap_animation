# Transparent Tap Animation

A lightweight iOS-style tap animation widget for Flutter. Smoothly reduces opacity on press with intelligent scroll-aware gesture detection.

## ✨ Features

- **iOS-style opacity feedback** — Reduces to 50% opacity on press, returns smoothly on release
- **Scroll-aware** — Automatically cancels tap effect when the user scrolls (button moves)
- **Boundary detection** — Cancels when finger leaves the widget bounds
- **Double-tap support** — Built-in double-tap gesture with 300ms threshold
- **Long-press support** — Configurable long-press with 500ms delay
- **Smooth animation** — 100ms animated opacity transition
- **Lightweight** — No dependencies beyond Flutter, single file
- **Accessible** — Includes proper `Semantics` for screen readers

## 📦 Installation

```yaml
dependencies:
  transparent_tap_animation: ^0.0.1
```

## 🚀 Usage

### Basic Tap

```dart
import 'package:transparent_tap_animation/transparent_tap_animation.dart';

TransparentTapAnimation(
  onTap: () => print('Tapped!'),
  child: Container(
    padding: EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.blue,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Text('Tap me'),
  ),
)
```

### With All Gestures

```dart
TransparentTapAnimation(
  onTap: () => print('Single tap'),
  onDoubleTap: () => print('Double tap'),
  onLongPress: () => print('Long press'),
  child: MyButton(),
)
```

### In a List

```dart
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) {
    return TransparentTapAnimation(
      onTap: () => navigateTo(items[index]),
      child: ListTile(title: Text(items[index].title)),
    );
  },
)
```

## ⚙️ API

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `child` | `Widget` | Required | The widget to animate |
| `onTap` | `VoidCallback?` | `null` | Called on single tap |
| `onDoubleTap` | `VoidCallback?` | `null` | Called on double tap (300ms threshold) |
| `onLongPress` | `VoidCallback?` | `null` | Called on long press (500ms delay) |

## 🧠 How It Works

The widget uses low-level `Listener` instead of `GestureDetector` for precise control:

1. **Pointer down** → Opacity drops to 0.5, records button position
2. **Pointer move** → Checks if button scrolled out of position or finger left bounds
3. **Pointer up** → If still in bounds and button hasn't moved → triggers `onTap`
4. **Scroll safety** → 5px movement tolerance prevents false taps during scroll

## 📋 Requirements

- Flutter 3.10+
- Dart 3.0+

## 📄 License

MIT License — see [LICENSE](LICENSE) for details.
