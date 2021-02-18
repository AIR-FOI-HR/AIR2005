//based on https://blog.gskinner.com/archives/2020/02/flutter-widgetview-a-simple-separation-of-layout-and-logic.html
import 'package:flutter/material.dart';

abstract class WidgetView<T1, T2> extends StatelessWidget {
  final T2 state;

  T1 get widget => (state as State).widget as T1;

  const WidgetView(this.state, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context);
}