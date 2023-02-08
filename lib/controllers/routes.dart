import '../imports.dart';

enum Routes {
  kHome,
  kTopicList,
  kTopicView,
  kTopicDetailScreen,
  kShowProgressIndicator,
  kAddTopicData,
}

extension RoutesExt on Routes {
  Widget get routeWidget {
    switch (this) {
      case Routes.kShowProgressIndicator:
        return Scaffold(
          backgroundColor:
              threadItThemeController.currentTheme.value.backGroundColor,
          body: const Center(child: CircularProgressIndicator()),
        );
      case Routes.kHome:
        return const HomePage();
      case Routes.kTopicDetailScreen:
        return TopicDetailScreen(
          topic: topicWidgetDataList[uiController.selectedTopicIndex.value],
        );
      case Routes.kAddTopicData:
        return AddTopicData(
          body: uiController.editableTopicBody,
          title: uiController.editableTopicTitle,
        );
      default:
        return Container();
    }
  }
}
