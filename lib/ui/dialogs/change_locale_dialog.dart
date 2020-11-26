import 'package:flutter/material.dart';
import 'package:my_web/core/services/locale_service.dart';

showChangeLocaleDialog(BuildContext context, Locale locale) {
  return Navigator.of(context).push(PageRouteBuilder(
    opaque: false,
    pageBuilder: (context, animation, secondaryAnimation) {
      return _Page(locale: locale);
    },
    transitionDuration: Duration.zero,
    reverseTransitionDuration: Duration.zero,
  ));
}

class _Page extends StatefulWidget {
  const _Page({Key key, this.locale}) : super(key: key);

  final Locale locale;

  @override
  __PageState createState() => __PageState();
}

class __PageState extends State<_Page>
    with SingleTickerProviderStateMixin<_Page> {
  AnimationController _controller;
  CurvedAnimation _curvedAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    _controller.animateTo(1.0).then(_changeLocal);
    _curvedAnimation = CurvedAnimation(
        curve: Curves.fastOutSlowIn,
        reverseCurve: Curves.fastOutSlowIn,
        parent: _controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  _changeLocal([value]) async {
    if (!mounted) return;
    LocaleService.of(context).changeLocale(widget.locale);
    await Future.delayed(const Duration(milliseconds: 350));
    await _controller.animateBack(0.0);
    if (!mounted) return;
    final navigator = Navigator.of(context);
    if (navigator.canPop()) navigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _controller,
      child: Material(
        child: Center(
          child: ScaleTransition(
            alignment: Alignment.center,
            scale: Tween(begin: 1.5, end: 1.0).animate(_curvedAnimation),
            child: const Icon(
              Icons.translate,
              size: 108,
            ),
          ),
        ),
      ),
    );
  }
}
