import 'package:flutter/material.dart';
import 'package:flutter_template/consts.dart';
import 'package:flutter_template/controllers/theme.dart';
import 'package:flutter_template/controllers/zeronet.dart';
import 'package:flutter_template/extensions.dart';
import 'package:flutter_template/models/models.dart';
import 'package:flutter_template/models/user_data.dart';
import 'package:flutter_template/widgets/text_editor.dart';
import 'package:zeronet_ws/zeronet_ws.dart';
import '../controllers/site_ui.dart';
import 'package:get/get.dart';

class AddTopicData extends StatelessWidget {
  AddTopicData({this.title, this.body, super.key});
  String? title;
  String? body;

  var items = ["General", "Features", "Bugs"];
  TextEditingController topicTitleCtrl = TextEditingController();
  TextEditingController topicBodyCtrl = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    SiteTheme theme = threadItThemeController.currentTheme.value;
    topicTitleCtrl.text = title ?? "";
    topicBodyCtrl.text = body ?? "";
    double mediaWidth = MediaQuery.of(context).size.width;
    bool isSmall = mediaWidth < 900;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.primaryColor,
        leading: IconButton(
          onPressed: () {
            uiController.currentRoute.value = Routes.home;
            uiController.editableTopicBody = null;
            uiController.editableTopicTitle = null;
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      backgroundColor: theme.backGroundColor,
      body: Row(
        children: [
          SizedBox(
            width: isSmall ? 0 : mediaWidth * 0.05,
          ),
          Container(
            width: isSmall ? mediaWidth : mediaWidth * 0.55,
            padding: const EdgeInsets.only(left: 8, top: 25, right: 8),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Obx(
                        () => SizedBox(
                          width: 150,
                          child: DropdownButtonFormField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: theme.primaryColor),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: theme.mainColor, width: 2),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: theme.primaryColor, width: 2),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: theme.primaryColor, width: 2),
                              ),
                            ),
                            dropdownColor: threadItThemeController
                                .currentTheme.value.backGroundColor,
                            hint: const Text(
                              "General",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600),
                            ),
                            value: uiController.dropdownvalue.value,
                            icon: const Icon(Icons.keyboard_arrow_down),
                            items: items.map(
                              (String items) {
                                return DropdownMenuItem(
                                  value: items,
                                  child: Text(
                                    items,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                );
                              },
                            ).toList(),
                            onChanged: (String? newValue) {
                              uiController.dropdownvalue.value =
                                  newValue ?? uiController.dropdownvalue.value;
                            },
                          ),
                        ),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          "Rules",
                          style: theme.cardBodyMedium,
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      )
                    ],
                  ),
                  Form(
                    key: formKey,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Container(
                            decoration: BoxDecoration(
                              color: theme.cardColor,
                              border: Border.all(
                                color: theme.topicAddBorderColor,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: TextFormField(
                              controller: topicTitleCtrl,
                              style: theme.cardHeadingTextStyle,
                              keyboardType: TextInputType.multiline,
                              minLines: 1,
                              maxLines: 3,
                              cursorColor: theme.mainColor,
                              validator: (value) {
                                if (value != null) {
                                  if (value.isNotEmpty) {
                                    return null;
                                  }
                                }
                                return "Enter Topic Title";
                              },
                              decoration: InputDecoration(
                                hintText: "Add Topic Title",
                                hintStyle: theme.cardHeadingTextStyle,
                                border: const OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: theme.cardColor,
                            border: Border.all(
                              color: theme.topicAddBorderColor,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: DocTextEditor(),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      var mdStr = uiController.markDownStr.value;
                      if (formKey.currentState!.validate()) {
                        if (title == null && mdStr.isNotEmpty) {
                          Topic newTopic = Topic(
                            topicId:
                                (DateTime.now().millisecondsSinceEpoch / 1000)
                                    .ceil(),
                            title: topicTitleCtrl.text,
                            body: mdStr,
                            added:
                                (DateTime.now().millisecondsSinceEpoch / 1000)
                                    .ceil(),
                          );
                          zeroNetController.userDataObj.userTopics
                              .add(newTopic);

                          topicBodyCtrl.clear();
                          uiController.markDownStr.value = "";
                          topicTitleCtrl.clear();
                          zeroNetController.userDataObj.nextTopicId += 1;
                          zeroNetController.saveUserData();
                          var newTopicQuery =
                              await zeroNetController.instance.dbQueryFuture(
                            getNewTopicAddQuery(
                                zeroNetController.siteInfo.authAddress!,
                                newTopic.added),
                          );
                          if (newTopicQuery.isMsg) {
                            topicWidgetDataList.insert(
                              0,
                              TopicWidgetData.whenUserAddTopic(
                                newTopicQuery.message!.result[0],
                              ),
                            );
                          }
                        } else {
                          EditUserData.editTopic(
                              title: topicTitleCtrl.text,
                              body: mdStr,
                              topicId: uiController.editableTopicId);
                        }
                        uiController.currentRoute.value = Routes.home;
                        uiController.editableTopicBody = null;
                        uiController.editableTopicTitle = null;
                      }
                    },
                    style: const ButtonStyle(
                      backgroundColor:
                          MaterialStatePropertyAll<Color>(Colors.amber),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Add new topic",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
