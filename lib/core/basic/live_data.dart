import 'dart:async';
import 'package:flutter/foundation.dart';

class LiveData<T> extends ValueNotifier<T> implements Future<T> {
  LiveData({T initial, @required Future<T> future})
      : this._future = future ?? Future.value(initial),
        this._isCompleted = false,
        super(initial) {
    _controller.add(initial);
    addListener(() {
      _controller.add(value);
      _isCompleted = true;
    });
    future?.then((value) => this.value = value);
  }
  Future<T> _future;
  bool _isCompleted;
  bool get isCompleted {
    return _isCompleted;
  }

  set future(Future<T> newFuture) {
    if (_future != newFuture) {
      _isCompleted = false;
      () async {
        await _future;
        _future = newFuture;
        value = await _future;
      }();
    }
  }

  final StreamController<T> _controller = StreamController();

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

  @override
  Stream<T> asStream() {
    return _controller.stream;
  }

  @override
  Future<T> catchError(Function onError, {bool test(Object error)}) {
    return _future.catchError(onError, test: test);
  }

  @override
  Future<R> then<R>(FutureOr<R> onValue(T value), {Function onError}) {
    return _future.then(onValue, onError: onError);
  }

  @override
  Future<T> timeout(Duration timeLimit, {FutureOr<T> Function() onTimeout}) {
    return _future.timeout(timeLimit, onTimeout: onTimeout);
  }

  @override
  Future<T> whenComplete(FutureOr<void> Function() action) {
    return _future.whenComplete(action);
  }
}
