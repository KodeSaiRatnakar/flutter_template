import 'package:flutter/material.dart';
import 'package:flutter_template/models/user_data.dart';
import '../consts.dart';
import 'package:get/get.dart';
import '../controllers/theme.dart';
import '../controllers/site_ui.dart';
import '../controllers/zeronet.dart';
import '../extensions.dart';
import '../models/models.dart';
import '../widgets/buttons.dart';
import '../widgets/text_editor.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    Size mediaSize = MediaQuery.of(context).size;
    ThemeData theme = Theme.of(context);

    return Scaffold(
      backgroundColor:
          threadItThemeController.currentTheme.value.backGroundColor,
      floatingActionButton: addPost(theme: theme),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              CustomAppBar(
                  mediaSize: mediaSize,
                  themeColor:
                      threadItThemeController.currentTheme.value.mainColor),
              const SearchBarTextField(),
              const SizedBox(
                height: 10,
              ),
              Obx(
                () {
                  sortListTopicData();

                  var _refresh = uiController.filterRefresh.value;
                  return Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      itemCount: topicWidgetDataList.length + 1,
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: HeaderButtons(mediaSize: mediaSize),
                          );
                        }
                        if (topicWidgetDataList.isNotEmpty) {
                          return TopicTile(
                            mediaSize: mediaSize,
                            theme: theme,
                            topicData: topicWidgetDataList[index - 1],
                            index: index - 1,
                          );
                        }
                      },
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

class HeaderButtons extends StatelessWidget {
  const HeaderButtons({
    super.key,
    required this.mediaSize,
  });

  final Size mediaSize;

  @override
  Widget build(BuildContext context) {
    return Obx(
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
                    isSelected:
                        uiController.listSorting.value == ListSorting.features,
                  ),
                  PinnedFeatures(
                    mediaSize: mediaSize,
                    title: "Bugs",
                    isSelected:
                        uiController.listSorting.value == ListSorting.bugs,
                  )
                ],
              );
            }
          default:
            {
              List<String> pathString =
                  uiController.listSorting.value.pathString.split(",");
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
    );
  }
}

// class TopicsListView extends StatelessWidget {
//   const TopicsListView({
//     super.key,
//     required this.mediaSize,
//     required this.theme,
//   });

//   final Size mediaSize;
//   final ThemeData theme;

//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       child: Obx(() {
//         sortListTopicData(uiController.homeSceenFilter);

//         var _refresh = uiController.filterRefresh.value;

//         return CustomScrollView(
//           slivers: [
//             SliverAppBar(
//               backgroundColor:
//                   threadItThemeController.currentTheme.value.backGroundColor,
//               floating: true,
//               bottom: PreferredSize(
//                 preferredSize: Size(
//                     mediaSize.width,
//                     uiController.listSorting.value == ListSorting.home
//                         ? 62
//                         : 10),
//                 child: Padding(
//                   padding: const EdgeInsets.only(bottom: 10),
//                   child: Obx(
//                     () {
//                       switch (uiController.listSorting.value) {
//                         case ListSorting.home:
//                           {
//                             return Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 PinnedFeatures(
//                                   mediaSize: mediaSize,
//                                   title: "Features",
//                                   isSelected: uiController.listSorting.value ==
//                                       ListSorting.features,
//                                 ),
//                                 PinnedFeatures(
//                                   mediaSize: mediaSize,
//                                   title: "Bugs",
//                                   isSelected: uiController.listSorting.value ==
//                                       ListSorting.bugs,
//                                 )
//                               ],
//                             );
//                           }
//                         default:
//                           {
//                             List<String> pathString = uiController
//                                 .listSorting.value.pathString
//                                 .split(",");
//                             return Row(
//                               mainAxisAlignment: MainAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   pathString[0],
//                                   style: threadItThemeController
//                                       .currentTheme.value.cardHeadingTextStyle
//                                       .copyWith(fontSize: 25),
//                                   textAlign: TextAlign.start,
//                                 ),
//                                 Text(
//                                   " > ${pathString[1]}",
//                                   style: threadItThemeController
//                                       .currentTheme.value.cardHeadingTextStyle
//                                       .copyWith(
//                                     color: Colors.white,
//                                     fontSize: 25,
//                                   ),
//                                   textAlign: TextAlign.start,
//                                 ),
//                               ],
//                             );
//                           }
//                       }
//                     },
//                   ),
//                 ),
//               ),
//             ),
//             SliverList(
//               delegate: SliverChildListDelegate(
//                 [
//                   ListView.builder(
//                     shrinkWrap: true,
//                     physics: const NeverScrollableScrollPhysics(),
//                     itemCount: topicWidgetDataList.length,
//                     itemBuilder: (context, index) {
//                       return Topic(
//                         mediaSize: mediaSize,
//                         theme: theme,
//                         topicData: topicWidgetDataList[index],
//                         index: index,
//                       );
//                     },
//                   )
//                 ],
//               ),
//             )
//           ],
//         );
//       }),
//     );
//   }
// }

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({
    super.key,
    required this.mediaSize,
    required this.themeColor,
  });

  final Size mediaSize;

  final Color themeColor;

  @override
  Widget build(BuildContext context) {
    return Row(
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
        Row(
          children: [
            IconButton(
              onPressed: () {
                uiController.isSearchBarSelected.value =
                    !(uiController.isSearchBarSelected.value);
              },
              icon: Icon(
                Icons.search,
                size: 30,
                color: themeColor,
              ),
            ),
            PopupMenuButton(
              color: threadItThemeController.currentTheme.value.cardColor,
              icon: Icon(
                Icons.filter_alt_outlined,
                color: themeColor,
                size: 30,
              ),
              onSelected: (SiteFilters selectedFilter) {
                if (SiteFilters.values.sublist(0, 5).contains(selectedFilter)) {
                  uiController.siteFilter1.value = selectedFilter;
                } else {
                  uiController.siteFilter2.value = selectedFilter;
                }
              },
              itemBuilder: (context) {
                return SiteFilters.values.map(
                  (filter) {
                    String filterString = filter.filterStr;
                    return PopupMenuItem<SiteFilters>(
                      value: filter,
                      child: Text(
                        filterString,
                        style: TextStyle(
                          color: (uiController.siteFilter1.value == filter ||
                                  uiController.siteFilter2.value == filter)
                              ? themeColor
                              : Colors.white,
                        ),
                      ),
                    );
                  },
                ).toList();
              },
            ),
            headerIcon(
              function: () {},
              iconData: Icons.language_outlined,
              color: themeColor,
            )
          ],
        ),
      ],
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
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "2023",
                      style: TextStyle(
                        color: Color(0xff83EFFF),
                        fontWeight: FontWeight.w500,
                      ),
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
                            zeroNetController.loadTopicWidgetData(
                              id: featuresRequest,
                            );
                            uiController.changeListSorting(
                              ListSorting.features,
                            );
                            break;

                          case "Bugs":
                            zeroNetController.loadTopicWidgetData(
                              id: bugsTopicId,
                            );
                            uiController.changeListSorting(
                              ListSorting.bugs,
                            );
                            break;
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

class TopicTile extends StatelessWidget {
  final Size mediaSize;
  final ThemeData theme;
  final int index;
  final TopicWidgetData topicData;

  const TopicTile({
    required this.mediaSize,
    required this.topicData,
    required this.index,
    super.key,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
                color: threadItThemeController.currentTheme.value.cardColor,
                borderRadius: BorderRadius.circular(5)),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12.5, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextButton(
                    onPressed: () {
                      uiController.selectedTopicIndex.value = index;
                      uiController.changeRoute(Routes.topicDetailScreen);
                      zeroNetController.loadComments(topicData.rowTopicUri);
                    },
                    child: Text(
                      topicData.title,
                      style: threadItThemeController
                          .currentTheme.value.cardHeadingTextStyle,
                      maxLines: 1,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 4.0, bottom: 20),
                    child: SizedBox(
                      child: SuperReaderField(
                        text: topicData.body.split("\n")[0],
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
                        TopicVoteButton(
                          topicData: topicData,
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
                                        text:
                                            ((topicData.lastCommentAdded ?? 0) *
                                                    1000)
                                                .modifiedStrForComment,
                                        style: threadItThemeController
                                            .currentTheme
                                            .value
                                            .commentOrLikeTimeStyle
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
          topicData.topicCreatorAddress ==
                  zeroNetController.siteInfo.authAddress
              ? Align(
                  alignment: Alignment.topRight,
                  child: PopupMenuButton(
                    onSelected: (selectedOption) {
                      if (selectedOption == "Edit Topic") {
                        uiController.editableTopicTitle = topicData.title;
                        uiController.editableTopicBody = topicData.body;
                        uiController.editableTopicId = topicData.topicId;
                        uiController.currentRoute.value = Routes.addTopicData;
                      } else {
                        EditUserData.deleteTopic(topicId: topicData.topicId);
                      }
                    },
                    itemBuilder: (context) {
                      return ["Edit Topic", "Delete Topic"].map(
                        (txt) {
                          return PopupMenuItem<String>(
                            value: txt,
                            child: Text(txt),
                          );
                        },
                      ).toList();
                    },
                  ))
              : const SizedBox()
        ],
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

class SearchBarTextField extends StatelessWidget {
  const SearchBarTextField({super.key});

  @override
  Widget build(BuildContext context) {
    Color themeColor = threadItThemeController.currentTheme.value.mainColor;
    double searchBarMaxHeight = 50;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Obx(
        () {
          return AnimatedContainer(
            curve: Curves.linear,
            height:
                uiController.isSearchBarSelected.value ? searchBarMaxHeight : 0,
            duration: const Duration(milliseconds: 200),
            child: TextField(
              controller: uiController.searchController.value,
              onChanged: (text) {
                uiController.searchStr.value = text;
              },
              style: const TextStyle(color: Colors.white, fontSize: 15),
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
    );
  }
}
