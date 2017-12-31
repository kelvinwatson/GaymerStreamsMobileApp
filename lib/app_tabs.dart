import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gaymerstreams/games.dart';
import 'package:gaymerstreams/add_gaymer.dart';
import 'package:gaymerstreams/streams.dart';

class AppTab {
  const AppTab({this.title, this.icon});

  final String title;
  final IconData icon;
}

const List<AppTab> appTabs = const <AppTab>[
  const AppTab(title: 'LIVE', icon: Icons.games),
  const AppTab(title: 'GAMES', icon: Icons.filter_list),
  const AppTab(title: 'ADD', icon: Icons.add),
];

class AppTabs extends StatefulWidget {
  var homeScreenState;

  AppTabs(this.homeScreenState);

  @override
  State createState() => new _AppTabsState(homeScreenState);
}

class _AppTabsState extends State<AppTabs> {
  var _homeScreenState;
  int _index = 0;

  _AppTabsState(_homeScreenState) {
    this._homeScreenState = _homeScreenState;
  }

  @override
  void initState() {
    super.initState();
    _index = 0;
  }

  Widget _buildGamesView() {
    return new Container(
      child: new Column(
        children: <Widget>[
          new Games(_homeScreenState),
        ],
      ),
    );
  }

  Widget _buildAddStreamerView() {
    return new AddGaymer(_homeScreenState);
  }

  Widget _buildStreamsView() {
    return new Streams(_homeScreenState);
  }

  Widget _buildView(AppTab choice, int iosTabIndex) {
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      switch (iosTabIndex) {
        case 1:
          return _buildGamesView();
        case 2:
          return _buildAddStreamerView();
        default:
          return _buildStreamsView();
      }
    }

    switch (choice.title) {
      case 'GAMES':
        return _buildGamesView();
      case 'ADD':
        return _buildAddStreamerView();
      default:
        return _buildStreamsView();
    }
  }

  @override
  Widget build(BuildContext context) {
    return new DefaultTabController(
      length: appTabs.length,
      child: new Scaffold(
        bottomNavigationBar: Theme.of(context).platform == TargetPlatform.iOS
            ? new CupertinoTabBar(
                currentIndex: _index,
                onTap: (int _index) {
                  debugPrint('onTap $_index');
                  setState(() {
                    this._index = _index;
                  });
                },
                items: <BottomNavigationBarItem>[
                    new BottomNavigationBarItem(
                      icon: new Icon(Icons.games),
                      title: new Text('Live'),
                    ),
                    new BottomNavigationBarItem(
                      icon: new Icon(Icons.filter_list),
                      title: new Text("Games"),
                    ),
                    new BottomNavigationBarItem(
                      icon: new Icon(Icons.add),
                      title: new Text("Add"),
                    ),
                  ])
            : null,
        appBar: new AppBar(
          title: new Text('Gaymer Streams'),
          bottom: Theme.of(context).platform == TargetPlatform.iOS
              ? null
              : new TabBar(
                  isScrollable: true,
                  tabs: appTabs.map((AppTab appTab) {
                    return new Tab(
                      text: appTab.title,
                      icon: new Icon(appTab.icon),
                    );
                  }).toList(),
                ),
          elevation:
              Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0,
        ),
        body: new Container(
            child: new TabBarView(
              children: appTabs.map((AppTab appTab) {
                return new Padding(
                  padding: new EdgeInsets.symmetric(
                      vertical: defaultTargetPlatform == TargetPlatform.iOS
                          ? 0.0
                          : 16.0, horizontal: 16.0),
                  child: _buildView(appTab, _index),
                );
              }).toList(),
            ),
            decoration: Theme.of(context).platform == TargetPlatform.iOS
                ? new BoxDecoration(
                    border: new Border(
                      top: new BorderSide(color: Colors.grey[200]),
                    ),
                  )
                : null),
      ),

//        floatingActionButton: new FloatingActionButton(
//          onPressed: _doNothing,
//          tooltip: 'Increment',
//          child: new Icon(Icons.add),
//        ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
