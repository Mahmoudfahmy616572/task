import 'package:intl/intl.dart';

abstract final class AppLocalizations {
  static String get addComment => Intl.message('Add a comment...', name: 'addComment');
  static String get likes => Intl.message('likes', name: 'likes');
  static String get comments => Intl.message('comments', name: 'comments');
  static String get retry => Intl.message('Retry', name: 'retry');
  static String get download => Intl.message('Download', name: 'download');
  static String get saved => Intl.message('Image saved', name: 'saved');

  static const Map<String, Map<String, String>> _localized = {
    'en': {
      'addComment': 'Add a comment...',
      'likes': 'likes',
      'comments': 'comments',
      'retry': 'Retry',
      'download': 'Download',
      'saved': 'Image saved',
    },
    'ar': {
      'addComment': 'أضف تعليقاً...',
      'likes': 'إعجاب',
      'comments': 'تعليقات',
      'retry': 'إعادة المحاولة',
      'download': 'تحميل',
      'saved': 'تم حفظ الصورة',
    },
  };

  static String get(String key, String locale) {
    return _localized[locale]?[key] ?? _localized['en']![key]!;
  }
}
