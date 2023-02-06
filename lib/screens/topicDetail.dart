import 'package:flutter/material.dart';
import 'package:flutter_template/controllers/themeControlle.dart';
import 'package:flutter_template/models/user_data.dart';
import 'package:get/get.dart';
import '../controllers/ui_controller.dart';
import '../controllers/zeronet.dart';
import '../extensions.dart';
import '../models/models.dart';
import '../widgets/buttons.dart';

class TopicDetailScreen extends StatelessWidget {
  TopicWidgetData topic;

  TopicDetailScreen({required this.topic, Key? key}) : super(key: key);

  List<String> pathString =
      uiController.listSorting.value.pathString.split(",");

  bool onLikeButtonHover = false;
  int tempLike = 0;
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    Size mediaSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color(0xff2e2b32),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: ListView(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 20,
                ),
                HeadButton(mediaSize: mediaSize),
                const SizedBox(
                  height: 10,
                ),
                PathButtons(
                  pathString: pathString,
                  mediaSize: mediaSize,
                  topic: topic,
                ),
                const SizedBox(
                  height: 10,
                ),
                TopicBody(
                    topic: topic,
                    onLikeButtonHover: onLikeButtonHover,
                    tempLike: tempLike,
                    mediaSize: mediaSize),
                const SizedBox(
                  height: 10,
                ),
                CommentForm(
                  mediaSize: mediaSize,
                  theme: theme,
                  topicUri: topic.rowTopicUri,
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            CommentList(
              theme: theme,
              topicData: topic,
            )
          ],
        ),
      )),
    );
  }
}

class TopicBody extends StatelessWidget {
  const TopicBody({
    Key? key,
    required this.topic,
    required this.onLikeButtonHover,
    required this.tempLike,
    required this.mediaSize,
  }) : super(key: key);

  final TopicWidgetData topic;
  final bool onLikeButtonHover;
  final int tempLike;
  final Size mediaSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: threadItThemeController.currentTheme.value.cardColor,
        border: Border.all(color: Colors.black, width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              topic.title,
              textAlign: TextAlign.start,
              style: threadItThemeController
                  .currentTheme.value.cardHeadingTextStyle,
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              topic.body,
              style:
                  threadItThemeController.currentTheme.value.cardBodyTextStyle,
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              children: [
                TopicVoteButton(
                  topicData: topic,
                ),
                SizedBox(
                  width: mediaSize.width * 0.05,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(topic.topicCreatorUserName.split("@")[0],
                        style: threadItThemeController
                            .currentTheme.value.commentUserTextStyle),
                    Text(
                        "posted on ${((topic.added) * 1000).numDatetoStringDate} ${topic.lastAdded != topic.added ? true ? ((topic.lastAdded) * 1000).modifiedStrForAdmin : '' : ''}",
                        style: threadItThemeController
                            .currentTheme.value.commentOrLikeTimeStyle),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class PathButtons extends StatelessWidget {
  const PathButtons({
    Key? key,
    required this.pathString,
    required this.mediaSize,
    required this.topic,
  }) : super(key: key);

  final List<String> pathString;
  final Size mediaSize;
  final TopicWidgetData topic;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        TextButton(
          onPressed: () {
            uiController.currentRoute(
              Routes.home,
            );
            zeroNetController.loadTopicWidgetData();
            uiController.changeListSorting(
              ListSorting.home,
            );
          },
          child: Text(
            pathString[0],
            style: threadItThemeController
                .currentTheme.value.cardHeadingTextStyle
                .copyWith(
              fontSize: 20,
            ),
            textAlign: TextAlign.start,
          ),
        ),
        Text(
          "> ",
          style: threadItThemeController.currentTheme.value.cardHeadingTextStyle
              .copyWith(
            color: Colors.white,
            fontSize: 20,
          ),
          textAlign: TextAlign.start,
        ),
        GestureDetector(
          onTap: () {
            uiController.currentRoute.value = Routes.home;
          },
          child: Text(
            pathString[1] != " " ? pathString[1] : "",
            style: threadItThemeController
                .currentTheme.value.cardHeadingTextStyle
                .copyWith(
              fontSize: 20,
            ),
            textAlign: TextAlign.start,
          ),
        ),
        Text(
          pathString[1] != " " ? " > " : " ",
          style: threadItThemeController.currentTheme.value.cardHeadingTextStyle
              .copyWith(
            color: Colors.white,
            fontSize: 20,
          ),
          textAlign: TextAlign.start,
        ),
        SizedBox(
          width: mediaSize.width * 0.45,
          child: Text(
            topic.title,
            style: threadItThemeController
                .currentTheme.value.cardHeadingTextStyle
                .copyWith(
              color: Colors.white,
            ),
            textAlign: TextAlign.start,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class HeadButton extends StatelessWidget {
  const HeadButton({
    Key? key,
    required this.mediaSize,
  }) : super(key: key);

  final Size mediaSize;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () {
            uiController.currentRoute(
              Routes.home,
            );
            zeroNetController.loadTopicWidgetData();
            uiController.changeListSorting(
              ListSorting.home,
            );
          },
          child: Container(
            height: mediaSize.height * 0.07,
            width: mediaSize.width * 0.5,
            color: threadItThemeController.currentTheme.value.primaryColor,
            child: const Center(
              child: Text(
                "ThreadIt",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class CommentForm extends StatelessWidget {
  final ThemeData theme;
  final Size mediaSize;
  final String topicUri;
  CommentForm(
      {required this.theme,
      required this.mediaSize,
      required this.topicUri,
      super.key});
  TextEditingController commentTxtCtrl = TextEditingController();
  GlobalKey<FormState> commentTxtFormKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          color: threadItThemeController.currentTheme.value.cardColor),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 5,
            ),
            Row(
              children: [
                TextButton(
                  onPressed: () {},
                  child: Text(
                    "18sgsdfg2sdgh5fghgfh4gh2gfh2fgh4h2dh@cryptoid.bit",
                    style: TextStyle(
                      fontSize: 9,
                      color: theme.backgroundColor.withOpacity(0.7),
                    ),
                  ),
                ),
                const Text(
                  "- new comment",
                  style: TextStyle(
                    fontSize: 9,
                    color: Colors.white,
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  width: 2,
                  color:
                      threadItThemeController.currentTheme.value.primaryColor,
                ),
              ),
              child: Form(
                key: commentTxtFormKey,
                child: TextFormField(
                  keyboardType: TextInputType.multiline,
                  minLines: 1,
                  maxLines: 15,
                  controller: commentTxtCtrl,
                  validator: (value) {
                    if (value != null) {
                      if (value.isNotEmpty) {
                        return null;
                      }
                    }
                    return "Enter comment";
                  },
                  style: const TextStyle(color: Colors.white),
                  cursorColor: theme.colorScheme.background,
                  decoration: const InputDecoration(
                    fillColor: Colors.transparent,
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () {
                if (commentTxtFormKey.currentState!.validate()) {
                  submitComment(topicUri, commentTxtCtrl.text);
                  commentTxtCtrl.clear();
                }
              },
              style: const ButtonStyle(
                  backgroundColor:
                      MaterialStatePropertyAll<Color>(Colors.amber)),
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Submit Comment",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 10,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}

class CommentList extends StatelessWidget {
  final ThemeData theme;
  TopicWidgetData topicData;
  CommentList({required this.theme, required this.topicData, super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: uiController.commentListData.length,
          itemBuilder: ((context, index) {
            CommentWidgetData commentItem = uiController.commentListData[index];
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Container(
                decoration: BoxDecoration(
                  color: threadItThemeController.currentTheme.value.cardColor,
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            commentItem.userName,
                            style: TextStyle(
                              color: theme.backgroundColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            " -- on ${((commentItem.commentAdded) * 1000).numDatetoStringDate}",
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w300,
                              fontSize: 12,
                            ),
                          ),
                          (commentItem.modified != null)
                              ? Text(
                                  (commentItem.modified! * 1000)
                                      .modifiedStrForAdmin,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w300,
                                    fontSize: 12,
                                  ),
                                )
                              : const SizedBox(),
                          const SizedBox(
                            width: 10,
                          ),
                          TopicCommentVoteButton(commentData: commentItem)
                        ],
                      ),
                      const SizedBox(height: 15),
                      Text(
                        commentItem.commentBody,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      )
                    ],
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}

void submitComment(
  String topicUri,
  String bodyTxt,
) async {
  int dateAdded = (DateTime.now().millisecondsSinceEpoch / 1000).ceil();
  if (zeroNetController.userDataObj.userComments.containsKey(topicUri)) {
    zeroNetController.userDataObj.userComments[topicUri]!.add(
      Comment(
        commentId: zeroNetController.userDataObj.nextCommentId,
        added: dateAdded,
        body: bodyTxt,
      ),
    );
  } else {
    zeroNetController.userDataObj.userComments[topicUri] = [
      Comment(
        commentId: zeroNetController.userDataObj.nextCommentId,
        added: dateAdded,
        body: bodyTxt,
      ),
    ];
  }

  uiController.commentListData.insert(
    0,
    CommentWidgetData(
      commentAdded: dateAdded,
      commentBody: bodyTxt,
      commentId: zeroNetController.userDataObj.nextCommentId,
      topicUri: topicUri,
      userAddress: zeroNetController.siteInfo.authAddress!,
      userName: "TempUser",
      votes: 0,
    ),
  );
  zeroNetController.userDataObj.nextCommentId += 1;
  await zeroNetController.saveUserData();
}
