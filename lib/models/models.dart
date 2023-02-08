import '../imports.dart';

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
      json['votes'] - 1,
      json['sticky'] as int,
      json['comments_num'] as int,
      json['last_comment'] as int?,
      json['last_added'] as int,
      json['last_action'] as int,
    );
  }

  factory TopicWidgetData.whenUserAddTopic(dynamic json) {
    return TopicWidgetData(
      json["topic_id"],
      json["title"],
      json["body"],
      json["added"],
      json["type"],
      json["parent_topic_uri"],
      json["json_id"],
      json["topic_creator_user_name"],
      json["topic_creator_address"],
      json["row_topic_uri"],
      null,
      null,
      null,
      0,
      0,
      0,
      0,
      0,
      0,
    );
  }
}

class CommentWidgetData {
  final String commentBody;
  final int commentId;
  final String topicUri;
  final int commentAdded;
  final int? modified;
  final String userAddress;
  final String userName;
  int votes;

  CommentWidgetData({
    required this.commentAdded,
    required this.commentBody,
    required this.commentId,
    required this.topicUri,
    required this.userAddress,
    required this.userName,
    required this.votes,
    this.modified,
  });

  factory CommentWidgetData.fromJson(dynamic json) {
    return CommentWidgetData(
      commentAdded: json["added"],
      commentBody: json["body"],
      commentId: json["comment_id"],
      topicUri: json["topic_uri"],
      modified: json["modified"],
      userAddress: json["user_address"],
      userName: json["user_name"],
      votes: json["votes"] - 1,
    );
  }
}
