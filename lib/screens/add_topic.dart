import 'package:flutter/material.dart';
import 'package:flutter_template/controllers/themeControlle.dart';
import 'package:flutter_template/controllers/zeronet.dart';

class AddTopicData extends StatelessWidget {
  const AddTopicData({super.key});

  @override
  Widget build(BuildContext context) {
    ThreadItThemes theme = threadItThemeController.currentTheme.value;
    Size mediaSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.primaryColor,
        leading: IconButton(
            onPressed: () {
              uiController.currentRoute.value = Routes.Home;
            },
            icon: Icon(Icons.arrow_back)),
      ),
      backgroundColor: theme.backGroundColor,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              style: theme.cardHeadingTextStyle,
              keyboardType: TextInputType.multiline,
              minLines: 1,
              maxLines: 3,
              cursorColor: theme.mainColor,
              decoration: InputDecoration(
                  hintText: "Add Topic T itle",
                  hintStyle: theme.cardHeadingTextStyle,
                  border: OutlineInputBorder(borderSide: BorderSide.none)),
            ),
            Container(
              decoration: BoxDecoration(color: theme.cardColor),
              child: TextField(
                style: theme.cardBodyTextStyle,
                keyboardType: TextInputType.multiline,
                minLines: 3,
                maxLines: 15,
                cursorColor: theme.mainColor,
                decoration: InputDecoration(
                    hintText: "Add message",
                    hintStyle: theme.cardBodyTextStyle,
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
                      color: Colors.black, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
