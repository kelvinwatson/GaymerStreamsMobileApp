class Game {
  int streamerCount;
  final String name;
  final bool selected;

  Game({this.name, this.selected});

  Game.fromSnapshot(Map map) : name = map['name'];
}
