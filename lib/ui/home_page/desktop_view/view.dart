import 'dart:math';

import 'package:flutter/material.dart';

import 'deck_row.dart';
import 'page_grid.dart';
import 'page_switch_drag_target.dart';
import 're_layout.dart';
import 'touch_protect.dart';

class View extends StatefulWidget {
  const View({super.key, required this.constraints});
  final BoxConstraints constraints;

  @override
  State<View> createState() => _ViewState();
}

class _ViewState extends State<View> {
  late PageController _controller;
  var _page = 0;

  @override
  void initState() {
    super.initState();
    _controller = PageController(initialPage: _page)
      ..addListener(() {
        final page = _controller.page;
        if (page != null) {
          final p = page.round();
          if (p != _page) {
            setState(() {
              _page = p;
            });
          }
        }
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final data = MediaQuery.of(context);
    final orderData =
        context.dependOnInheritedWidgetOfExactType<ReLayoutData>()!.orderData;
    final pagesData = orderData.pagesData;
    final gridHeight =
        widget.constraints.maxHeight - data.padding.top - 112 - 32;
    final gridWidth = widget.constraints.maxWidth;
    final gridRows = min((gridHeight / 96).floor(), 4);
    final gridColumns = (gridWidth / 160).floor().clamp(4, 6);
    final horizontalPadding =
        (gridWidth - gridColumns * 64) / (gridColumns + 1) / 2;
    return Focus(
      autofocus: true,
      child: Column(
        children: [
          SizedBox(height: data.padding.top),
          Expanded(
            child: TouchProtect(
              child: PageView(
                controller: _controller,
                clipBehavior: Clip.none,
                children: [
                  for (var i = 0; i < pagesData.length; i++)
                    PageSwitchDragTarget(
                      horizontalPadding: horizontalPadding,
                      controller: _controller,
                      pageIndex: i,
                      pageCount: pagesData.length,
                      child: PageGrid(
                        rows: gridRows,
                        columns: gridColumns,
                        data: pagesData[i],
                        pageIndex: i,
                      ),
                    ),
                ],
              ),
            ),
          ),
          // height: 32
          Center(
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Material(
                color: Colors.transparent,
                shape: const StadiumBorder(),
                child: SizedBox(
                  height: 24,
                  width: 21.0 * pagesData.length,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      for (var i = 0; i < pagesData.length; i++)
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color:
                                Colors.white.withOpacity(_page == i ? 1 : 0.3),
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // height: 112
          SizedBox(
            height: 112,
            child: DeckRow(data: orderData.deckData),
          ),
        ],
      ),
    );
  }
}
