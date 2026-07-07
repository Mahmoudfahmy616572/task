import 'package:intl/intl.dart';

abstract final class AppLocalizations {
  static String get addComment => Intl.message('Add a comment...', name: 'addComment');
  static String get likes => Intl.message('likes', name: 'likes');
  static String get comments => Intl.message('comments', name: 'comments');
  static String get retry => Intl.message('Retry', name: 'retry');
  static String get download => Intl.message('Download', name: 'download');
  static String get saved => Intl.message('Image saved', name: 'saved');
  static String get now => Intl.message('Just now', name: 'now');
  static String get reply => Intl.message('Reply', name: 'reply');
  static String get commentsTitle => Intl.message('Comments', name: 'commentsTitle');

  static String minutesAgo(int n) => Intl.plural(n,
      zero: '0 minutes ago', one: '1 minute ago', other: '$n minutes ago',
      name: 'minutesAgo');
  static String hoursAgo(int n) => Intl.plural(n,
      zero: '0 hours ago', one: '1 hour ago', other: '$n hours ago',
      name: 'hoursAgo');
  static String daysAgo(int n) => Intl.plural(n,
      zero: '0 days ago', one: '1 day ago', other: '$n days ago',
      name: 'daysAgo');

  static String replyingTo(String username) =>
      Intl.message('Reply to @$username', name: 'replyingTo');

  static const Map<String, Map<String, String>> _localized = {
    'en': {
      'addComment': 'Add a comment...',
      'postTitle': 'Post',
      'likes': 'likes',
      'comments': 'comments',
      'retry': 'Retry',
      'download': 'Download',
      'saved': 'Image saved',
      'public': 'Public',
      'private': 'Private',
      'now': 'Just now',
      'reply': 'Reply',
      'commentsTitle': 'Comments',
      'replyingTo': 'Reply to @%s',
      'minutesAgo': '%d min ago',
      'hoursAgo': '%d hr ago',
      'daysAgo': '%d days ago',
    },
    'ar': {
      'addComment': 'أضف تعليقاً...',
      'postTitle': 'المنشور',
      'likes': 'إعجاب',
      'comments': 'تعليقات',
      'retry': 'إعادة المحاولة',
      'download': 'تحميل',
      'saved': 'تم حفظ الصورة',
      'public': 'عام',
      'private': 'خاص',
      'now': 'الآن',
      'reply': 'رد',
      'commentsTitle': 'التعليقات',
      'replyingTo': 'الرد على @%s',
      'minutesAgo': 'منذ %d د',
      'hoursAgo': 'منذ %d س',
      'daysAgo': 'منذ %d ي',
    },
  };

  static String get(String key, String locale) {
    return _localized[locale]?[key] ?? _localized['en']![key]!;
  }
}
