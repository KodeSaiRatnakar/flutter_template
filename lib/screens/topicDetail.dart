import 'package:flutter/material.dart';
import 'package:flutter_template/controllers/themeControlle.dart';
import '../controllers/zeronet.dart';
import '../main.dart';
import '../extensions.dart';

class TopicDetailScreen extends StatelessWidget {
  TopicWidgetData topic;

  TopicDetailScreen({required this.topic, Key? key}) : super(key: key);

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
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          uiController.currentRoute(Routes.Home);
                        },
                        child: Container(
                          height: mediaSize.height * 0.07,
                          width: mediaSize.width * 0.5,
                          color: threadItThemeController
                              .currentTheme.value.primaryColor,
                          child: const Center(
                            child: Text(
                              "ThreadIt",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ]),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    TextButton(
                      style: theme.textButtonTheme.style?.copyWith(
                          backgroundColor:
                              const MaterialStatePropertyAll<Color>(
                                  Color(0xff2e2b32))),
                      onPressed: () {
                        uiController.currentRoute.value = Routes.Home;
                      },
                      child: Text(
                        "Home /",
                        style: threadItThemeController
                            .currentTheme.value.cardHeadingTextStyle,
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(
                      width: mediaSize.width * 0.7,
                      child: Text(
                        topic.title,
                        style: theme.textTheme.bodyLarge
                            ?.copyWith(color: Colors.white),
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  // height: mediaSize.height * 0.45,
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
                          style: threadItThemeController
                              .currentTheme.value.cardBodyTextStyle,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          children: [
                            InkWell(
                              borderRadius: BorderRadius.circular(5),
                              onTap: () {
                                //   widget.topic.isLiked =
                                //       widget.topic.isLiked ? false : true;
                                //   if (widget.topic.isLiked) {
                                //     widget.topic.totalLikes++;
                                //     tempLike = 0;
                                //   } else {
                                //     widget.topic.totalLikes--;
                                //   }
                                //   setState(() {g});
                                // },
                                // hoverColor: Colors.green,
                                // onHover: (value) {
                                //   if (!widget.topic.isLiked) {
                                //     if (value) {
                                //       onLikeButtonHover = true;
                                //       tempLike = 1;
                                //     } else {
                                //       tempLike = 0;
                                //       onLikeButtonHover = false;
                                //     }
                                //     setState(() {});
                                //   }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        color: onLikeButtonHover
                                            ? Colors.green
                                            : threadItThemeController
                                                .currentTheme
                                                .value
                                                .primaryColor,
                                        width: 1),
                                    color: false
                                        ? Colors.green
                                        : Colors.transparent),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 3, horizontal: 16),
                                  child: Center(
                                    child: Text(
                                      (topic.votes + tempLike).toString(),
                                      style: threadItThemeController
                                          .currentTheme
                                          .value
                                          .likeButtonDisabledTextStyle,
                                      //         ?.copyWith(fontSize: 14),,
                                      // style: onLikeButtonHover ||
                                      //         widget.topic.isLiked
                                      //     ? theme.textTheme.bodyMedium?.copyWith(
                                      //         fontSize: 14, color: Colors.white)
                                      //     : theme.textTheme.bodyMedium
                                      //         ?.copyWith(fontSize: 14),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: mediaSize.width * 0.05,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(topic.topicCreatorUserName.split("@")[0],
                                    style: threadItThemeController.currentTheme
                                        .value.commentUserTextStyle),
                                Text(
                                    "posted on ${((topic.added) * 1000).numDatetoStringDate} ${topic.lastAdded != topic.added ? true ? ((topic.lastAdded) * 1000).modifiedStrForAdmin : '' : ''}",
                                    style: threadItThemeController.currentTheme
                                        .value.commentOrLikeTimeStyle),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                CommentForm(
                  mediaSize: mediaSize,
                  theme: theme,
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            CommentsList(
              theme: theme,
              topicData: topic,
            )
          ],
        ),
      )),
    );
  }
}

class CommentForm extends StatelessWidget {
  final ThemeData theme;
  final Size mediaSize;
  const CommentForm({required this.theme, required this.mediaSize, super.key});

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
                Text(
                  "18sgsdfg2sdgh5fghgfh4gh2gfh2fgh4h2dh@cryptoid.bit",
                  style: TextStyle(
                      fontSize: 9,
                      color: theme.backgroundColor.withOpacity(0.7)),
                ),
                const Text(
                  "- new comment",
                  style: TextStyle(fontSize: 9, color: Colors.white),
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
              child: TextField(
                keyboardType: TextInputType.multiline,
                minLines: 1,
                maxLines: 15,
                style: TextStyle(color: Colors.white),
                cursorColor: theme.backgroundColor,
                decoration: InputDecoration(
                    fillColor: Colors.transparent,
                    border: OutlineInputBorder(borderSide: BorderSide.none)),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              decoration: const BoxDecoration(
                color: Colors.amber,
              ),
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Submit Comment",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w400),
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

class CommentsList extends StatefulWidget {
  final ThemeData theme;
  TopicWidgetData topicData;
  CommentsList({required this.theme, required this.topicData, super.key});

  @override
  State<CommentsList> createState() => _CommentsListState();
}

class _CommentsListState extends State<CommentsList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 20,
      itemBuilder: ((context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Container(
            decoration: BoxDecoration(
                color: threadItThemeController.currentTheme.value.cardColor),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        "sfjdskgkldfjgkdf",
                        style: TextStyle(
                            color: widget.theme.backgroundColor,
                            fontWeight: FontWeight.w500),
                      ),
                      Text(
                        " -- on ${((widget.topicData.lastCommentAdded ?? 0) * 1000).numDatetoStringDate}",
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w300,
                            fontSize: 12),
                      )
                    ],
                  ),
                  const SizedBox(height: 15),
                  Text(
                    widget.topicData.body,
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w500),
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
  }
}
