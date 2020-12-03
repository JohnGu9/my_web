import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';

class RiveBoard extends StatefulWidget {
  const RiveBoard({Key key, @required this.path}) : super(key: key);

  final String path;

  @override
  _RiveBoardState createState() => _RiveBoardState();
}

class _RiveBoardState extends State<RiveBoard> {
  Artboard _riveArtboard;
  RiveAnimationController _controller;

  _onLoaded(data) async {
    final file = RiveFile();

    // Load the RiveFile from the binary data.
    if (file.import(data)) {
      // The artboard is the root of the animation and gets drawn in the
      // Rive widget.
      final artboard = file.mainArtboard;
      // Add a controller to play back a known animation on the main/default
      // artboard.We store a reference to it so we can toggle playback.
      artboard.addController(_controller);
      setState(() => _riveArtboard = artboard);
      _controller.isActive = true;
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = SimpleAnimation('normal');
    rootBundle.load(widget.path)..then(_onLoaded);
  }

  @override
  void didUpdateWidget(covariant RiveBoard oldWidget) {
    if (oldWidget.path != widget.path)
      rootBundle.load(widget.path)..then(_onLoaded);
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _riveArtboard == null
        ? const SizedBox()
        : Rive(artboard: _riveArtboard);
  }
}
