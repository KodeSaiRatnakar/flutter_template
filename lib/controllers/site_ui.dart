import '../imports.dart';

final uiController = Get.put(UiController());

class UiController extends GetxController {
  final searchStr = "".obs;
  final currentRoute = Routes.kHome.obs;
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
