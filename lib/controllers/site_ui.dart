import 'package:flutter/material.dart';
import 'package:flutter_template/controllers/zeronet.dart';
import 'package:get/get.dart';

final uiController = Get.put(UiController());

class UiController extends GetxController {
  final searchStr = "".obs;
  final currentRoute = Routes.home.obs;
  final isSearchBarSelected = false.obs;
  final selectedTopicIndex = 0.obs;
  final listSorting = ListSorting.home.obs;
  final dropdownvalue = "General".obs;
  var searchController = Rx(TextEditingController());

  var filterRefresh = "".obs;
  var siteFilter1 = SiteFilters.creation.obs;
  var siteFilter2 = SiteFilters.normal.obs;

  var commentListData = [].obs;
  var isCommetsLoaded = false.obs;

  String? editableTopicTitle;
  String? editableTopicBody;
  int editableTopicId = 0;

  final markDownStr = ''.obs;

  void changeRoute(Routes route) {
    currentRoute.value = route;
  }

  void changeListSorting(ListSorting value) {
    listSorting.value = value;
  }
}

enum Routes {
  home,
  topicList,
  topicView,
  topicDetailScreen,
  showProgressIndicator,
  addTopicData,
}

enum ListSorting {
  home,
  features,
  bugs,
}

extension ListSortExt on ListSorting {
  String get pathString {
    switch (this) {
      case ListSorting.features:
        return "Home,Features";
      case ListSorting.bugs:
        return "Home,Bugs";
      default:
        return "Home, ";
    }
  }
}

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
