// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:perfect_freehand/perfect_freehand.dart';
import 'package:provider/provider.dart';
import 'package:vs_story_designer/src/domain/models/painting_model.dart';
import 'package:vs_story_designer/src/domain/providers/notifiers/control_provider.dart';
import 'package:vs_story_designer/src/domain/providers/notifiers/painting_notifier.dart';
import 'package:vs_story_designer/src/presentation/painting_view/widgets/sketcher.dart';
import 'package:vs_story_designer/src/presentation/painting_view/widgets/top_painting_tools.dart';
import 'package:vs_story_designer/src/presentation/widgets/color_selector.dart';
import 'package:vs_story_designer/src/presentation/widgets/size_slider_selector.dart';

class Painting extends StatefulWidget {
  const Painting({super.key});

  @override
  State<Painting> createState() => _PaintingState();
}

class _PaintingState extends State<Painting> {
  StreamController<List<PaintingModel>>? _linesStreamController;
  StreamController<PaintingModel>? _currentLineStreamController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final paintingNotifier = Provider.of<PaintingNotifier>(context, listen: false);
      _linesStreamController = StreamController<List<PaintingModel>>.broadcast();
      _currentLineStreamController = StreamController<PaintingModel>.broadcast();
      paintingNotifier
        ..linesStreamController = _linesStreamController!
        ..currentLineStreamController = _currentLineStreamController!;
    });
  }

  @override
  void dispose() {
    _linesStreamController?.close();
    _currentLineStreamController?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    PaintingModel? line;
    final screenSize = MediaQueryData.fromView(WidgetsBinding.instance.window);
    final maxHeight = Platform.isIOS
        ? (screenSize.size.height - 132) - screenSize.viewPadding.top
        : screenSize.size.height - 132;

    /// on gestures start
    void _onPanStart(DragStartDetails details,
        PaintingNotifier paintingNotifier, ControlNotifier controlProvider) {
      if (!mounted) return;
      
      final box = context.findRenderObject() as RenderBox;
      final point = box.globalToLocal(details.globalPosition);
      if (point.dy < 4 || point.dy > maxHeight) return;

      line = PaintingModel(
        [PointVector(point.dx, point.dy)],
        paintingNotifier.lineWidth,
        1,
        1,
        false,
        controlProvider.colorList![paintingNotifier.lineColor],
        1,
        true,
        paintingNotifier.paintingType);
      paintingNotifier.currentLineStreamController.add(line!);
    }

    /// on gestures update
    void _onPanUpdate(DragUpdateDetails details,
        PaintingNotifier paintingNotifier, ControlNotifier controlNotifier) {
      if (!mounted || line == null) return;

      final box = context.findRenderObject() as RenderBox;
      final point = box.globalToLocal(details.globalPosition);
      if (point.dy < 6 || point.dy > maxHeight) return;

      final points = [...line!.points, PointVector(point.dx, point.dy)];
      line = PaintingModel(
        points,
        paintingNotifier.lineWidth,
        1,
        1,
        false,
        controlNotifier.colorList![paintingNotifier.lineColor],
        1,
        true,
        paintingNotifier.paintingType);
      paintingNotifier.currentLineStreamController.add(line!);
    }

    /// on gestures end
    void _onPanEnd(DragEndDetails details, PaintingNotifier paintingNotifier) {
      if (!mounted || line == null) return;

      paintingNotifier.lines = List.from(paintingNotifier.lines)..add(line!);
      line = null;
      paintingNotifier.linesStreamController.add(paintingNotifier.lines);
    }

    /// paint current line
    Widget _renderCurrentLine(BuildContext context,
        PaintingNotifier paintingNotifier, ControlNotifier controlNotifier) {
      return GestureDetector(
        onPanStart: (details) {
          _onPanStart(details, paintingNotifier, controlNotifier);
        },
        onPanUpdate: (details) {
          _onPanUpdate(details, paintingNotifier, controlNotifier);
        },
        onPanEnd: (details) {
          _onPanEnd(details, paintingNotifier);
        },
        child: RepaintBoundary(
          child: SafeArea(
            child: Align(
              alignment: Alignment.topCenter,
              child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  width: MediaQuery.of(context).size.width,
                  height: Platform.isIOS
                      ? (screenSize.size.height - 132) -
                          screenSize.viewPadding.top
                      : MediaQuery.of(context).size.height - 132,
                  child: StreamBuilder<PaintingModel>(
                      stream:
                          paintingNotifier.currentLineStreamController.stream,
                      builder: (context, snapshot) {
                        return CustomPaint(
                          painter: Sketcher(
                            lines: line == null ? [] : [line!],
                          ),
                        );
                      })),
            ),
          ),
        ),
      );
    }

    /// return Painting board
    return Consumer2<ControlNotifier, PaintingNotifier>(
      builder: (context, controlNotifier, paintingNotifier, child) {
        return PopScope(
          onPopInvoked: (val) async {
            controlNotifier.isPainting = false;
            WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              paintingNotifier.closeConnection();
            });
            // return true;
          },
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Stack(
              children: [
                /// render current line
                _renderCurrentLine(context, paintingNotifier, controlNotifier),

                /// select line width
                const Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 140),
                    child: SizeSliderWidget(),
                  ),
                ),

                /// top painting tools
                const SafeArea(child: TopPaintingTools()),

                /// color picker
                const Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 110),
                    child: ColorSelector(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
