import 'dart:math';

import 'package:flutter/material.dart';
import 'package:my_web/ui/home_page/desktop_view/lock_view_page_grid.dart';
import 'package:my_web/ui/home_page/lock_view.dart';

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

  _onPageChange() {
    final page = _controller.page;
    if (page != null) {
      final p = page.round();
      if (p != _page) {
        setState(() {
          _page = p;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = PageController(initialPage: _page)
      ..addListener(_onPageChange);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final data = MediaQuery.of(context);
    final lockViewData =
        context.dependOnInheritedWidgetOfExactType<LockViewData>()!;
    final reLayout =
        context.dependOnInheritedWidgetOfExactType<ReLayoutData>()!;
    final pagesData = reLayout.orderData.pagesData;
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
              child: PageSwitchDragTarget(
                controller: _controller,
                horizontalPadding: horizontalPadding * 2,
                pageCount: pagesData.length,
                child: PageView.builder(
                  controller: _controller,
                  clipBehavior: Clip.none,
                  itemCount: pagesData.length,
                  itemBuilder: lockViewData.isLocking
                      ? (context, i) {
                          final data = pagesData[i];
                          return Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: horizontalPadding,
                            ),
                            child: LockViewPageGrid(
                              rows: gridRows,
                              columns: gridColumns,
                              data: data,
                              animation: lockViewData.animation,
                            ),
                          );
                        }
                      : (context, i) {
                          final data = pagesData[i];
                          return Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: horizontalPadding,
                            ),
                            child: PageGrid(
                              rows: gridRows,
                              columns: gridColumns,
                              data: data,
                              pageIndex: i,
                              reLayout: reLayout,
                            ),
                          );
                        },
                ),
              ),
            ),
          ),
          // height: 32
          SizedBox(
            height: 32,
            child: Center(
              child: SizedBox(
                height: 24,
                width: 21.0 * pagesData.length,
                child: Material(
                  color: Colors.transparent,
                  shape: const StadiumBorder(),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      for (var i = 0; i < pagesData.length; i++)
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(
                              _page == i ? 1 : 0.3,
                            ),
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
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 1),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: lockViewData.animation,
                curve: Curves.easeOut,
              )),
              child: DeckRow(data: reLayout.orderData.deckData),
            ),
          ),
        ],
      ),
    );
  }
}
