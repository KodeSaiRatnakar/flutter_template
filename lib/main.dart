import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_template/controllers/commons.dart';
import 'package:flutter_template/controllers/themeControlle.dart';
import 'package:flutter_template/controllers/zeronet.dart';
import 'package:flutter_template/screens/add_topic.dart';
import 'package:get/get.dart';

import 'controllers/ui_controller.dart';
import 'screens/home_screen.dart';
import 'screens/topicDetail.dart';

const siteAddress = "1CWBVU1aQfgyeC4FULaJvkaxCUvzmfdNEH";
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
              body: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          case Routes.home:
            {
              return HomePage();
            }
          case Routes.topicDetailScreen:
            {
              return TopicDetailScreen(
                  topic: topicWidgetDataList[
                      uiController.selectedTopicIndex.value]);
            }
          case Routes.addTopicData:
            {
              return AddTopicData(
                body: uiController.editableTopicBody,
                title: uiController.editableTopicTitle,
              );
            }
          default:
            {
              return Container();
            }
        }
      },
    );
  }
}
