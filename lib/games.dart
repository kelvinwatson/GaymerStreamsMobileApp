import 'package:flutter/material.dart';

class Games extends StatefulWidget {
  var _homeScreenState;

  Games(_homeScreenState) {
    this._homeScreenState = _homeScreenState;
  }

  @override
  _GamesState createState() => new _GamesState(_homeScreenState);
}

class _GamesState extends State<Games> {
  var _homeScreenState;
  String selectedGame = 'All Games';

  _GamesState(_homeScreenState) {
    this._homeScreenState = _homeScreenState;
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: new ListTile(
        title: const Text('Select game:'),
        trailing: new DropdownButton<String>(
          value: selectedGame,
          onChanged: (String selection) {
            setState(() {
              selectedGame = selection;
            });
            debugPrint('call parent with $selection');
          },

          //TODO FIXME Populate with Firebase game list
          items: <String>[
            'All Games',
            'One',
            'Two',
            'Free',
            'Four',
            'Can',
            'I',
            'Have',
            'A',
            'Little',
            'Bit',
            'More',
            'Five',
            'Six',
            'Seven',
            'Eight',
            'Nine',
            'Ten'
          ].map((String value) {
            return new DropdownMenuItem<String>(
              value: value,
              child: new Text(value),
            );
          }).toList(),
        ),
      ),
    );
  }
}
