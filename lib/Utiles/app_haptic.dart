import 'package:flutter/services.dart';
import 'package:vibration/vibration.dart';

class AppHaptics {
  /// Crisp, tiny 15ms tick for selecting tags, categories, or toggles
  static Future<void> lightTap() async {
    if (await Vibration.hasVibrator() ?? false) {
      Vibration.vibrate(duration: 15, amplitude: 80);
    } else {
      HapticFeedback.lightImpact();
    }
  }

  /// Solid 40ms thud for primary actions like "Save Link"
  static Future<void> mediumTap() async {
    if (await Vibration.hasVibrator() ?? false) {
      Vibration.vibrate(duration: 40, amplitude: 150);
    } else {
      HapticFeedback.mediumImpact();
    }
  }

  /// Double-pulse vibration for errors or duplicate link warnings
  static Future<void> errorVibrate() async {
    if (await Vibration.hasVibrator() ?? false) {
      // Wait 0ms, vibrate 40ms, pause 60ms, vibrate 60ms
      Vibration.vibrate(pattern: [0, 40, 60, 60]);
    } else {
      HapticFeedback.heavyImpact();
    }
  }
}