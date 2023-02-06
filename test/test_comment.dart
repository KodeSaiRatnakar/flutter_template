import 'package:flutter_template/models/user_data.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test("comment json object with empty data", () {
    expect(() {
      Comment.fromJson({});
    }, throwsA("Invalid Comment Data"));
  });

  test("", () {
    var testJson = {
      "comment_id": 123,
      "body": "test body",
      "added": 123,
    };
    Comment testComment = Comment.fromJson(testJson);
    assert(testComment.body == testJson["body"]);
  });
}
