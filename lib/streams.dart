import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gaymerstreams/analytics_util.dart';
import 'package:url_launcher/url_launcher.dart';

class StreamItem {
  final String imageSrc;
  final String displayName;
  final String gameName;
  final String caption;
  int numViewers;

  StreamItem.fromTwitchApi(Map map)
      : imageSrc = map['preview']['medium'],
        displayName = map['channel']['display_name'],
        gameName = map['game'],
        caption = map['channel']['status'];
}

class Streams extends StatelessWidget {
  final parentState;
  final String gameName;
  final List<StreamItem> liveStreamItems;
  final AnalyticsUtil analyticsUtil = new AnalyticsUtil();

  Streams({this.parentState, this.gameName, this.liveStreamItems});

  _launchStream(String suffix) {
    analyticsUtil.trackEvent(eventName: 'launch_stream', parameters: {
      'twitchName': suffix,
    });

    launch('https://twitch.tv/$suffix');
  }

  List<Widget> _buildGridTileList() {
    if (liveStreamItems == null || liveStreamItems.length <= 0) {
      return new List<Widget>();
    }

    return new List<Widget>.generate(liveStreamItems.length, (int index) {
      StreamItem s = liveStreamItems.elementAt(index);
      return new Stack(children: <Widget>[
        new Positioned.fill(
          bottom: 0.0,
          child: new GridTile(
              footer: new GridTileBar(
                title: new Text(s.displayName),
                subtitle: new Text(s.gameName),
                backgroundColor: Colors.black45,
                trailing: new Icon(
                  Icons.launch,
                  color: Colors.white,
                ),
              ),
              child: new Image.network(s.imageSrc, fit: BoxFit.cover)),
        ),
        new Positioned.fill(
            child: new Material(
                color: Colors.transparent,
                child: new InkWell(
                  splashColor: Colors.lightGreenAccent,
                  onTap: () => _launchStream(s.displayName),
                ))),
      ]);
    });
  }

  Widget _buildGrid(context) {
    if (liveStreamItems == null) {
      return new Center(
          child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
            Theme.of(context).platform == TargetPlatform.iOS
                ? new CupertinoActivityIndicator()
                : new CircularProgressIndicator(),
            new Padding(
                padding: new EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 20.0),
                child: new Text('Loading LGBT Twitch Streams')),
          ]));
    } else if (liveStreamItems.length == 0) {
      return new Center(
          child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
            new IconButton(
                onPressed: () => parentState.handleRefresh(context, true),
                icon: new Icon(Icons.refresh)),
            new Padding(
                padding: new EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 20.0),
                child: new Text('No live streams at the moment.')),
          ]));
    } else {
      final Orientation orientation = MediaQuery.of(context).orientation;
      return new Column(children: <Widget>[
        new ListTile(
          title: new Text(
            '${gameName == 'All Games'
                ? 'Streams Currently Live'
                : 'Now streaming $gameName'}',
          ),
          subtitle: new Text(
            '${liveStreamItems.length} active stream${liveStreamItems.length ==
                1 ? '' : 's'}',
          ),
        ),
        new Expanded(
          child: new GridView.count(
              shrinkWrap: true,
              physics: const AlwaysScrollableScrollPhysics(),
              crossAxisCount: (orientation == Orientation.portrait) ? 2 : 3,
              padding: const EdgeInsets.all(0.0),
              mainAxisSpacing: 1.0,
              crossAxisSpacing: 1.0,
              childAspectRatio:
                  (orientation == Orientation.portrait) ? 1.0 : 1.3,
              children: _buildGridTileList()),
        ),
      ]);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Cupertino version of RefreshIndicator being implemented on iOS
    // https://github.com/flutter/flutter/issues/11661
    return _buildGrid(context);
  }
}
