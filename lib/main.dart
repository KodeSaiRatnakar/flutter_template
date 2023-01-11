import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_template/controllers/commons.dart';
import 'package:flutter_template/controllers/themeControlle.dart';
import 'package:flutter_template/controllers/zeronet.dart';
import 'package:flutter_template/screens/add_topic.dart';
import 'package:get/get.dart';

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

class TopicWidgetData extends Equatable {
  int topicId;
  String title;
  String body;
  dynamic type;
  String? parentTopicUri;
  int added;
  int jsonId;
  String topicCreatorUserName;
  String topicCreatorAddress;
  String rowTopicUri;
  String? rowTopicSubUri;
  String? rowTopicSubTitle;
  String? rowTopicSubType;
  int votes;
  int sticky;
  int commentsNum;
  int? lastCommentAdded;
  int lastAdded;
  int lastAction;

  TopicWidgetData(
    this.topicId,
    this.title,
    this.body,
    this.added,
    this.type,
    this.parentTopicUri,
    this.jsonId,
    this.topicCreatorUserName,
    this.topicCreatorAddress,
    this.rowTopicUri,
    this.rowTopicSubUri,
    this.rowTopicSubTitle,
    this.rowTopicSubType,
    this.votes,
    this.sticky,
    this.commentsNum,
    this.lastCommentAdded,
    this.lastAdded,
    this.lastAction,
  );

  @override
  List<Object?> get props => [
        topicId,
        title,
        added,
        rowTopicSubUri,
        topicCreatorUserName,
        topicCreatorAddress,
      ];

  static TopicWidgetData fromJson(Map<String, dynamic> json) {
    return TopicWidgetData(
      json['topic_id'] as int,
      json['title'] as String,
      json['body'] as String,
      json['added'] as int,
      json['type'],
      json['parent_topic_uri'] as String?,
      json['json_id'] as int,
      json['topic_creator_user_name'] as String,
      json['topic_creator_address'] as String,
      json['row_topic_uri'] as String,
      json['row_topic_sub_uri'] as String?,
      json['row_topic_sub_title'] as String?,
      json['row_topic_sub_type'] as String?,
      json['votes'] as int,
      json['sticky'] as int,
      json['comments_num'] as int,
      json['last_comment'] as int?,
      json['last_added'] as int,
      json['last_action'] as int,
    );
  }
}
