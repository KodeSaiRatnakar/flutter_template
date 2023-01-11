import 'package:flutter/material.dart';
import 'package:flutter_template/consts.dart';
import 'package:get/get.dart';
import '../controllers/themeControlle.dart';
import '../controllers/zeronet.dart';
import '../main.dart';
import '../extensions.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});
  Color themeColor = const Color(0xff83EFFF);
  double searchBarMaxHeight = 50;

  @override
  Widget build(BuildContext context) {
    Size mediaSize = MediaQuery.of(context).size;
    ThemeData theme = Theme.of(context);
    TextEditingController searchController = TextEditingController();

    return Scaffold(
      backgroundColor: const Color(0xff2e2b32),
      floatingActionButton: addPost(theme: theme),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      zeroNetController.loadTopicWidgetData();
                      uiController.changeListSorting(
                        ListSorting.home,
                      );
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
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          if (uiController.isSearchBarSelected.value) {
                            searchController.clear();
                          } else {
                            searchController.text =
                                uiController.searchStr.value;
                          }
                          uiController.isSearchBarSelected.value =
                              !(uiController.isSearchBarSelected.value);
                        },
                        icon: Icon(
                          Icons.search,
                          size: 30,
                          color: themeColor,
                        ),
                      ),
                      headerIcon(
                        function: () {},
                        iconData: Icons.language_outlined,
                        color: themeColor,
                      )
                    ],
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Obx(
                  () {
                    return AnimatedContainer(
                      curve: Curves.linear,
                      height: uiController.isSearchBarSelected.value
                          ? searchBarMaxHeight
                          : 0,
                      duration: const Duration(milliseconds: 200),
                      child: TextField(
                        controller: searchController,
                        onChanged: (text) {
                          uiController.searchStr.value = text;
                        },
                        style:
                            const TextStyle(color: Colors.white, fontSize: 15),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: uiController.isSearchBarSelected.value
                                  ? themeColor
                                  : Colors.transparent,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(7),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: uiController.isSearchBarSelected.value
                                    ? themeColor
                                    : Colors.transparent,
                                width: 2),
                            borderRadius: BorderRadius.circular(7),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: uiController.isSearchBarSelected.value
                                  ? themeColor
                                  : Colors.transparent,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(7),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: uiController.isSearchBarSelected.value
                                  ? themeColor
                                  : Colors.transparent,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(7),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Obx(
                () {
                  switch (uiController.listSorting.value) {
                    case ListSorting.home:
                      {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            PinnedFeatures(
                              mediaSize: mediaSize,
                              title: "Features",
                              isSelected: uiController.listSorting.value ==
                                  ListSorting.features,
                            ),
                            PinnedFeatures(
                              mediaSize: mediaSize,
                              title: "Bugs",
                              isSelected: uiController.listSorting.value ==
                                  ListSorting.bugs,
                            )
                          ],
                        );
                      }
                    default:
                      {
                        List<String> pathString = uiController
                            .listSorting.value.pathString
                            .split(",");
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              pathString[0],
                              style: threadItThemeController
                                  .currentTheme.value.cardHeadingTextStyle
                                  .copyWith(fontSize: 25),
                              textAlign: TextAlign.start,
                            ),
                            Text(
                              " > ${pathString[1]}",
                              style: threadItThemeController
                                  .currentTheme.value.cardHeadingTextStyle
                                  .copyWith(
                                color: Colors.white,
                                fontSize: 25,
                              ),
                              textAlign: TextAlign.start,
                            ),
                          ],
                        );
                      }
                  }
                },
              ),
              const SizedBox(
                height: 10,
              ),
              TopicList(
                mediaSize: mediaSize,
                theme: theme,
                topicWidgetData: topicWidgetDataList,
              )
            ],
          ),
        ),
      ),
    );
  }
}

Widget headerIcon(
    {required Function function,
    required IconData iconData,
    required Color color}) {
  return IconButton(
    onPressed: () {
      function();
      print("pressed sear");
    },
    icon: Icon(
      iconData,
      size: 30,
      color: color,
    ),
  );
}

class PinnedFeatures extends StatelessWidget {
  final Size mediaSize;
  final String title;

  final bool isSelected;

  const PinnedFeatures(
      {required this.mediaSize,
      required this.title,
      required this.isSelected,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: mediaSize.width * 0.45,
      decoration: BoxDecoration(
          border: isSelected
              ? Border.all(color: Colors.white, width: 2)
              : Border.all(color: Colors.transparent),
          color: threadItThemeController.currentTheme.value.primaryColor,
          borderRadius: BorderRadius.circular(10)),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      title,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.white),
                    ),
                  ),
                  Transform.rotate(
                    angle: 0.9,
                    child: IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.push_pin_outlined,
                          size: 20,
                        )),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "2023",
                      style: TextStyle(
                          color: Color(0xff83EFFF),
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 0.0),
                    child: ElevatedButton(
                      style: const ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(
                          Color(0xff83EFFF),
                        ),
                      ),
                      onPressed: () {
                        switch (title) {
                          case "Features":
                            {
                              zeroNetController.loadTopicWidgetData(
                                id: featuresRequest,
                              );
                              uiController.changeListSorting(
                                ListSorting.features,
                              );
                              break;
                            }
                          case "Bugs":
                            {
                              zeroNetController.loadTopicWidgetData(
                                id: bugsTopicId,
                              );
                              uiController.changeListSorting(
                                ListSorting.bugs,
                              );
                              break;
                            }
                        }
                      },
                      child: const Text(
                        "Open",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 10)
            ],
          ),
        ),
      ),
    );
  }
}

class TopicList extends StatelessWidget {
  final Size mediaSize;
  final ThemeData theme;
  final List topicWidgetData;
  TopicList(
      {required this.mediaSize,
      required this.topicWidgetData,
      required this.theme,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: topicWidgetData.length,
        itemBuilder: (context, index) {
          return Topic(
            mediaSize: mediaSize,
            theme: theme,
            topicData: topicWidgetData[index],
            index: index,
          );
        },
      ),
    );
  }
}

class Topic extends StatelessWidget {
  final Size mediaSize;
  final ThemeData theme;
  final int index;

  TopicWidgetData topicData;
  Topic({
    required this.mediaSize,
    required this.topicData,
    required this.index,
    super.key,
    required this.theme,
  });

  bool onLikeButtonHover = false;
  int tempLike = 0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            color: threadItThemeController.currentTheme.value.cardColor,
            borderRadius: BorderRadius.circular(5)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.5, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextButton(
                onPressed: () {
                  uiController.selectedTopicIndex.value = index;
                  uiController.changeRoute(Routes.topicDetailScreen);
                },
                child: Text(
                  topicData.title,
                  style: threadItThemeController
                      .currentTheme.value.cardHeadingTextStyle,
                  maxLines: 1,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, bottom: 20),
                child: SizedBox(
                  child: Text(
                    topicData.body,
                    style: threadItThemeController
                        .currentTheme.value.cardBodyTextStyle,
                    maxLines: 1,
                  ),
                ),
              ),
              Text(topicData.sticky != 0 ? "yes" : ""),
              Padding(
                padding: const EdgeInsets.only(
                  left: 8.0,
                ),
                child: Row(
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
                        //   setState(() {});
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
                          borderRadius: BorderRadius.circular(13),
                          border: Border.all(
                            color: onLikeButtonHover
                                ? Colors.green
                                : threadItThemeController
                                    .currentTheme.value.primaryColor,
                            width: 1,
                          ),
                          color: false ? Colors.green : Colors.transparent,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 1, horizontal: 16),
                          child: Center(
                            child: Text(
                              (topicData.votes + tempLike).toString(),
                              style: const TextStyle(
                                color: Colors.white,
                              ),

                              //  onLikeButtonHover || widget.topic.isLiked
                              //     ? widget.theme.textTheme.bodyMedium?.copyWith(
                              //         fontSize: 14, color: Colors.white)
                              //     : widget.theme.textTheme.bodyMedium
                              //         ?.copyWith(fontSize: 14),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: mediaSize.width * 0.025,
                    ),
                    SizedBox(
                      child: RichText(
                        maxLines: 1,
                        text: TextSpan(
                          text: '',
                          style: const TextStyle(
                            fontWeight: FontWeight.w300,
                            color: Colors.black,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: topicData.commentsNum.toString(),
                              style: threadItThemeController
                                  .currentTheme.value.cardBodyMedium,
                            ),
                            TextSpan(
                              text: topicData.commentsNum > 1
                                  ? " comments "
                                  : " comment ",
                              style: threadItThemeController
                                  .currentTheme.value.cardBodyMedium
                                  .copyWith(
                                fontSize: 13,
                              ),
                            ),
                            topicData.commentsNum == 0
                                ? const TextSpan()
                                : TextSpan(
                                    text: ((topicData.lastCommentAdded ?? 0) *
                                            1000)
                                        .modifiedStrForComment,
                                    style: threadItThemeController.currentTheme
                                        .value.commentOrLikeTimeStyle
                                        .copyWith(
                                      fontSize: 13,
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 5,
              )
            ],
          ),
        ),
      ),
    );
  }
}

Widget addPost({required ThemeData theme}) {
  return FloatingActionButton(
    backgroundColor: threadItThemeController.currentTheme.value.primaryColor,
    onPressed: () {
      uiController.currentRoute.value = Routes.addTopicData;
    },
    child: const Icon(
      Icons.add,
    ),
  );
}
