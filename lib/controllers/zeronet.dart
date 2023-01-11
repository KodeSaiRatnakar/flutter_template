import 'package:flutter_template/consts.dart';
import 'package:flutter_template/main.dart';
import 'package:get/get.dart';

import 'package:zeronet_ws/models/models.dart';

import 'package:zeronet_ws/zeronet_ws.dart';

final zeroNetController = Get.put(ZeroNetController());
final uiController = Get.put(UiController());
List<TopicWidgetData> topicWidgetDataList = [];

class ZeroNetController extends GetxController {
  late ZeroNet instance;

  // var topicWidgetDataList = [].obs;

  ZeroNetController() {
    instance = ZeroNet.instance;
  }

  Future<void> connect() async {
    await instance.connect(siteAddr);
  }

  Future loadTopicWidgetData({String? id}) async {
    uiController.currentRoute.value = Routes.ShowProgressIndicator;
    topicWidgetDataList.clear();

    var queryResult =
        await instance.dbQueryFuture(topicListQuery(parent_topic_uri: id));
    if (queryResult.isMsg) {
      for (var topic in queryResult.message!.result) {
        topicWidgetDataList.add(TopicWidgetData.fromJson(topic));
      }
      uiController.currentRoute.value = Routes.Home;
    }
  }
}

class UiController extends GetxController {
  final searchStr = "".obs;
  final currentRoute = Routes.Home.obs;
  final isSearchBarSelected = false.obs;
  final selectedTopicIndex = 0.obs;
  final listSorting = ListSorting.Home.obs;

  void changeRoute(Routes route) {
    currentRoute.value = route;
  }

  void changeListSorting(ListSorting value) {
    listSorting.value = value;
  }
}

enum Routes {
  Home,
  TopicList,
  TopicView,
  TopicDetailScreen,
  ShowProgressIndicator,
  AddTopicData
}

enum ListSorting { Home, Features, Bugs }

extension ListSortExt on ListSorting {
  String get pathString {
    switch (this) {
      case ListSorting.Features:
        {
          return "Home,Features";
        }
      case ListSorting.Bugs:
        {
          return "Home,Bugs";
        }

      default:
        {
          return "Home, ";
        }
    }
  }
}

extension RouteExt on Routes {
  init() {
    switch (this) {
      case Routes.Home:
        {}
        break;
      case Routes.TopicList:
        {}
        break;
      case Routes.TopicView:
        {}
        break;
      case Routes.TopicDetailScreen:
        break;
      case Routes.ShowProgressIndicator:
        break;
    }
  }
}
