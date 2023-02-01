import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_template/controllers/commons.dart';
import 'package:flutter_template/controllers/themeControlle.dart';
import 'package:flutter_template/controllers/zeronet.dart';
import 'package:flutter_template/screens/add_topic.dart';
import 'package:get/get.dart';

import 'controllers/ui_controller.dart';
import 'screens/homeScreen.dart';
import 'screens/topicDetail.dart';

const siteAddr = String.fromEnvironment(
  'SITE_ADDR',
  defaultValue: '15UYrA7aXr2Nto1Gg4yWXpY3EAJwafMTNk',
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
              return AddTopicData();
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
