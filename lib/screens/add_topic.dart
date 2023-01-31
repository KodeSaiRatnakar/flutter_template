import 'package:flutter/material.dart';
import 'package:flutter_template/controllers/themeControlle.dart';
import 'package:flutter_template/controllers/zeronet.dart';
import '../widgets/buttons.dart';
import 'package:get/get.dart';

class AddTopicData extends StatelessWidget {
  AddTopicData({super.key});

  var items = ["General", "Features", "Bugs"];

  @override
  Widget build(BuildContext context) {
    ThreadItThemes theme = threadItThemeController.currentTheme.value;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.primaryColor,
        leading: IconButton(
          onPressed: () {
            uiController.currentRoute.value = Routes.home;
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      backgroundColor: theme.backGroundColor,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
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
                          borderSide: BorderSide(color: theme.primaryColor),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: theme.mainColor, width: 2),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: theme.primaryColor, width: 2),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: theme.primaryColor, width: 2),
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
                child: TextField(
                  style: theme.cardHeadingTextStyle,
                  keyboardType: TextInputType.multiline,
                  minLines: 1,
                  maxLines: 3,
                  cursorColor: theme.mainColor,
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
              child: TextField(
                style: theme.cardBodyTextStyle,
                keyboardType: TextInputType.multiline,
                minLines: 3,
                maxLines: 15,
                cursorColor: theme.mainColor,
                decoration: InputDecoration(
                  hintText: "Add message",
                  hintStyle: theme.cardBodyTextStyle,
                  border: const OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SubmitButton(
              text: "Add new topic",
              fontSize: 12,
            )
          ],
        ),
      ),
    );
  }
}
