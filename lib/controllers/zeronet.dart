import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:zeronet_ws/models/models.dart';
import '../consts.dart';
import '../models/user_data.dart';
import 'package:get/get.dart';
import '../models/models.dart';
import 'package:zeronet_ws/zeronet_ws.dart';
import '../main.dart';
import 'site_ui.dart';

final zeroNetController = Get.put(ZeroNetController());

List<TopicWidgetData> topicWidgetDataList = [];

class ZeroNetController extends GetxController {
  late ZeroNet instance;
  late SiteInfo siteInfo;
  late String userDataPath;
  late UserData userDataObj;
  static String userName = "TempUser";
  ZeroNetController() {
    instance = ZeroNet.instance;
  }

  Future<void> connect() async {
    await instance.connect(
      siteAddr,
    );
    await instance.channelJoinFuture(['siteChanged']);
  }

  void onMessage(message) {
    var msg = jsonDecode(message);

    var msg2 = msg['params'];
    if (msg2 is Map) {
      if (msg2['event'] is List) {
        final event = msg2['event'];

        final name = event[0];
        final param = event[1];

        if (name == 'file_done') {
          var path = param.toString();

          var pattern = 'data/users/';

          if (path.startsWith('${pattern}1') && path.endsWith('.json')) {
            debugPrint('User Data Changed');
            final userFile = path.replaceFirst(pattern, '');
            final dataOrContentJsonFile =
                userFile.replaceFirst(RegExp(r'1\w+'), '');

            if (dataOrContentJsonFile == "/data.json") {
              loadTopicWidgetData();
            }
          }
        } else {
          debugPrint('Event Message : $name :: $param');
        }
      } else if (msg['cmd'] == 'peerReceive') {
        // userDataController.addUserStatusListener(msg2);
      }
    } else {
      // debugPrint('Unknown Message');
      // print(msg);
    }
  }

  Future getSiteInfo() async {
    var siteInformation = await instance.siteInfoFuture();
    siteInfo = siteInformation;
    if (siteInfo.certUserId != null) {
      userDataPath = "data/users/${siteInfo.authAddress}";
    }
    await loadUserDirectory();
  }

  Future loadUserDirectory() async {
    var totalUsersFiles = await instance.fileListFuture("data/users");

    const String dataJson = '''
{
	"next_topic_id": 1,
	"topic": [],
	"topic_vote": {},
	"next_comment_id": 1,
	"comment": {},
	"comment_vote": {}
}''';

    final newUserContentJson = '''
{
  "address": "$siteAddr",
  "files": {},
  "inner_path": "data/users/${siteInfo.authAddress}/content.json",
  "modified": ${(DateTime.now().millisecondsSinceEpoch / 1000).ceil()},
  "signs": {"${siteInfo.authAddress}":""}
}''';

    final contentBase64Str = base64.encode(utf8.encode(newUserContentJson));

    final datajsonBase64Str = base64.encode(utf8.encode(dataJson));

    if (totalUsersFiles.isMsg) {
      List files = totalUsersFiles.message!.result as List;
      if (files.contains('${siteInfo.authAddress}/content.json') &&
          files.contains('${siteInfo.authAddress}/data.json')) {
        var userDataJson = await instance
            .fileGetFuture("data/users/${siteInfo.authAddress}/data.json");
        if (userDataJson.isMsg) {
          var result2 = userDataJson.message!.result;
          try {
            var decode = json.decode(result2);
            userDataObj = UserData.fromJson(decode);
          } catch (e) {
            // handle this case
            userDataObj = UserData.def();
          }
        } else {
          // handle this case
          userDataObj = UserData.def();
        }
      } else {
        await instance.fileWriteFuture(
          "data/users/${siteInfo.authAddress}/content.json",
          contentBase64Str,
        );
        await instance.fileWriteFuture(
          "data/users/${siteInfo.authAddress}/data.json",
          datajsonBase64Str,
        );
        userDataObj = UserData.def();
      }
    }
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

  Future loadDataForNormalOption() async {
    List<TopicWidgetData> topicWidgetData = [];

    var queryResult = await instance.dbQueryFuture(
      topicListQuery(),
    );
    if (queryResult.isMsg) {
      for (var topic in queryResult.message!.result) {
        topicWidgetData.add(
          TopicWidgetData.fromJson(topic),
        );
      }
      topicWidgetDataList.clear();
      topicWidgetDataList.addAll(topicWidgetData);
      topicWidgetData.clear();
      uiController.filterRefresh.value = DateTime.now().millisecond.toString();
    }
  }

  Future loadComments(String topicUri) async {
    List<CommentWidgetData> commentData = [];

    var queryResult = await instance.dbQueryFuture(
      commentsQueryString(topicUri),
    );
    if (queryResult.isMsg) {
      for (var topic in queryResult.message!.result) {
        commentData.add(CommentWidgetData.fromJson(topic));
      }
      uiController.commentListData.value.clear();
      uiController.commentListData.addAll(commentData);
    }
    uiController.isCommetsLoaded.value = true;
  }

  Future saveUserData() async {
    var userFile = await instance.fileWriteFuture(
      "data/users/${siteInfo.authAddress}/data.json",
      base64.encode(
        utf8.encode(
          json.encode(
            userDataObj.toMap(),
          ),
        ),
      ),
    );

    if (userFile.isMsg) {
      //print("success");
    } else {
      print(userFile.error);
    }
  }
}
