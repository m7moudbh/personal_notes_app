import 'package:flutter/material.dart';

class AppConstants {
  // App Info
  static const String appName = 'MNote';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'احفظ أفكارك وملاحظاتك بأمان وسهولة';
  
  // Text Styles
  static const TextStyle titleStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );
  
  static const TextStyle subtitleStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );
  
  static const TextStyle bodyStyle = TextStyle(
    fontSize: 14,
  );
  
  // Spacing
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  
  static const double borderRadius = 12.0;
  
  // Animation Duration
  static const Duration animationDuration = Duration(milliseconds: 300);
  
  // Max lengths
  static const int maxTitleLength = 100;
  static const int maxContentLength = 50000;
}

class AppStrings {
  // Arabic Strings
  static const String ar = 'ar';
  static const String en = 'en';
  
  // Home Screen
  static const String homeTitle = 'ملاحظاتي';
  static const String noNotes = 'لا توجد ملاحظات';
  static const String noNotesDescription = 'ابدأ بإضافة أول ملاحظة لك';
  static const String searchHint = 'ابحث في الملاحظات...';
  
  // Add/Edit Screen
  static const String addNote = 'إضافة ملاحظة';
  static const String editNote = 'تعديل الملاحظة';
  static const String titleHint = 'العنوان';
  static const String contentHint = 'اكتب ملاحظتك هنا...';
  static const String save = 'حفظ';
  static const String cancel = 'إلغاء';
  
  // Validation
  static const String titleRequired = 'يرجى إدخال عنوان الملاحظة';
  static const String contentRequired = 'يرجى إدخال محتوى الملاحظة';
  
  // Delete Dialog
  static const String deleteTitle = 'حذف الملاحظة';
  static const String deleteMessage = 'هل أنت متأكد من حذف هذه الملاحظة؟';
  static const String delete = 'حذف';
  
  // Settings
  static const String settings = 'الإعدادات';
  static const String theme = 'المظهر';
  static const String darkMode = 'الوضع الداكن';
  static const String lightMode = 'الوضع الفاتح';
  static const String language = 'اللغة';
  static const String about = 'عن التطبيق';
  static const String version = 'الإصدار';
  
  // Messages
  static const String noteSaved = 'تم حفظ الملاحظة بنجاح';
  static const String noteDeleted = 'تم حذف الملاحظة بنجاح';
  static const String noteUpdated = 'تم تحديث الملاحظة بنجاح';
}
