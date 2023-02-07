import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_template/controllers/site_ui.dart';
import 'package:flutter_template/extensions.dart';
import 'package:super_editor/super_editor.dart';
import 'package:super_editor_markdown/super_editor_markdown.dart';
import '../controllers/theme.dart';

class DocTextEditor extends StatefulWidget {
  const DocTextEditor({super.key});
  @override
  State<DocTextEditor> createState() => _DocTextEditorState();
}

class _DocTextEditorState extends State<DocTextEditor> {
  final GlobalKey _docLayoutKey = GlobalKey();
  late Document _doc;
  late DocumentEditor _docEditor;
  late DocumentComposer _composer;
  late CommonEditorOperations _docOps;

  bool showUrlField = false;
  SiteTheme theme = threadItThemeController.currentTheme.value;
  bool isMarkDownEnabled = false;
  TextEditingController markDownCtrl = TextEditingController();

  void changeMode() {
    if (isMarkDownEnabled) {
      initSuperEditor();
    }
    isMarkDownEnabled = !isMarkDownEnabled;
    setState(() {});
  }

  void initSuperEditor() {
    _doc = isMarkDownEnabled
        ? deserializeMarkdownToDocument(markDownCtrl.text)
        : _createDocument1();
    _docEditor = DocumentEditor(document: _doc as MutableDocument);
    _composer = DocumentComposer()
      ..addListener(
        () {
          Timer(
            const Duration(milliseconds: 100),
            () {
              var document = _docEditor.document;
              try {
                var mdStr = serializeDocumentToMarkdown(document);
                uiController.markDownStr.value = mdStr;
                markDownCtrl.text = mdStr;
              } catch (e) {
                setState(() {});
              }
            },
          );
        },
      );
    _docOps = CommonEditorOperations(
        editor: _docEditor,
        composer: _composer,
        documentLayoutResolver: () =>
            _docLayoutKey.currentState as DocumentLayout);
  }

  @override
  void initState() {
    initSuperEditor();
    super.initState();
  }

  bool _doesSelectionHaveAttributions(Set<NamedAttribution>? attributions) {
    final selection = _composer.selection;
    if (selection == null || attributions == null) {
      return false;
    }
    if (selection.isCollapsed) {
      return _composer.preferences.currentAttributions
          .containsAll(attributions);
    }
    return _doc.doesSelectedTextContainAttributions(selection, attributions);
  }

  void toogleEdit(NamedAttribution? attributions) {
    if (_composer.selection != null && attributions != null) {
      final selection = _composer.selection;
      selection!.isCollapsed
          ? _docOps.toggleComposerAttributions({attributions})
          : _docOps.toggleAttributionsOnSelection({attributions});
    }
  }

  @override
  void dispose() {
    _composer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double mediaWidth = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Container(
          height: 40,
          width: mediaWidth,
          color: threadItThemeController.currentTheme.value.topicAddBorderColor,
          child: Row(
            children: [
              isMarkDownEnabled
                  ? const Text(
                      "     MarkDown",
                      style: TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    )
                  : Expanded(
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: EditingButtons.values.length,
                        itemBuilder: (context, index) {
                          var currentButton = EditingButtons.values[index];
                          var attr = currentButton.getAttribution;
                          return InkWell(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                currentButton.getEditingIcon(),
                                color: _doesSelectionHaveAttributions(
                                        attr != null ? {attr} : null)
                                    ? threadItThemeController
                                        .currentTheme.value.mainColor
                                    : threadItThemeController
                                        .currentTheme.value.textColor,
                              ),
                            ),
                            onTap: () {
                              toogleEdit(attr);
                              if (currentButton == EditingButtons.link) {
                                var _node = _docEditor.document.getNodeAt(
                                        _docEditor.document.nodes.length - 1)
                                    as TextNode;

                                final text = _node.text;

                                final linkAttribution = LinkAttribution(
                                    url: Uri.parse("https://google.com"));
                                text.addAttribution(
                                  linkAttribution,
                                  SpanRange(
                                      start: _node.beginningPosition.offset,
                                      end: _node.endPosition.offset - 1),
                                );

                                showUrlField = !showUrlField;
                              }
                              setState(() {});
                            },
                          );
                        },
                      ),
                    ),
              isMarkDownEnabled ? const Spacer() : const SizedBox(),
              MediaQuery.of(context).size.width > 900
                  ? TextButton(
                      onPressed: changeMode,
                      child: Text(
                        isMarkDownEnabled
                            ? "Switch to Fancy Editor"
                            : "Switch to Markdown mode",
                        textAlign: TextAlign.center,
                        style:
                            const TextStyle(fontSize: 11, color: Colors.white),
                      ),
                    )
                  : IconButton(
                      onPressed: changeMode,
                      icon: Icon(
                        isMarkDownEnabled
                            ? Icons.raw_on_outlined
                            : Icons.raw_off_outlined,
                      ),
                    )
            ],
          ),
        ),
        isMarkDownEnabled
            ? TextFormField(
                controller: markDownCtrl,
                style: theme.cardBodyTextStyle,
                keyboardType: TextInputType.multiline,
                cursorColor: Colors.white,
                minLines: 10,
                maxLines: 50,
                validator: (value) {
                  if (value != null) {
                    if (value.isNotEmpty) {
                      return null;
                    }
                  }
                  return "Enter Topic Title";
                },
                decoration: InputDecoration(
                  hintText: "Add Message",
                  hintStyle: theme.cardBodyTextStyle,
                  border: const OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                ),
              )
            : Stack(
                children: [
                  SizedBox(
                    height: 300,
                    child: ListView(
                      children: [
                        SuperEditor(
                          editor: _docEditor,
                          composer: _composer,
                          autofocus: true,
                          documentOverlayBuilders: [
                            DefaultCaretOverlayBuilder(
                              const CaretStyle().copyWith(
                                color: Colors.white,
                                width: 2,
                              ),
                            ),
                          ],
                          stylesheet: defaultStylesheet.copyWith(
                            documentPadding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 5),
                            rules: SuperEditorBlockSelector.values
                                .map((e) => e.styleRuleExt)
                                .toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      height: showUrlField ? 100 : 0,
                      width: mediaWidth,
                      color: Colors.black12,
                      child: Visibility(
                        visible: false,
                        child: Row(
                          children: [
                            SizedBox(
                                width: mediaWidth * 0.5,
                                child: const LinkTextField()),
                            IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.check,
                                  color: Colors.amber,
                                ))
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
        // ElevatedButton(
        //     onPressed: () {
        //       var md = serializeDocumentToMarkdown(_docEditor.document);
        //       print(md);
        //     },
        //     child: Text("convert"))
      ],
    );
  }
}

Document _createDocument1() {
  return MutableDocument(
    nodes: [
      ParagraphNode(
        id: "1",
        text: AttributedText(text: ""),
      ),
      // ParagraphNode(
      //   id: "test",
      //   text: AttributedText(
      //     text: "link",
      //     spans: AttributedSpans(attributions: [
      //       SpanMarker(
      //           attribution: LinkAttribution(url: Uri.parse("google.com")),
      //           offset: 0,
      //           markerType: SpanMarkerType.start),
      //       SpanMarker(
      //           attribution: LinkAttribution(url: Uri.parse("gooogle.com")),
      //           offset: 3,
      //           markerType: SpanMarkerType.end),
      //     ]),
      //   ),
      // ),
    ],
  );
}

class LinkTextField extends StatelessWidget {
  const LinkTextField({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController textCtrl = TextEditingController();
    TextEditingController linkCtrl = TextEditingController();
    return Column(
      children: [
        TextField(
          controller: textCtrl,
          cursorColor: Colors.white,
          style: threadItThemeController.currentTheme.value.commentUserTextStyle
              .copyWith(fontSize: 18),
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 0),
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
            ),
          ),
        ),
        TextField(
          controller: linkCtrl,
          cursorColor: Colors.white,
          style: threadItThemeController.currentTheme.value.commentUserTextStyle
              .copyWith(fontSize: 18),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(vertical: 0),
            prefixIcon: IconButton(
              icon: const Icon(
                Icons.paste,
                color: Color(0xff83EFFF),
              ),
              onPressed: () {},
            ),
            border: const OutlineInputBorder(
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}

class SuperReaderField extends StatelessWidget {
  final String text;
  const SuperReaderField({required this.text, super.key});

  @override
  Widget build(BuildContext context) {
    Document doc = deserializeMarkdownToDocument(text);
    return SuperReader(
      document: doc,
      stylesheet: defaultStylesheet.copyWith(
        documentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
        rules:
            SuperEditorBlockSelector.values.map((e) => e.styleRuleExt).toList(),
      ),
    );
  }
}

enum SuperEditorBlockSelector {
  header1,
  header2,
  header3,
  header4,
  header5,
  header6,
  paragraph,
}

extension FontSizeExt on SuperEditorBlockSelector {
  StyleRule get styleRuleExt {
    double fontSize = 16;
    FontWeight fontWeight = FontWeight.normal;

    switch (this) {
      case SuperEditorBlockSelector.header1:
        fontSize = 38.0;
        fontWeight = FontWeight.bold;
        break;
      case SuperEditorBlockSelector.header2:
        fontSize = 34.0;
        break;
      case SuperEditorBlockSelector.header3:
        fontSize = 30.0;
        break;
      case SuperEditorBlockSelector.header4:
        fontSize = 26.0;
        break;
      case SuperEditorBlockSelector.header5:
        fontSize = 22.0;
        break;
      case SuperEditorBlockSelector.header6:
        fontSize = 20.0;
        break;
      case SuperEditorBlockSelector.paragraph:
        fontSize = 16;
        break;
    }

    return StyleRule(
      BlockSelector(strHeader),
      (doc, docNode) {
        return {
          "padding": const CascadingPadding.only(top: 5, bottom: 5),
          "textStyle": TextStyle(
            color: Colors.white,
            fontSize: fontSize,
            fontWeight: fontWeight,
          ),
        };
      },
    );
  }

  String get strHeader {
    switch (this) {
      case SuperEditorBlockSelector.header1:
        return "header1";
      case SuperEditorBlockSelector.header2:
        return 'header2';
      case SuperEditorBlockSelector.header3:
        return 'header3';
      case SuperEditorBlockSelector.header4:
        return 'header4';
      case SuperEditorBlockSelector.header5:
        return 'header5';
      case SuperEditorBlockSelector.header6:
        return 'header6';
      case SuperEditorBlockSelector.paragraph:
        return "paragraph";
    }
  }
}
