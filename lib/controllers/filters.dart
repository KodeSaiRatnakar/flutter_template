import '../imports.dart';

enum SiteFilters {
  lastComment,
  creation,
  nrComments,
  nrVotes,
  author,
  tiny,
  brief,
  normal,
  long,
  full
}

extension SiteFiltersExt on SiteFilters {
  String get filterStr {
    switch (this) {
      case SiteFilters.lastComment:
        return "LastComment";
      case SiteFilters.creation:
        return "Creation";
      case SiteFilters.nrComments:
        return "NR Comments";
      case SiteFilters.nrVotes:
        return "NR Votes";
      case SiteFilters.author:
        return "Author";
      case SiteFilters.tiny:
        return "Tiny";
      case SiteFilters.brief:
        return "Brief";
      case SiteFilters.normal:
        return "Normal";
      case SiteFilters.long:
        return "Long";
      case SiteFilters.full:
        return "Full";
    }
  }
}

void sortListTopicData() {
  switch (uiController.siteFilter1.value) {
    case SiteFilters.lastComment:
      topicWidgetDataList.sort(
        (a, b) {
          int first = a.lastCommentAdded ?? a.added;
          int second = b.lastCommentAdded ?? b.added;
          return first.compareTo(second);
        },
      );
      break;
    case SiteFilters.creation:
      topicWidgetDataList.sort(
        (a, b) {
          return b.added.compareTo(a.added);
        },
      );
      break;
    case SiteFilters.nrComments:
      topicWidgetDataList.sort(
        (a, b) {
          return b.commentsNum.compareTo(a.commentsNum);
        },
      );
      break;
    case SiteFilters.nrVotes:
      topicWidgetDataList.sort(
        (a, b) {
          return b.votes.compareTo(a.votes);
        },
      );
      break;
    case SiteFilters.author:
      // TODO: Handle this case.
      break;
    case SiteFilters.tiny:
      // TODO: Handle this case.
      break;
    case SiteFilters.brief:
      // TODO: Handle this case.
      break;
    case SiteFilters.normal:
      // TODO: Handle this case.
      break;
    case SiteFilters.long:
      // TODO: Handle this case.
      break;
    case SiteFilters.full:
      // TODO: Handle this case.
      break;
  }
}
