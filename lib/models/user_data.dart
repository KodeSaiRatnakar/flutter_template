class Topic {
  final int topicId;
  final String title;
  final String body;
  final int added;
  const Topic(
      {required this.topicId,
      required this.title,
      required this.body,
      required this.added});
  factory Topic.fromJson(dynamic json) {
    return Topic(
        topicId: json['topic_id'],
        title: json['title'],
        body: json['body'],
        added: json['added']);
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
  Comment({required this.commentId, required this.added, required this.body});

  factory Comment.fromJson(dynamic json) {
    return Comment(
        commentId: json['comment_id'],
        added: json['added'],
        body: json['body']);
  }

  Map toMap() {
    return {"comment_id": commentId, "body": body, "added": added};
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
      topicList.add(
        Topic.fromJson(topic),
      );
    }

    for (var commentKey in Map.from(json["comment"]).keys) {
      commentData[commentKey] = List<Comment>.from(
        json["comment"][commentKey]
            .map(
              (obj) => Comment.fromJson(obj),
            )
            .toList(),
      );
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
}
