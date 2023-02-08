import '../imports.dart';

Future<void> init() async {
  await zeroNetController.connect();
  await zeroNetController.loadTopicWidgetData();
  await zeroNetController.getSiteInfo();
}
