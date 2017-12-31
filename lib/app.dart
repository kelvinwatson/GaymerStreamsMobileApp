import 'package:flutter/material.dart';
import 'package:gaymerstreams/homescreen.dart';

final ThemeData kIOSTheme = new ThemeData(
  primarySwatch: Colors.orange,
  primaryColor: Colors.grey[100],
  accentColor: Colors.orange,
  accentColorBrightness: Brightness.light,
  primaryColorBrightness: Brightness.light,
  highlightColor: Colors.orange,
);

final ThemeData kDefaultTheme = new ThemeData(
  primarySwatch: Colors.blue,
  accentColor: Colors.orangeAccent[400],
);

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Gaymer Streams',
      theme: Theme.of(context).platform == TargetPlatform.iOS
          ? kIOSTheme
          : kDefaultTheme,
      home: new HomeScreen(title: 'Gaymer Streams'),
    );
  }
}
