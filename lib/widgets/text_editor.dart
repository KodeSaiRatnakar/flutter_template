import 'package:flutter/material.dart';
import 'package:flutter_template/controllers/site_ui.dart';
import 'package:flutter_template/extensions.dart';
import 'package:super_editor/super_editor.dart';
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

  @override
  void initState() {
    super.initState();
    _doc = _createDocument1();
    _docEditor = DocumentEditor(document: _doc as MutableDocument);
    _composer = DocumentComposer()
      ..addListener(() {
        // Timer(const Duration(milliseconds: 250), () {
        //   uiController.markDownStr.value =
        //       serializeDocumentToMarkdown(_docEditor.document);
        // });
      });
    _docOps = CommonEditorOperations(
        editor: _docEditor,
        composer: _composer,
        documentLayoutResolver: () =>
            _docLayoutKey.currentState as DocumentLayout);
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
    return Column(
      children: [
        Container(
          height: 40,
          width: MediaQuery.of(context).size.width,
          color: threadItThemeController.currentTheme.value.topicAddBorderColor,
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
                        ? threadItThemeController.currentTheme.value.mainColor
                        : threadItThemeController.currentTheme.value.textColor,
                  ),
                ),
                onTap: () {
                  toogleEdit(attr);
                  setState(() {});
                },
              );
            },
          ),
        ),
        SizedBox(
          height: 300,
          child: ListView(
            children: [
              SuperEditor(
                editor: _docEditor,
                composer: _composer,
                documentOverlayBuilders: [
                  DefaultCaretOverlayBuilder(
                    const CaretStyle().copyWith(
                      color: Colors.white,
                      width: 2,
                    ),
                  ),
                ],
                stylesheet: defaultStylesheet.copyWith(
                  documentPadding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                  rules: [
                    StyleRule(
                      const BlockSelector("header1"),
                      (doc, docNode) {
                        return {
                          "padding":
                              const CascadingPadding.only(top: 5, bottom: 5),
                          "textStyle": const TextStyle(
                            color: Colors.white,
                            fontSize: 38,
                            fontWeight: FontWeight.bold,
                          ),
                        };
                      },
                    )
                  ],
                ),
              ),
              // ElevatedButton(
              //     onPressed: () {
              //       uiController.markDownStr.value =
              //           serializeDocumentToMarkdown(_docEditor.document);
              //     },
              //     child: Text("convert"))
            ],
          ),
        ),
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
    ],
  );
}
