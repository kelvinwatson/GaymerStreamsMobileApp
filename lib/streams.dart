import 'package:flutter/material.dart';

class Streams extends StatelessWidget {
  var _homeScreenState;

  Streams(_homeScreenState) {
    this._homeScreenState = _homeScreenState;
  }

  List<CircleAvatar> _buildGridTileList(int count) {
    return new List<CircleAvatar>.generate(
        count,
        (int index) => new CircleAvatar(
            backgroundImage: new NetworkImage(
                'https://images.pexels.com/photos/724216/pexels-photo-724216.jpeg?w=940&h=650&dpr=2&auto=compress&cs=tinysrgb')));
  }

  Widget _buildGrid(context) {
    final Orientation orientation = MediaQuery.of(context).orientation;
    return new GridView.count(
        crossAxisCount: (orientation == Orientation.portrait) ? 2 : 3,
        padding: const EdgeInsets.all(0.0),
        mainAxisSpacing: 4.0,
        crossAxisSpacing: 4.0,
        childAspectRatio: (orientation == Orientation.portrait) ? 1.0 : 1.3,
        children: _buildGridTileList(30));
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: _buildGrid(context),
    );
  }
}
