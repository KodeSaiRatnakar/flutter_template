import 'package:flutter_template/models/user_data.dart';
import 'package:flutter_test/flutter_test.dart';

final data = {"body": "testBody"};

void main() {
  test("topic model with empty json", () {
    expect(() {
      Topic.fromJson(data);
    }, throwsA("Invalid Topic Data"));
  });

  test("topic without added key", () {
    var data = {"topic_id": 123, "title": "test title", "body": "test body"};
    expect(() => Topic.fromJson(data), throwsA("Invalid Topic Data"));
  });

  test("topic without body key", () {
    var data = {"topic_id": 123, "title": "test title", "added": 123};
    var topic = Topic.fromJson(data);
    assert(topic.body == "");
  });

  test("topic with empty body", () {
    var data = {
      "topic_id": 123,
      "title": "test title",
      "added": 123,
      "body": ""
    };
    var topic = Topic.fromJson(data);
    assert(topic.body == "");
  });

  test("topic ", () {
    var data = {
      "topic_id": 123,
      "title": "test title",
      "body": "test body",
      "added": 123,
    };
    var topic = Topic.fromJson(data);
    assert(topic.body == data['body']);
  });
}
