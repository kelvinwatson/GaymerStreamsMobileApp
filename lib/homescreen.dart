import 'package:flutter/material.dart';
import 'package:gaymerstreams/app_tabs.dart';

class HomeScreen extends StatefulWidget {
  final String title;

  HomeScreen({Key key, this.title}) : super(key: key);

  @override
  _HomeScreenState createState() => new _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void onGaymerSubmitted(String text) {
    debugPrint('onAddGaymerInputChanged $text');
    //TODO: call Firebase
  }

  @override
  Widget build(BuildContext context) {
    return new AppTabs(this);
  }
}
