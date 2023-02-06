import 'package:flutter/material.dart';
import 'package:super_editor/super_editor.dart';

import 'controllers/site_ui.dart';

extension IntExt on int {
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

extension EditingIcon on EditingButtons {
  IconData getEditingIcon() {
    switch (this) {
      case EditingButtons.bold:
        return Icons.format_bold_outlined;
      case EditingButtons.italic:
        return Icons.format_italic_outlined;
      case EditingButtons.link:
        return Icons.attachment;
      case EditingButtons.heading:
        return Icons.title;
      case EditingButtons.orderedList:
        return Icons.list;
      case EditingButtons.unOrderredList:
        return Icons.list;
      case EditingButtons.quotes:
        return Icons.format_quote;
      case EditingButtons.strikeOut:
        return Icons.strikethrough_s;
      case EditingButtons.underLine:
        return Icons.format_underline;
    }
  }

  NamedAttribution? get getAttribution {
    switch (this) {
      case EditingButtons.bold:
        return boldAttribution;
      case EditingButtons.italic:
        return italicsAttribution;
      case EditingButtons.link:
        return null;
      case EditingButtons.heading:
        return header1Attribution;
      case EditingButtons.orderedList:
        return null;
      case EditingButtons.unOrderredList:
        return null;
      case EditingButtons.quotes:
        return null;
      case EditingButtons.strikeOut:
        return strikethroughAttribution;
      case EditingButtons.underLine:
        return underlineAttribution;
    }
  }
}
