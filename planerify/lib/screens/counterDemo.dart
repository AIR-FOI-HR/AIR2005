import 'package:flutter/material.dart';

////////////////////////////////////////////////////////
/// Widget defines external parameters
////////////////////////////////////////////////////////
class MyCounter extends StatefulWidget {
  final Color textColor;

  const MyCounter({Key key, this.textColor}) : super(key: key);

  @override
  _MyCounterController createState() => _MyCounterController();
}

////////////////////////////////////////////////////////
/// Controller holds state, and all business logic
////////////////////////////////////////////////////////
class _MyCounterController extends State<MyCounter> {
  int counter = 0;

  @override
  Widget build(BuildContext context) => _MyCounterView(this);

  void handleCounterPressed() => setState(() => counter += 1);
}

////////////////////////////////////////////////////////
/// View is dumb, and purely declarative.
/// Easily references values on the controller and widget
////////////////////////////////////////////////////////
class _MyCounterView extends StatelessWidget {
  final _MyCounterController state;
  const _MyCounterView(this.state, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: state.handleCounterPressed,
      child: Text(
        "${state.counter}",
        style: TextStyle(color: state.widget.textColor),
      ),
    );
  }
}