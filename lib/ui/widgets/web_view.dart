import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:webviewx/webviewx.dart';

class WebView extends StatelessWidget {
  const WebView({super.key, required this.uri});
  final Uri uri;

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return _WebView(uri: uri);
    } else {
      return const SizedBox();
    }
  }
}

class _WebView extends StatefulWidget {
  const _WebView({required this.uri});
  final Uri uri;

  @override
  State<_WebView> createState() => _WebViewState();
}

class _WebViewState extends State<_WebView> {
  WebViewXController? _controller;
  set controller(WebViewXController value) {
    _controller ??= value
      ..loadContent(widget.uri.toString(), SourceType.urlBypass);
  }

  @override
  Widget build(BuildContext context) {
    final data = MediaQuery.of(context);
    return LayoutBuilder(
      builder: (p0, p1) {
        return WebViewX(
          width: p1.maxWidth,
          height: p1.maxHeight - data.padding.bottom,
          ignoreAllGestures: true,
          initialMediaPlaybackPolicy:
              AutoMediaPlaybackPolicy.requireUserActionForAllMediaTypes,
          onWebViewCreated: (controller) {
            _controller ??= controller;
          },
        );
      },
    );
  }
}
