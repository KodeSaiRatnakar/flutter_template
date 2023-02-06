import '../controllers/zeronet.dart';

class Topic {
  final int topicId;
  String title;
  String body;
  final int added;
  Topic({
    required this.topicId,
    required this.title,
    required this.body,
    required this.added,
  });
  factory Topic.fromJson(dynamic json) {
    try {
      return Topic(
        topicId: json['topic_id'],
        title: json['title'],
        body: json.containsKey('body') ? json['body'] : "",
        added: json['added'],
      );
    } catch (e) {
      throw "Invalid Topic Data";
    }
  }

  Map toMap() {
    Map<String, dynamic> topicData = {
      "topic_id": topicId,
      "title": title,
      "body": body,
      "added": added
    };
    return topicData;
  }
}

class Comment {
  int commentId;
  int added;
  String body;
  Comment({
    required this.commentId,
    required this.added,
    required this.body,
  });

  factory Comment.fromJson(dynamic json) {
    try {
      return Comment(
        commentId: json['comment_id'],
        added: json['added'],
        body: json['body'],
      );
    } catch (e) {
      throw "Invalid Comment Data";
    }
  }

  Map toMap() {
    return {
      "comment_id": commentId,
      "body": body,
      "added": added,
    };
  }
}

class UserData {
  int nextTopicId;
  int nextCommentId;
  List<Topic> userTopics;
  Map<String, List<Comment>> userComments;
  Map<String, int> topicVote;
  Map<String, int> commentVote;

  UserData({
    required this.nextTopicId,
    required this.nextCommentId,
    required this.userTopics,
    required this.commentVote,
    required this.topicVote,
    required this.userComments,
  });

  factory UserData.fromJson(dynamic json) {
    List<Topic> topicList = [];
    Map<String, List<Comment>> commentData = {};

    for (var topic in json["topic"]) {
      try {
        var topic2 = Topic.fromJson(topic);
        topicList.add(topic2);
      } catch (e) {
        // todo this case
      }
    }

    for (var commentKey in Map.from(json["comment"]).keys) {
      List<Comment> commentsList = [];
      for (var commentObj in json["comment"][commentKey]) {
        try {
          commentsList.add(Comment.fromJson(commentObj));
        } catch (e) {
          // todo handle this case
        }
      }
      commentData[commentKey] = commentsList;
      commentsList.clear();
      //   json["comment"][commentKey]
      //       .map(
      //         (obj) => Comment.fromJson(obj),
      //       )
      //       .toList(),);
    }

    return UserData(
      nextTopicId: json["next_topic_id"],
      nextCommentId: json["next_comment_id"],
      userTopics: topicList,
      commentVote: Map<String, int>.from(json["comment_vote"] ?? {}),
      topicVote: Map<String, int>.from(json["topic_vote"] ?? {}),
      userComments: commentData,
    );
  }

  Map toMap() {
    Map<String, Iterable> commentMap = {};

    for (var key in userComments.keys) {
      commentMap[key] = userComments[key]!.map((obj) => obj.toMap()).toList();
    }

    Map map = {
      "next_topic_id": nextTopicId,
      "topic": userTopics.map((obj) => obj.toMap()).toList(),
      "topic_vote": topicVote,
      "next_comment_id": nextCommentId,
      "comment": commentMap,
      "comment_vote": commentVote
    };

    return map;
  }

  factory UserData.def() {
    return UserData(
      nextTopicId: 1,
      nextCommentId: 1,
      userTopics: [],
      commentVote: {},
      topicVote: {},
      userComments: {},
    );
  }
}

class EditUserData {
  static void editTopic(
      {required String title, required String body, required topicId}) {
    UserData userData = zeroNetController.userDataObj;
    int index = userData.userTopics.indexWhere((obj) => obj.topicId == topicId);
    userData.userTopics[index].title = title;
    userData.userTopics[index].body = body;

    int topicWidgetDataIndex =
        topicWidgetDataList.indexWhere((obj) => obj.topicId == topicId);

    topicWidgetDataList[topicWidgetDataIndex].title = title;
    topicWidgetDataList[topicWidgetDataIndex].body = body;
    zeroNetController.saveUserData();
  }

  static void deleteTopic({required int topicId}) {
    UserData userData = zeroNetController.userDataObj;
    userData.userTopics.removeWhere((obj) => obj.topicId == topicId);
    topicWidgetDataList.removeWhere((obj) => obj.topicId == topicId);
    zeroNetController.saveUserData();
  }
}
