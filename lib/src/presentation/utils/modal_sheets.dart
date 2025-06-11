// ignore_for_file: no_leading_underscores_for_local_identifiers, unused_element

import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
// import 'package:modal_gif_picker/modal_gif_picker.dart';
import 'package:provider/provider.dart';
// import 'package:vs_story_designer/src/domain/models/editable_items.dart';
import 'package:vs_story_designer/src/domain/providers/notifiers/control_provider.dart';
import 'package:vs_story_designer/src/domain/providers/notifiers/draggable_widget_notifier.dart';
import 'package:vs_story_designer/src/domain/providers/notifiers/painting_notifier.dart';
import 'package:vs_story_designer/src/domain/providers/notifiers/text_editing_notifier.dart';
import 'package:vs_story_designer/src/localization/l10n.dart';
// import 'package:vs_story_designer/src/domain/sevices/save_as_image.dart';
import 'package:vs_story_designer/src/presentation/utils/Extensions/hexColor.dart';
// import 'package:vs_story_designer/src/presentation/utils/constants/item_type.dart';
import 'package:vs_story_designer/src/presentation/widgets/animated_onTap_button.dart';
import 'package:vs_story_designer/vs_story_designer.dart';

/// create item of type GIF
// Future createGiphyItem(
//     {required BuildContext context, required giphyKey}) async {
//   final _editableItem =
//       Provider.of<DraggableWidgetNotifier>(context, listen: false);
//   _editableItem.giphy = await ModalGifPicker.pickModalSheetGif(
//     context: context,
//     apiKey: giphyKey,
//     rating: GiphyRating.r,
//     sticker: true,
//     backDropColor: Colors.black,
//     crossAxisCount: 3,
//     childAspectRatio: 1.2,
//     topDragColor: Colors.white.withOpacity(0.2),
//   );

//   /// create item of type GIF
//   if (_editableItem.giphy != null) {
//     _editableItem.draggableWidget.add(EditableItem()
//       ..type = ItemType.gif
//       //..gif = _editableItem.giphy!
//       ..position = const Offset(0.0, 0.0));
//   }
// }

/// custom exit dialog
Future<bool> exitDialog(
    {required context,
    required contentKey,
    required ThemeType themeType}) async {
  return (await showDialog(
        context: context,
        barrierDismissible: true,
        builder: (c) => Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 190.0,
            decoration: BoxDecoration(
              color: themeType == ThemeType.light ? Colors.white : const Color(0xFF262626),
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Flex(
              direction: Axis.vertical,
              mainAxisSize: MainAxisSize.max,
              children: [
                Flexible(
                  child: Container(
                    height: 80.0,
                    decoration: const BoxDecoration(),
                    child: Flex(
                      direction: Axis.vertical,
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 20.0, 0.0),
                            child: Flex(
                              direction: Axis.horizontal,
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Flexible(
                                  child: Text(
                                    VSStoryDesignerLocalizations.of(context).discardEdits,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: themeType == ThemeType.light ? Colors.black : Colors.white,
                                      fontSize: 13.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(20.0, 10.0, 20.0, 0.0),
                            child: Flex(
                              direction: Axis.horizontal,
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Flexible(
                                  child: Text(
                                    VSStoryDesignerLocalizations.of(context).discardWarning,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: themeType == ThemeType.light ? Colors.grey : Colors.white54,
                                      fontSize: 11.0,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 20.0, 0.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop(true);
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 40.0,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 246, 152, 68),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      alignment: const AlignmentDirectional(0.0, 0.0),
                      child: Text(
                        VSStoryDesignerLocalizations.of(context).discard,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(20.0, 10.0, 20.0, 20.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop(false);
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 40.0,
                      decoration: BoxDecoration(
                        color: themeType == ThemeType.light ? Colors.grey[200] : Colors.grey[800],
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      alignment: const AlignmentDirectional(0.0, 0.0),
                      child: Text(
                        VSStoryDesignerLocalizations.of(context).cancel,
                        style: TextStyle(
                          color: themeType == ThemeType.light ? Colors.black87 : Colors.white,
                          fontSize: 12.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      )) ??
      false;
}

_resetDefaults({required BuildContext context}) {
  final _paintingProvider =
      Provider.of<PaintingNotifier>(context, listen: false);
  final _widgetProvider =
      Provider.of<DraggableWidgetNotifier>(context, listen: false);
  final _controlProvider = Provider.of<ControlNotifier>(context, listen: false);
  final _editingProvider =
      Provider.of<TextEditingNotifier>(context, listen: false);
  _paintingProvider.lines.clear();
  _widgetProvider.draggableWidget.clear();
  _widgetProvider.setDefaults();
  _paintingProvider.resetDefaults();
  _editingProvider.setDefaults();
  _controlProvider.mediaPath = '';
}

_dispose({required context, required message}) {
  _resetDefaults(context: context);
  showToast(message);
  Navigator.of(context).pop(true);
}
