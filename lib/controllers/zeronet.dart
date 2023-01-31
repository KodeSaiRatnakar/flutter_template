import 'package:flutter/material.dart';
import 'package:flutter_template/consts.dart';
import 'package:flutter_template/main.dart';
import 'package:get/get.dart';
import 'package:zeronet_ws/zeronet_ws.dart';

final zeroNetController = Get.put(ZeroNetController());
final uiController = Get.put(UiController());
List<TopicWidgetData> topicWidgetDataList = [];

class ZeroNetController extends GetxController {
  late ZeroNet instance;
  ZeroNetController() {
    instance = ZeroNet.instance;
  }

  Future<void> connect() async {
    await instance.connect(siteAddr);
  }

  Future loadTopicWidgetData({String? id}) async {
    uiController.currentRoute.value = Routes.showProgressIndicator;
    topicWidgetDataList.clear();

    var queryResult = await instance.dbQueryFuture(
      topicListQuery(parentTopicUri: id),
    );
    if (queryResult.isMsg) {
      for (var topic in queryResult.message!.result) {
        topicWidgetDataList.add(
          TopicWidgetData.fromJson(topic),
        );
      }
      uiController.currentRoute.value = Routes.home;
    }
  }
}

class UiController extends GetxController {
  final searchStr = "".obs;
  final currentRoute = Routes.home.obs;
  final isSearchBarSelected = false.obs;
  final selectedTopicIndex = 0.obs;
  final listSorting = ListSorting.home.obs;
  final dropdownvalue = "General".obs;
  var searchController = Rx(TextEditingController());

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
