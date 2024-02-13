import 'package:intl/intl.dart';

class UtilService {
  String timeConverter(time) {
    // Parse the string to a DateTime object (assuming it represents a time)
    String timeString = time;
    DateTime dateTime = DateFormat('HH:mm:ss').parse(timeString);

    // Format the DateTime object as "h:mm a" (e.g., "12:42 PM")
    String formattedTime = DateFormat('h:mm a').format(dateTime);
    return formattedTime;
  }
}
