# Transparent Tap Animation

A lightweight, iOS-style tap animation widget for Flutter. It smoothly reduces the opacity of its child upon press and incorporates intelligent scroll-aware gesture detection to prevent unintended tap events during scrolling.

![Transparent Tap Animation Demo](https://github.com/user-attachments/assets/99161065-5eb4-4ac8-a9dc-33465bcd550d)

## Features

- **iOS-style Opacity Feedback:** Reduces opacity to 50% on press and returns to 100% smoothly upon release.
- **Scroll-Aware Detection:** Automatically cancels the tap effect if the user scrolls the view.
- **Boundary Detection:** Cancels the gesture if the pointer leaves the widget bounds.
- **Double-Tap Support:** Built-in double-tap gesture recognition with a 300ms threshold.
- **Long-Press Support:** Configurable long-press recognition with a 500ms delay.
- **Smooth Animation:** Uses a 100ms animated transition for visual feedback.
- **Lightweight Implementation:** A single-file package with no external dependencies.
- **Accessibility:** Includes basic `Semantics` support for screen readers.

## Installation

Add the package to your `pubspec.yaml` file:

```yaml
dependencies:
  transparent_tap_animation: ^0.0.1
```

## Usage

### Basic Tap

Wrap your widget with `TransparentTapAnimation` to add tap feedback.

```dart
import 'package:transparent_tap_animation/transparent_tap_animation.dart';

TransparentTapAnimation(
  onTap: () => print('Tapped!'),
  child: Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.blue,
      borderRadius: BorderRadius.circular(12),
    ),
    child: const Text('Tap me'),
  ),
)
```

### Advanced Gestures

You can handle multiple gesture types simultaneously.

```dart
TransparentTapAnimation(
  onTap: () => print('Single tap'),
  onDoubleTap: () => print('Double tap'),
  onLongPress: () => print('Long press'),
  child: const MyButton(),
)
```

### Integration with Lists

Using the widget inside a scrollable view ensures robust scroll-aware behavior.

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

## API Reference

| Property | Type | Default | Description |
|---|---|---|---|
| `child` | `Widget` | **Required** | The widget to act upon and animate. |
| `onTap` | `VoidCallback?` | `null` | Callback executed upon a single tap. |
| `onDoubleTap` | `VoidCallback?` | `null` | Callback executed upon a double tap. |
| `onLongPress` | `VoidCallback?` | `null` | Callback executed upon a long press. |

## Implementation Details

This widget utilizes lower-level pointer handling via the `Listener` widget instead of a `GestureDetector`. This implementation provides more granular control needed for robust interactions:

1. **Pointer Down:** Opacity is reduced, and the relative button position is stored.
2. **Pointer Move:** Actively monitors if the button has scrolled out of position or if the pointer has left the designated widget bounds.
3. **Pointer Up:** If the pointer remains within bounds and the widget has not shifted due to scrolling, the `onTap` callback is triggered.
4. **Scroll Safety Margin:** Employs a specific movement tolerance to negate false tap events while scrolling.

## Requirements

- Flutter: 3.10 or higher
- Dart: 3.0 or higher

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for more details.
