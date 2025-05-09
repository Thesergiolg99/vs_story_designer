// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:vs_media_picker/vs_media_picker.dart';
import 'package:vs_story_designer/src/domain/providers/notifiers/control_provider.dart';
import 'package:vs_story_designer/src/domain/providers/notifiers/draggable_widget_notifier.dart';
import 'package:vs_story_designer/src/domain/providers/notifiers/painting_notifier.dart';
import 'package:vs_story_designer/src/domain/providers/notifiers/scroll_notifier.dart';
import 'package:vs_story_designer/src/domain/sevices/save_as_image.dart';
import 'package:vs_story_designer/src/presentation/utils/constants/item_type.dart';
import 'package:vs_story_designer/src/presentation/utils/constants/text_animation_type.dart';
import 'package:vs_story_designer/src/presentation/widgets/animated_onTap_button.dart';

// import 'package:vs_story_designer/src/presentation/widgets/tool_button.dart';

class BottomTools extends StatelessWidget {
  final GlobalKey contentKey;
  final Function(dynamic imageUri) onDone;
  final Widget? onDoneButtonStyle;
  final Function? renderWidget;
  final Widget placeButtonWidget;
  final Widget mentionButtonWidget;

  /// editor background color
  final Color? editorBackgroundColor;
  const BottomTools({
    super.key,
    required this.contentKey,
    required this.onDone,
    this.renderWidget,
    this.onDoneButtonStyle,
    this.editorBackgroundColor,
    required this.placeButtonWidget,
    required this.mentionButtonWidget,
  });

  @override
  Widget build(BuildContext context) {
    var _size = MediaQuery.of(context).size;
    bool _createVideo = false;
    return Consumer4<ControlNotifier, ScrollNotifier, DraggableWidgetNotifier,
        PaintingNotifier>(
      builder: (_, controlNotifier, scrollNotifier, itemNotifier,
          paintingNotifier, __) {
        return Container(
          height: 95,
          decoration: const BoxDecoration(color: Colors.transparent),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              /// preview gallery
              placeButtonWidget,
              // if (controlNotifier.mediaPath.isEmpty)
              //   _selectColor(
              //       controlProvider: controlNotifier,
              //       onTap: () {
              //         if (controlNotifier.gradientIndex >=
              //             controlNotifier.gradientColors!.length - 1) {
              //           setState() {
              //             controlNotifier.gradientIndex = 0;
              //           }
              //         } else {
              //           setState() {
              //             controlNotifier.gradientIndex += 1;
              //           }
              //         }
              //       }),

              /// center logo
              mentionButtonWidget,

              /// save final image to gallery

              AnimatedOnTapButton(
                  onTap: () async {
                    String pngUri;
                    if (paintingNotifier.lines.isNotEmpty ||
                        itemNotifier.draggableWidget.isNotEmpty) {
                      showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Card(
                                    color: Colors.white,
                                    child: Container(
                                        padding: const EdgeInsets.all(50),
                                        child:
                                            const CircularProgressIndicator())),
                              ],
                            );
                          });

                      for (var element in itemNotifier.draggableWidget) {
                        if (element.type == ItemType.gif ||
                            element.animationType != TextAnimationType.none) {
                          // setState(() {
                          _createVideo = true;
                          // });
                        }
                      }
                      if (_createVideo) {
                        debugPrint('creating video');
                        await renderWidget!();
                      } else {
                        debugPrint('creating image');
                        await takePicture(
                                contentKey: contentKey,
                                context: context,
                                saveToGallery: false,
                                fileName: controlNotifier.folderName)
                            .then((bytes) {
                          Navigator.of(context, rootNavigator: true).pop();
                          if (bytes != null) {
                            pngUri = bytes;
                            onDone(bytes);
                          } else {
                            // ignore: avoid_print
                            print("error");
                          }
                        });
                      }
                    } else {
                      showToast('Design something to save image');
                    }
                    // setState(() {
                    _createVideo = false;
                    // });
                  },
                  child: onDoneButtonStyle ??
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border:
                                Border.all(color: Colors.white, width: 1.5)),
                        child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: 0, right: 2),
                                child: Icon(Icons.share_sharp, size: 28),
                              ),
                            ]),
                      ))

              // Padding(
              //   padding: const EdgeInsets.only(right: 10),
              //   child: Container(
              //     width: _size.width / 4,
              //     alignment: Alignment.centerRight,
              //     padding: const EdgeInsets.only(right: 0),
              //     child: Transform.scale(
              //       scale: 0.9,
              //       child: StatefulBuilder(
              //         builder: (_, setState) {
              //         },
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        );
      },
    );
  }

  Widget _preViewContainer({child}) {
    return Container(
      height: 45,
      width: 45,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(width: 1.4, color: Colors.white)),
      child: child,
    );
  }

  // /bagr  colors

  // Widget _selectColor({onTap, controlProvider}) {
  //   return Padding(
  //     padding: const EdgeInsets.only(left: 5, right: 0, top: 0),
  //     child: AnimatedOnTapButton(
  //       onTap: onTap,
  //       child: Container(
  //         padding: const EdgeInsets.all(2),
  //         decoration: BoxDecoration(
  //             // border: Border.all(
  //             //   color: Colors.white,
  //             // ),
  //             // borderRadius: BorderRadius.circular(8)
  //             // // shape: BoxShape.circle,
  //             ),
  //         child: Container(
  //           width: 45,
  //           height: 45,
  //           decoration: BoxDecoration(
  //             border: Border.all(
  //               color: Colors.white,
  //             ),
  //             borderRadius: BorderRadius.circular(8),

  //             gradient: LinearGradient(
  //                 begin: Alignment.topLeft,
  //                 end: Alignment.bottomRight,
  //                 colors: controlProvider
  //                     .gradientColors![controlProvider.gradientIndex]),
  //             // border: Border.all(
  //             //     // color: Colors.white,
  //             //     ),
  //             //  shape: BoxShape.circle,
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }
}
