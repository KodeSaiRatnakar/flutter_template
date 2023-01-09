extension intExt on int {
  DateTime get toDate {
    return DateTime.fromMillisecondsSinceEpoch(this);
  }

  String get monthString {
    List<String> monthStrings = const [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec"
    ];
    return monthStrings[this - 1];
  }

  String get modifiedStrForComment {
    final present = toDate;

    if (DateTime.now().difference(present).inHours >= 24) {
      return "last on ${present.month.monthString} ${present.day}, ${present.year}";
    } else if (DateTime.now().difference(present).inMinutes >= 60) {
      return "last on ${DateTime.now().difference(present).inHours} hr ago";
    }
    return "last on ${DateTime.now().difference(present).inMinutes} min ago";
  }

  String get modifiedStr {
    final present = toDate;

    if (DateTime.now().difference(present).inHours >= 24) {
      return "last on ${present.month.monthString} ${present.day}, ${present.year}";
    } else if (DateTime.now().difference(present).inMinutes >= 60) {
      return "(modified on ${DateTime.now().difference(present).inHours} hr ago)";
    }
    return "(modified on ${DateTime.now().difference(present).inMinutes} min ago)";
  }

  String get modifiedStrForAdmin {
    final present = toDate;

    if (DateTime.now().difference(present).inHours >= 24) {
      return "(modified on ${present.month.monthString} ${present.day}, ${present.year})";
    } else if (DateTime.now().difference(present).inMinutes >= 60) {
      return "(modified on ${DateTime.now().difference(present).inHours} hr ago)";
    }
    return "(modified on ${DateTime.now().difference(present).inMinutes} min ago)";
  }

  String get numDatetoStringDate {
    final present = toDate;

    return "${present.month.monthString} ${present.day}, ${present.year}";
  }
}
