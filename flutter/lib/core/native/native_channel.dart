import 'dart:async';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html';

import 'package:flutter/material.dart';
import 'native_function.dart' as Native;

// ignore: must_be_immutable
class NativeChannel extends InheritedWidget {
  static NativeChannel of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<NativeChannel>()!;
  }

  static final StreamController _controller = StreamController.broadcast();

  static dispose() {
    return _controller.close();
  }

  NativeChannel({required Widget child}) : super(child: child);

  Future<bool> get isMobile {
    final completer = Completer<bool>();
    Native.invokeMethod('isMobile', {'callback': completer.complete});
    return completer.future;
  }

  Future<bool> get isIOS {
    final completer = Completer<bool>();
    Native.invokeMethod('isIOS', {'callback': completer.complete});
    return completer.future;
  }

  Future openFileDialog({final bool? multiple, final String? accept}) async {
    final Completer completer = Completer();
    await Native.invokeMethod('openFileDialog', {
      'callback': completer.complete,
      'multiple': multiple == true ? 'multiple' : null,
      'accept': accept,
    });
    return completer.future;
  }

  alert(final String message) {
    return Native.invokeMethod('alert', message);
  }

  Stream upgrade() {
    final StreamController controller = StreamController.broadcast();
    controller.stream.listen((event) {
      if (event is int) controller.close();
    });
    Native.invokeMethod('upgrade', {'callback': controller.add});
    return controller.stream;
  }

  openDevTool() {
    final Completer completer = Completer();
    Native.invokeMethod('openDevTool', {'callback': completer.complete});
    return completer.future;
  }

  reload() {
    return Native.invokeMethod('reload');
  }

  @visibleForTesting
  invokeMethod(final String method, final arguments) {
    return Native.invokeMethod(method, arguments);
  }

  setLogParseFunction(final String function) {
    return Native.invokeMethod('setLogParseFunction', function);
  }

  logParseFunction(final String line) {
    return Native.logParseFunctionWrapper(line);
  }

  Future<String> getBrowserType() {
    final completer = Completer<String>();
    Native.invokeMethod('getBrowserType', {'callback': completer.complete});
    return completer.future;
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return oldWidget != this;
  }

  ValueNotifier<bool> fullscreenChanged = ValueNotifier(false);
  bool get fullscreen {
    return fullscreenChanged.value;
  }

  set fullscreen(bool newValue) {
    newValue ? requestFullscreen() : exitFullscreen();
  }

  void requestFullscreen() {
    document.documentElement?.requestFullscreen();
    fullscreenChanged.value = true;
  }

  void exitFullscreen() {
    document.exitFullscreen();
    fullscreenChanged.value = false;
  }

  bool get isWeb {
    return true;
  }
}
