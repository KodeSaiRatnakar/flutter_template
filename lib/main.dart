import 'package:flutter/material.dart';
import 'package:flutter_template/controllers/common.dart';
import 'package:flutter_template/controllers/theme.dart';
import 'package:flutter_template/controllers/zeronet.dart';
import 'package:flutter_template/screens/add_topic.dart';
import 'package:get/get.dart';

import 'controllers/site_ui.dart';
import 'screens/home_screen.dart';
import 'screens/topic_details.dart';

const siteAddr = String.fromEnvironment(
  'SITE_ADDR',
  defaultValue: '1CWBVU1aQfgyeC4FULaJvkaxCUvzmfdNEH',
);
int index = 0;

void main() async {
  await init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sample ZeroNet Site',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        switch (uiController.currentRoute.value) {
          case Routes.showProgressIndicator:
            return Scaffold(
              backgroundColor:
                  threadItThemeController.currentTheme.value.backGroundColor,
              body: const Center(child: CircularProgressIndicator()),
            );
          case Routes.home:
            return const HomePage();
          case Routes.topicDetailScreen:
            return TopicDetailScreen(
              topic: topicWidgetDataList[uiController.selectedTopicIndex.value],
            );
          case Routes.addTopicData:
            return AddTopicData(
              body: uiController.editableTopicBody,
              title: uiController.editableTopicTitle,
            );
          default:
            return Container();
        }
      },
    );
  }
}
