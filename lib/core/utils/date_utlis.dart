import 'package:intl/intl.dart';

class DateUtilsHelper {
  DateUtilsHelper._();

  // date formate 12 Aug 2025
  static String formatDate(DateTime dateTime) {
    return DateFormat('dd MMM yyyy').format(dateTime);
  }

  // date format 12 Aug 2025, 10:45 AM
  static String formatDateTime(DateTime dateTime) {
    return DateFormat('dd MMM yyyy, hh:mm a').format(dateTime);
  }

  // date format Aug 12, 2025
  static String formatReadable(DateTime dateTime) {
    return DateFormat('MMM dd, yyyy').format(dateTime);
  }

  /// format for Firebase Timestamp fallback
  static DateTime fromTimestamp(dynamic timestamp) {
    if (timestamp == null) {
      return DateTime.now();
    }

    try {
      return timestamp.toDate();
    } catch (_) {
      return DateTime.now();
    }
  }

  /// relative Time  "2 hours ago"
  static String timeAgo(DateTime dateTime) {
    final duration = DateTime.now().difference(dateTime);

    if (duration.inSeconds < 60) {
      return "Just now";
    } else if (duration.inMinutes < 60) {
      return "${duration.inMinutes} minutes ago";
    } else if (duration.inHours < 24) {
      return "${duration.inHours} hours ago";
    } else if (duration.inDays < 7) {
      return "${duration.inDays} days ago";
    } else {
      return formatDate(dateTime);
    }
  }
}
