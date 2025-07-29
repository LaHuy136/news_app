 import 'package:intl/intl.dart';

String formatTimeAgo(String? pubDate) {
      if (pubDate == null) return '';

      try {
        final format = DateFormat("EEE, dd MMM yyyy HH:mm:ss Z", "en_US");
        final date = format.parse(pubDate).toLocal();

        final now = DateTime.now();
        final today = DateTime(now.year, now.month, now.day);
        final pubDay = DateTime(date.year, date.month, date.day);

        if (today == pubDay) {
          final diff = now.difference(date);
          if (diff.inMinutes < 60) {
            return '${diff.inMinutes} phút trước';
          } else {
            return '${diff.inHours} giờ trước';
          }
        } else {
          return DateFormat('dd/MM/yyyy').format(date);
        }
      } catch (e) {
        return '';
      }
    }