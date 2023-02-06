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

  final homeSceenFilter = ["Creation", "Normal"].obs;
  var filterRefresh = "".obs;

  var commentListData = [].obs;
  var isCommetsLoaded = false.obs;

  String? editableTopicTitle;
  String? editableTopicBody;
  int editableTopicId = 0;

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

const List<String> itemsText = [
  "LastComment",
  "Creation",
  "NR Comments",
  "NR Votes",
  "Author",
  // "Tiny",
  // "Brief",
  // "Normal",
  // "Long",
  // "Full"
];

void sortListTopicData(List<String> filterData) {
  if (filterData[0] == "LastComment") {
    topicWidgetDataList.sort(
      (a, b) {
        int first = a.lastCommentAdded ?? a.added;
        int second = b.lastCommentAdded ?? b.added;
        return first.compareTo(second);
      },
    );
  } else if (filterData[0] == "NR Votes") {
    topicWidgetDataList.sort(
      (a, b) {
        return b.votes.compareTo(a.votes);
      },
    );
  } else if (filterData[0] == "NR Comments") {
    topicWidgetDataList.sort(
      (a, b) {
        return b.commentsNum.compareTo(a.commentsNum);
      },
    );
  } else if (filterData[0] == "Creation") {
    topicWidgetDataList.sort(
      (a, b) {
        return b.added.compareTo(a.added);
      },
    );
  } else {
    topicWidgetDataList.sort(
      (a, b) {
        return b.topicCreatorUserName[0].compareTo(a.topicCreatorUserName[0]);
      },
    );
  }
}

enum EditingButtons {
  bold,
  italic,
  link,
  strikeOut,
  underLine,
  heading,
  orderedList,
  unOrderredList,
  quotes
}
