@JS()
library interop_lib;

import 'package:js/js.dart';
import 'package:js/js_util.dart';

_setJsProperty(object, key, value) {
  if (value is Map)
    setProperty(object, key, _mapToJson(value));
  else if (value is Function)
    setProperty(object, key, allowInterop(value));
  else
    setProperty(object, key, value);
}

_mapToJson(final Map map) {
  final object = newObject();
  map.forEach((key, value) => _setJsProperty(object, key, value));
  return object;
}

invokeMethod(final String method, [arguments]) {
  final object = newObject();
  setProperty(object, 'method', method);
  _setJsProperty(object, 'arguments', arguments);
  onInvokeMethod(object);
}

bind(final String method, final Function fn) {
  assert(method.isNotEmpty);
  try {
    bindFunction(method, allowInterop(fn));
  } catch (error) {
    print('Failed to bind function. ');
    return false;
  }
  return true;
}

@JS()
external onInvokeMethod(obj);

@JS()
external bindFunction(final String name, final Function fn);

@JS('FileDescriptor')
// ignore: unused_element
abstract class _FileDescriptor {
  external factory _FileDescriptor(final String name, final data);

  external String get name;
  external List get data;
}

@JS('LogParseResult')
// ignore: unused_element
abstract class _LogParseResult {
  external factory _LogParseResult(final obj);

  external String get src;
  external String get dst;
  external String get srcInfo;
  external String get dstInfo;
  external String get intermediate;
  external String get ueName;
}

@JS()
external logParseFunctionWrapper(final String line);
