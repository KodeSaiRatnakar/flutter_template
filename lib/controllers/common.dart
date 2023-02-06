import 'package:flutter_template/controllers/zeronet.dart';

Future<void> init() async {
  await zeroNetController.connect();
  await zeroNetController.loadTopicWidgetData();
  await zeroNetController.callSiteInfo();
}
