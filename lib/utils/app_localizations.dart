import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      // App Info
      'app_name': 'MNote',
      'app_description': 'Save your thoughts and notes securely and easily',

      // Home Screen
      'my_notes': 'My Notes',
      'no_notes': 'No notes',
      'no_notes_desc': 'Start by adding your first note',
      'add_note': 'Add Note',
      'search': 'Search in notes...',
      'search_close': 'Close Search',
      'all_notes': 'All Notes',
      'categories': 'Categories',
      'favorites': 'Favorites',

      // Add/Edit Screen
      'edit_note': 'Edit Note',
      'title': 'Title',
      'enter_title': 'Enter title',
      'content': 'Content',
      'enter_content': 'Write your note here...',
      'save': 'Save',
      'saving': 'Saving...',
      'title_required': 'Please enter note title',
      'title_min_length': 'Title must be at least 3 characters',
      'title_max_length': 'Title cannot exceed',
      'content_required': 'Please enter note content',
      'content_min_length': 'Content must be at least 3 characters',

      // Actions
      'cancel': 'Cancel',
      'delete': 'Delete',
      'delete_title': 'Delete Note',
      'delete_message': 'Are you sure you want to delete this note?',
      'delete_notes_title': 'Delete Notes',
      'delete_notes_message': 'notes?',
      'note_deleted': 'Note deleted successfully',
      'notes_deleted': 'Selected notes deleted',
      'note_saved': 'Note saved successfully',
      'note_updated': 'Note updated successfully',

      // Selection
      'select_all': 'Select All',
      'selection_count': 'selected',
      'delete_selected': 'Delete Selected',
      'close_selection': 'Cancel',

      // Settings
      'settings': 'Settings',
      'theme': 'Theme',
      'dark_mode': 'Dark Mode',
      'light_mode': 'Light Mode',
      'theme_enabled': 'Enabled',
      'theme_disabled': 'Disabled',
      'language': 'Language',
      'current_language': 'Current Language',
      'about': 'About',
      'version': 'Version',
      'features': 'Features',

      // Features List (6 Simple Features)
      'feature_1': 'Save your ideas quickly',
      'feature_2': 'Organize them in colored groups',
      'feature_3': 'Star the important ones',
      'feature_4': 'Search easily',
      'feature_5': 'Use it day or night',
      'feature_6': 'In Arabic or English',

      // Menu
      'more': 'More',

      // Tooltips
      'tooltip_search': 'Search',
      'tooltip_select_all': 'Select All',
      'tooltip_delete': 'Delete',
      'tooltip_cancel': 'Cancel',

      // Categories
      'no_categories': 'No categories',
      'no_categories_desc': 'Create your first category',
      'add_category': 'Add Category',
      'category_name': 'Category Name',
      'choose_icon': 'Choose Icon',
      'choose_color': 'Choose Color',
      'notes_count': 'notes',
      'category_deleted': 'Category deleted',
      'delete_categories_title': 'Delete Categories',
      'delete_categories_message': 'categories',
      'categories_deleted': 'Selected categories deleted',
      'delete_category_title': 'Delete Category',
      'delete_category_message': 'Are you sure you want to delete',
      'delete_category_warning': 'The category will be removed from all notes.',
      'category': 'Category',
      'no_category': 'No Category',
      'add_notes_to_category': 'Add Notes',
      'select_notes_to_add': 'Select notes to add',
      'no_notes_to_add': 'All notes are already in this category',
      'notes_added_to_category': 'Notes added:',
      'note_removed_from_category': 'Note removed from category',
      'no_notes_in_category': 'No notes in this category',
      'tap_to_add_notes': 'Tap + to add existing notes',

      // Default Categories
      'category_work': 'Work',
      'category_study': 'Study',
      'category_personal': 'Personal',
      'category_ideas': 'Ideas',

      // Favorites
      'no_favorites': 'No favorites',
      'no_favorites_desc': 'Star your important notes',
      'removed_from_favorites': 'Removed from favorites',
      'added_to_favorites': 'Added to favorites',

      // General
      'add': 'Add',
      'error': 'Error',
      'press_again_to_exit': 'Press back again to exit',
    },
    'ar': {
      // معلومات التطبيق
      'app_name': 'MNote',
      'app_description': 'احفظ أفكارك وملاحظاتك بأمان وسهولة',

      // الشاشة الرئيسية
      'my_notes': 'ملاحظاتي',
      'no_notes': 'لا توجد ملاحظات',
      'no_notes_desc': 'ابدأ بإضافة أول ملاحظة لك',
      'add_note': 'إضافة ملاحظة',
      'search': 'ابحث في الملاحظات...',
      'search_close': 'إغلاق البحث',
      'all_notes': 'كل الملاحظات',
      'categories': 'المجموعات',
      'favorites': 'المفضلة',

      // شاشة الإضافة/التعديل
      'edit_note': 'تعديل الملاحظة',
      'title': 'العنوان',
      'enter_title': 'أدخل العنوان',
      'content': 'المحتوى',
      'enter_content': 'اكتب ملاحظتك هنا...',
      'save': 'حفظ',
      'saving': 'جاري الحفظ...',
      'title_required': 'يرجى إدخال عنوان الملاحظة',
      'title_min_length': 'العنوان يجب أن يكون 3 أحرف على الأقل',
      'title_max_length': 'العنوان لا يمكن أن يتجاوز',
      'content_required': 'يرجى إدخال محتوى الملاحظة',
      'content_min_length': 'المحتوى يجب أن يكون 3 أحرف على الأقل',

      // الإجراءات
      'cancel': 'إلغاء',
      'delete': 'حذف',
      'delete_title': 'حذف الملاحظة',
      'delete_message': 'هل أنت متأكد من حذف هذه الملاحظة؟',
      'delete_notes_title': 'حذف الملاحظات',
      'delete_notes_message': 'ملاحظة؟',
      'note_deleted': 'تم حذف الملاحظة بنجاح',
      'notes_deleted': 'تم حذف الملاحظات المحددة',
      'note_saved': 'تم حفظ الملاحظة بنجاح',
      'note_updated': 'تم تحديث الملاحظة بنجاح',

      // التحديد
      'select_all': 'تحديد الكل',
      'selection_count': 'محدد',
      'delete_selected': 'حذف المحدد',
      'close_selection': 'إلغاء',

      // الإعدادات
      'settings': 'الإعدادات',
      'theme': 'المظهر',
      'dark_mode': 'الوضع الداكن',
      'light_mode': 'الوضع الفاتح',
      'theme_enabled': 'مفعّل',
      'theme_disabled': 'غير مفعّل',
      'language': 'اللغة',
      'current_language': 'اللغة الحالية',
      'about': 'عن التطبيق',
      'version': 'الإصدار',
      'features': 'المميزات',

      // قائمة المميزات (6 ميزات بسيطة)
      'feature_1': 'احفظ أفكارك بسرعة',
      'feature_2': 'نظّمها في مجموعات ملونة',
      'feature_3': 'ضع نجمة على المهم',
      'feature_4': 'ابحث عنها بسهولة',
      'feature_5': 'استخدمه ليلاً أو نهاراً',
      'feature_6': 'بالعربي أو الإنجليزي',

      // القائمة
      'more': 'المزيد',

      // التلميحات
      'tooltip_search': 'بحث',
      'tooltip_select_all': 'تحديد الكل',
      'tooltip_delete': 'حذف',
      'tooltip_cancel': 'إلغاء',

      // المجموعات
      'no_categories': 'لا توجد مجموعات',
      'no_categories_desc': 'أنشئ أول مجموعة لك',
      'add_category': 'إضافة مجموعة',
      'category_name': 'اسم المجموعة',
      'choose_icon': 'اختر الأيقونة',
      'choose_color': 'اختر اللون',
      'notes_count': 'ملاحظة',
      'category_deleted': 'تم حذف المجموعة',
      'delete_categories_title': 'حذف المجموعات',
      'delete_categories_message': 'مجموعة',
      'categories_deleted': 'تم حذف المجموعات المحددة',
      'delete_category_title': 'حذف المجموعة',
      'delete_category_message': 'هل أنت متأكد من حذف',
      'delete_category_warning': 'سيتم إزالة المجموعة من جميع الملاحظات.',
      'category': 'المجموعة',
      'no_category': 'بدون مجموعة',
      'add_notes_to_category': 'إضافة ملاحظات',
      'select_notes_to_add': 'اختر الملاحظات لإضافتها',
      'no_notes_to_add': 'جميع الملاحظات موجودة في هذه المجموعة',
      'notes_added_to_category': 'تمت إضافة:',
      'note_removed_from_category': 'تمت إزالة الملاحظة من المجموعة',
      'no_notes_in_category': 'لا توجد ملاحظات في هذه المجموعة',
      'tap_to_add_notes': 'اضغط + لإضافة ملاحظات موجودة',

      // الفئات الافتراضية
      'category_work': 'عمل',
      'category_study': 'دراسة',
      'category_personal': 'شخصي',
      'category_ideas': 'أفكار',

      // المفضلة
      'no_favorites': 'لا توجد مفضلة',
      'no_favorites_desc': 'ضع نجمة على ملاحظاتك المهمة',
      'removed_from_favorites': 'تمت الإزالة من المفضلة',
      'added_to_favorites': 'تمت الإضافة للمفضلة',

      // عام
      'add': 'إضافة',
      'error': 'خطأ',
      'press_again_to_exit': 'اضغط مرة أخرى للخروج',
    },
  };

  String translate(String key) {
    return _localizedValues[locale.languageCode]?[key] ?? key;
  }
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'ar'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}