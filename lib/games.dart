import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class GameItem extends StatelessWidget {
  int streamerCount = 0;
  String name;

  GameItem({this.name});

  final DataSnapshot snapshot;
  final Animation animation;

  @override
  Widget build(BuildContext context) {
    return new SizeTransition(
//      sizeFactor: new CurvedAnimation(parent: animation, curve: Curves.easeOut),
      axisAlignment: 0.0,
      child: new Container(
          margin: const EdgeInsets.symmetric(vertical: 10.0),
          child: new Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Container(
                  margin: const EdgeInsets.only(right: 16.0),
                  child: new CircleAvatar(
                      backgroundColor:
                          Colors.red), //todo replace with game image?
                ),
                new Column(
                    //https://flutterdoc.com/widgets-column-e129769fbcb3
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new Text(name,
                          style: Theme.of(context).textTheme.subhead),
                      new Container(
                        margin: const EdgeInsets.only(top: 5.0),
                        child: new Text(name),
                      )
                    ]),
              ])),
    );
  }
}

class Games extends StatelessWidget {
  var parentState;
  final List<GameItem> gameItems;

  Games({this.parentState, this.gameItems});

  _filterByGame(String game) {
    parentState.onGameSelected(game);
  }

  List<Widget> _buildList() {
    return new List<Widget>.generate(gameItems.length, (int index) {
      GameItem gItem = gameItems.elementAt(index);
      int numViewers = gItem.streamerCount;
      return new Stack(children: <Widget>[
        new ListTile(
          enabled: numViewers > 0 || gItem.name == 'All Games',
          onTap: () => _filterByGame(gItem.name),
          title: new Text(gItem.name),
          //        subtitle: new Text('85 W Portal Ave'),
          trailing: numViewers > 0
              ? new Text('$numViewers streamer${numViewers == 1 ? '' : 's'}')
              : null,
        ),
        new Positioned.fill(
            child: new Material(
                color: Colors.transparent,
                child: new InkWell(
                  splashColor: Colors.lightGreenAccent,
                  onTap: () => _filterByGame(gItem.name),
                ))),
      ]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return new ListView(
      children: _buildList(),
    );
  }
}
