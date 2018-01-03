import 'package:flutter/material.dart';

class GameItem extends StatelessWidget {
  final int streamerCount;
  final String name;

  GameItem({this.name, this.streamerCount});

  @override
  Widget build(BuildContext context) {
    return new Container(
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
                    new Text(name, style: Theme.of(context).textTheme.subhead),
                    new Container(
                      margin: const EdgeInsets.only(top: 5.0),
                      child: new Text(name),
                    )
                  ]),
            ]));
  }
}

class Games extends StatelessWidget {
  final parentState;
  final List<GameItem> gameItems;

  Games({this.parentState, this.gameItems});

  _filterByGame(String game) {
    parentState.onGameSelected(game);
  }

  List<Widget> _buildList() {
    return new List<Widget>.generate(gameItems.length, (int index) {
      GameItem gItem = gameItems.elementAt(index);
      int viewers = gItem.streamerCount;
      return new Stack(children: <Widget>[
        new ListTile(
          enabled: viewers > 0 || gItem.name == 'All Games',
          onTap: () => _filterByGame(gItem.name),
          title: new Text(gItem.name),
          //        subtitle: new Text('85 W Portal Ave'),
          trailing: viewers > 0
              ? new Text('$viewers streamer${viewers == 1 ? '' : 's'}')
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
