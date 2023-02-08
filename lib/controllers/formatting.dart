import '../imports.dart';

enum EditingButtons {
  bold,
  italic,
  link,
  strikeOut,
  heading,
  unOrderredList,
  orderedList,
  quotes,
  underLine
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
