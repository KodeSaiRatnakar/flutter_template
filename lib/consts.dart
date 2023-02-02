import 'models/user_data.dart';

String bugsTopicId = "1627556797_12sCaEUFqE6g3JrDqmEA8pn9yrgxwkZQMe";
String featuresRequest = "1627666223_12sCaEUFqE6g3JrDqmEA8pn9yrgxwkZQMe";

String topicListQuery({
  String? parentTopicUri,
  int? limit = 30,
}) {
  const sql_sticky = '0 AS sticky';
  var where = '';

  if (parentTopicUri != null) {
    where =
        "WHERE parent_topic_uri = '$parentTopicUri' OR row_topic_uri = '$parentTopicUri'";
  } else {
    where = "WHERE topic.type IS NULL AND topic.parent_topic_uri IS NULL";
  }

  final dateFilter = DateTime.now().millisecondsSinceEpoch / (1000);
  var query = """SELECT
      COUNT(comment_id) AS comments_num, MAX(comment.added) AS last_comment, topic.added as last_added, CASE WHEN MAX(comment.added) IS NULL THEN topic.added ELSE MAX(comment.added) END as last_action,
      topic.*,
      topic_creator_user.value AS topic_creator_user_name,
      topic_creator_content.directory AS topic_creator_address,
      topic.topic_id || '_' || topic_creator_content.directory AS row_topic_uri,
      NULL AS row_topic_sub_uri, NULL AS row_topic_sub_title, NULL AS row_topic_sub_type,
      (SELECT COUNT(*) FROM topic_vote WHERE topic_vote.topic_uri = topic.topic_id || '_' || topic_creator_content.directory)+1 AS votes,
      $sql_sticky
			FROM topic
			LEFT JOIN json AS topic_creator_json ON (topic_creator_json.json_id = topic.json_id)
			LEFT JOIN json AS topic_creator_content ON (topic_creator_content.directory = topic_creator_json.directory AND topic_creator_content.file_name = 'content.json')
			LEFT JOIN keyvalue AS topic_creator_user ON (topic_creator_user.json_id = topic_creator_content.json_id AND topic_creator_user.key = 'cert_user_id')
			LEFT JOIN comment ON (comment.topic_uri = row_topic_uri AND comment.added < $dateFilter)
			$where
			GROUP BY topic.topic_id, topic.json_id
			HAVING last_action < $dateFilter""";
  if (parentTopicUri == null) {
    query += """
      UNION ALL
      SELECT
        COUNT(comment_id) AS comments_num, MAX(comment.added) AS last_comment,
        MAX(topic_sub.added) AS last_added,
        CASE WHEN MAX(topic_sub.added) > MAX(comment.added) OR MAX(comment.added) IS NULL THEN MAX(topic_sub.added) ELSE MAX(comment.added) END as last_action,
        topic.*,
        topic_creator_user.value AS topic_creator_user_name,
        topic_creator_content.directory AS topic_creator_address,
        topic.topic_id || '_' || topic_creator_content.directory AS row_topic_uri,
        topic_sub.topic_id || '_' || topic_sub_creator_content.directory AS row_topic_sub_uri,
        topic_sub.title AS row_topic_sub_title, topic_sub.type AS row_topic_sub_type,
        (SELECT COUNT(*) FROM topic_vote WHERE topic_vote.topic_uri = topic.topic_id || '_' || topic_creator_content.directory)+1 AS votes,
        $sql_sticky
      FROM topic
      LEFT JOIN json AS topic_creator_json ON (topic_creator_json.json_id = topic.json_id)
      LEFT JOIN json AS topic_creator_content ON (topic_creator_content.directory = topic_creator_json.directory AND topic_creator_content.file_name = 'content.json')
      LEFT JOIN keyvalue AS topic_creator_user ON (topic_creator_user.json_id = topic_creator_content.json_id AND topic_creator_user.key = 'cert_user_id')
      LEFT JOIN topic AS topic_sub ON (topic_sub.parent_topic_uri = topic.topic_id || '_' || topic_creator_content.directory)
      LEFT JOIN json AS topic_sub_creator_json ON (topic_sub_creator_json.json_id = topic_sub.json_id)
      LEFT JOIN json AS topic_sub_creator_content ON (topic_sub_creator_content.directory = topic_sub_creator_json.directory AND topic_sub_creator_content.file_name = 'content.json')
      LEFT JOIN comment ON (comment.topic_uri = row_topic_sub_uri AND comment.added < $dateFilter)
      WHERE topic.parent_topic_uri IS NULL AND topic.type = "group"
      GROUP BY topic.topic_id
      HAVING last_action < $dateFilter
      """;
  } else {
    query += """
      UNION ALL
      SELECT
        COUNT(comment_id) AS comments_num, MAX(comment.added) AS last_comment,
        MAX(topic_sub.added) AS last_added,
        CASE WHEN MAX(topic_sub.added) > MAX(comment.added) OR MAX(comment.added) IS NULL THEN MAX(topic_sub.added) ELSE MAX(comment.added) END as last_action,
        topic.*,
        topic_creator_user.value AS topic_creator_user_name,
        topic_creator_content.directory AS topic_creator_address,
        topic.topic_id || '_' || topic_creator_content.directory AS row_topic_uri,
        topic_sub.topic_id || '_' || topic_sub_creator_content.directory AS row_topic_sub_uri,
        topic_sub.title AS row_topic_sub_title, topic_sub.type AS row_topic_sub_type,
        (SELECT COUNT(*) FROM topic_vote WHERE topic_vote.topic_uri = topic.topic_id || '_' || topic_creator_content.directory)+1 AS votes,
        $sql_sticky
      FROM topic
      LEFT JOIN json AS topic_creator_json ON (topic_creator_json.json_id = topic.json_id)
      LEFT JOIN json AS topic_creator_content ON (topic_creator_content.directory = topic_creator_json.directory AND topic_creator_content.file_name = 'content.json')
      LEFT JOIN keyvalue AS topic_creator_user ON (topic_creator_user.json_id = topic_creator_content.json_id AND topic_creator_user.key = 'cert_user_id')
      LEFT JOIN topic AS topic_sub ON (topic_sub.parent_topic_uri = topic.topic_id || '_' || topic_creator_content.directory)
      LEFT JOIN json AS topic_sub_creator_json ON (topic_sub_creator_json.json_id = topic_sub.json_id)
      LEFT JOIN json AS topic_sub_creator_content ON (topic_sub_creator_content.directory = topic_sub_creator_json.directory AND topic_sub_creator_content.file_name = 'content.json')
      LEFT JOIN comment ON (comment.topic_uri = row_topic_sub_uri AND comment.added < $dateFilter)
      WHERE topic.type = "group" AND topic.parent_topic_uri = '$parentTopicUri'
      GROUP BY topic.topic_id
      HAVING last_action < $dateFilter
    """;
  }
  if (parentTopicUri == null) {
    query += " ORDER BY sticky DESC, last_action DESC LIMIT $limit";
  }

  return query;
}

String commentsQueryString(String topicId) {
  return '''SELECT
	comment.*,
			 user.value AS user_name,
			 user_json_content.directory AS user_address,
			 (SELECT COUNT(*) FROM comment_vote WHERE comment_vote.comment_uri = comment.comment_id || '_' || user_json_content.directory)+1 AS votes
			FROM comment
			 LEFT JOIN json AS user_json_data ON (user_json_data.json_id = comment.json_id)
			 LEFT JOIN json AS user_json_content ON (user_json_content.directory = user_json_data.directory AND user_json_content.file_name = 'content.json')
			 LEFT JOIN keyvalue AS user ON (user.json_id = user_json_content.json_id AND user.key = 'cert_user_id')
			WHERE comment.topic_uri = "$topicId" AND added < ${DateTime.now().millisecondsSinceEpoch / 1000}
			ORDER BY added DESC''';
}

String getNewTopicAddQuery(String creatorAddr, int topicId) {
  String query = '''
 SELECT
		  topic.*,
		  topic_creator_user.value AS topic_creator_user_name,
		  topic_creator_content.directory AS topic_creator_address,
		  topic.topic_id || '_' || topic_creator_content.directory AS row_topic_uri,
		  (SELECT COUNT(*) FROM topic_vote WHERE topic_vote.topic_uri = topic.topic_id || '_' || topic_creator_content.directory)+1 AS votes
		 FROM topic
		  LEFT JOIN json AS topic_creator_json ON (topic_creator_json.json_id = topic.json_id)
		  LEFT JOIN json AS topic_creator_content ON (topic_creator_content.directory = topic_creator_json.directory AND topic_creator_content.file_name = 'content.json')
		  LEFT JOIN keyvalue AS topic_creator_user ON (topic_creator_user.json_id = topic_creator_content.json_id AND topic_creator_user.key = 'cert_user_id')
		 WHERE topic.topic_id ='$topicId'  AND topic_creator_address = '$creatorAddr'
		 LIMIT 1
     ''';

  return query;
}
