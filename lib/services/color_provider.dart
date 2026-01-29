import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppColorScheme {
  blue,    // الأزرق الكلاسيكي
  purple,  // البنفسجي الأنيق
  green,   // الأخضر الطبيعي
  red,     // الأحمر الدافئ
  orange,  // البرتقالي الحيوي
  black,   // الأسود الاحترافي
}

class ColorProvider extends ChangeNotifier {
  static const String _colorKey = 'app_color';
  AppColorScheme _currentColor = AppColorScheme.blue;

  ColorProvider() {
    _loadColor();
  }

  AppColorScheme get currentColor => _currentColor;

  Future<void> _loadColor() async {
    final prefs = await SharedPreferences.getInstance();
    final colorIndex = prefs.getInt(_colorKey) ?? 0;
    _currentColor = AppColorScheme.values[colorIndex];
    notifyListeners();
  }

  Future<void> setColor(AppColorScheme color) async {
    if (_currentColor == color) return;

    _currentColor = color;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_colorKey, color.index);
    notifyListeners();
  }

  // الألوان الأساسية لكل ثيم
  Color getPrimaryColor() {
    switch (_currentColor) {
      case AppColorScheme.blue:
        return const Color(0xFF2196F3); // أزرق فاتح
      case AppColorScheme.purple:
        return const Color(0xFF9C27B0); // بنفسجي
      case AppColorScheme.green:
        return const Color(0xFF4CAF50); // أخضر
      case AppColorScheme.red:
        return const Color(0xFFE53935); // أحمر
      case AppColorScheme.orange:
        return const Color(0xFFFF9800); // برتقالي
      case AppColorScheme.black:
        return const Color(0xFF424242); // رمادي غامق
    }
  }

  Color getSecondaryColor() {
    switch (_currentColor) {
      case AppColorScheme.blue:
        return const Color(0xFF1976D2);
      case AppColorScheme.purple:
        return const Color(0xFF7B1FA2);
      case AppColorScheme.green:
        return const Color(0xFF388E3C);
      case AppColorScheme.red:
        return const Color(0xFFC62828);
      case AppColorScheme.orange:
        return const Color(0xFFF57C00);
      case AppColorScheme.black:
        return const Color(0xFF212121);
    }
  }


  String getColorNameAr() {
    switch (_currentColor) {
      case AppColorScheme.blue:
        return 'الأزرق الكلاسيكي';
      case AppColorScheme.purple:
        return 'البنفسجي الأنيق';
      case AppColorScheme.green:
        return 'الأخضر الطبيعي';
      case AppColorScheme.red:
        return 'الأحمر الدافئ';
      case AppColorScheme.orange:
        return 'البرتقالي الحيوي';
      case AppColorScheme.black:
        return 'الأسود الاحترافي';
    }
  }

  // اسم اللون بالإنجليزية
  String getColorNameEn() {
    switch (_currentColor) {
      case AppColorScheme.blue:
        return 'Classic Blue';
      case AppColorScheme.purple:
        return 'Elegant Purple';
      case AppColorScheme.green:
        return 'Natural Green';
      case AppColorScheme.red:
        return 'Warm Red';
      case AppColorScheme.orange:
        return 'Vibrant Orange';
      case AppColorScheme.black:
        return 'Professional Black';
    }
  }
}