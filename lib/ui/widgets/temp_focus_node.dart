import 'package:flutter/material.dart';

class TempFocusNode extends FocusNode {
  TempFocusNode({FocusNode? lastNode}) : _lastNode = lastNode;
  FocusNode? _lastNode;
  void focus(BuildContext context) {
    _lastNode ??= FocusScope.of(context).focusedChild;
    super.requestFocus();
  }

  @override
  void unfocus({UnfocusDisposition disposition = UnfocusDisposition.scope}) {
    super.unfocus(disposition: disposition);
    final lastNode = _lastNode;
    if (lastNode != null) {
      if (lastNode.canRequestFocus) {
        lastNode.requestFocus();
      }
    }
  }
}
