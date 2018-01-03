import 'dart:async';
import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gaymerstreams/add_gaymer.dart';
import 'package:gaymerstreams/game.dart';
import 'package:gaymerstreams/games.dart';
import 'package:gaymerstreams/gaymer.dart';
import 'package:gaymerstreams/streams.dart';

class AppTab {
  const AppTab({this.index, this.title, this.icon});

  final int index;
  final String title;
  final IconData icon;
}

const List<AppTab> appTabs = const <AppTab>[
  const AppTab(index: 0, title: 'LIVE', icon: Icons.visibility),
  const AppTab(index: 1, title: 'GAMES', icon: Icons.games),
  const AppTab(index: 2, title: 'ADD', icon: Icons.add),
];

class AppTabs extends StatefulWidget {
  @override
  State createState() => new _AppTabsState();
}

class _AppTabsState extends State<AppTabs> with SingleTickerProviderStateMixin {
  int _tabIndex = 0;
  String selectedGame;
  List<Game> gamesList;
  List<GameItem> gameItems;
  List<Gaymer> gaymersList;
  List<StreamItem> allLiveStreamItems;
  List<StreamItem> filteredLiveStreamItems;
  final gaymersRef = FirebaseDatabase.instance.reference().child('gaymers');
  final DatabaseReference gamesRef =
      FirebaseDatabase.instance.reference().child('games');
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  TabController _tabController;
  Map<String, String> twitchApiHeaders = {
    'Accept': 'application/vnd.twitchtv.v5+json',
    'Client-ID': '4ab0ef4dut3ngrm4ercp9ue54k58d5'
  };

  _AppTabsState() {
    _setGetGaymersListener();
    _setGetGamesListener();
  }

  ///
  /// LIVE STREAMS
  ///
  String _extractChannelIdsFromGaymersList(List<Gaymer> gaymersList) {
    List<String> channelIdsArr = new List<String>.generate(gaymersList.length,
        (int index) => gaymersList.elementAt(index).channelId);
    return channelIdsArr.join(',');
  }

  Future<List<StreamItem>> _getLiveStreams(
      String game, List<Gaymer> gaymersList) async {
    String channelIds = _extractChannelIdsFromGaymersList(gaymersList);
    String twitchApiUrl = 'https://api.twitch.tv/kraken/streams/?';

    if (game != null) {
      twitchApiUrl += 'game=' + Uri.encodeFull(game);
      if (channelIds != null) {
        twitchApiUrl += '&channel=' + Uri.encodeFull(channelIds);
      }
    } else if (channelIds != null) {
      // should be defined if game is defined
      twitchApiUrl += 'channel=' + Uri.encodeFull(channelIds);
    }

    var response =
        await createHttpClient().get(twitchApiUrl, headers: twitchApiHeaders);
    return _constructGridItems(JSON.decode(response.body)['streams']);
  }

  List<StreamItem> _constructGridItems(decoded) {
    List<StreamItem> gridItems = new List<StreamItem>();
    decoded.forEach((el) {
      gridItems.add(new StreamItem.fromTwitchApi(el));
    });
    return gridItems;
  }

  _setGetGaymersListener() async {
    gaymersRef.onValue.listen(_deserializeGaymersToList,
        onError: _handleGetGaymersError, onDone: _handleGetGaymersDone);
  }

  void _handleGetGaymersError(Error error, StackTrace stackTrace) {}

  void _handleGetGaymersDone() {}

  void _deserializeGaymersToList(Event event) {
    List<Gaymer> tmp = new List<Gaymer>();
    event.snapshot.value.forEach((k, v) {
      //snapshot.value is a map
      tmp.add(new Gaymer.fromSnapshot(v));
    });
    setState(() {
      gaymersList = tmp;
    });
    _generateLiveStreamItemsFromGaymersList(gaymersList, selectedGame);
  }

  _generateLiveStreamItemsFromGaymersList(gaymersList, game) {
    if (gaymersList != null && gaymersList.length > 0) {
      _getLiveStreams(selectedGame, gaymersList).then((liveStreamItems) {
        _tabController.animateTo(0);
        // switch back to "Live" tab
        this.setState(() {
          _tabIndex = 0;
        });

        if (selectedGame == null) {
          this.setState(() {
            this.allLiveStreamItems = liveStreamItems;
            this.filteredLiveStreamItems = null;
          });

          _generateGameItemsFromGamesList(gamesList, liveStreamItems);
        } else {
          this.setState(() {
            this.allLiveStreamItems = null;
            this.filteredLiveStreamItems = liveStreamItems;
          });
        }
      });
    }
  }

  ///
  /// GAMES
  ///
  _setGetGamesListener() {
    gamesRef.onValue.listen(_deserializeGamesToList,
        onError: _handleGetGamesError, onDone: _handleGetGamesDone);
  }

  void _handleGetGamesError(Error error, StackTrace stackTrace) {}

  void _handleGetGamesDone() {}

  void _deserializeGamesToList(Event event) {
    List<Game> tmp = new List<Game>();
    event.snapshot.value.forEach((k, v) {
      //snapshot.value is a map
      tmp.add(new Game.fromSnapshot(v));
    });
    setState(() {
      gamesList = tmp;
    });
    _generateGameItemsFromGamesList(gamesList, filteredLiveStreamItems);
  }

  void _generateGameItemsFromGamesList(
      List<Game> gamesList, List<StreamItem> liveStreamItems) {
    List<GameItem> gameItems = new List<GameItem>();
    if (gamesList != null && gamesList.length > 0) {
      int streamerCount = 0;
      for (var game in gamesList) {
        streamerCount = 0;
        if (liveStreamItems != null) {
          for (var liveStream in liveStreamItems) {
            if (game.name == liveStream.gameName) {
              ++streamerCount;
            }
          }
        }

        GameItem gameItem =
            new GameItem(name: game.name, streamerCount: streamerCount);
        gameItems.add(gameItem);
      }

      gameItems
          .sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

      gameItems.sort((a, b) => b.streamerCount.compareTo(a.streamerCount));

      gameItems.insert(
          0,
          new GameItem(
              name: 'All Games',
              streamerCount:
                  liveStreamItems.length == null ? 0 : liveStreamItems.length));

      this.setState(() {
        this.gameItems = gameItems;
      });
    }
  }

  Future<Null> onGameSelected(String game) async {
    if (game == 'All Games') {
      game = null;
    }
    setState(() => this.selectedGame = game);
    _generateLiveStreamItemsFromGaymersList(gaymersList, game);
  }

  ///
  /// ADD
  ///
  void onGaymerSubmitted(BuildContext context, String twitchName) {
    createHttpClient()
        .get('https://api.twitch.tv/kraken/users?login=$twitchName',
            headers: twitchApiHeaders)
        .then((response) {
      List<Object> users = JSON.decode(response.body)['users'];
      if (users == null || users.length == 0) {
        _showSnackbar(context, 'Sorry, $twitchName is not a Twitch user.');
      } else {
        //user found in Twitch API, see if already added
        Map<String, String> user = users[0];
        bool exists = false;
        for (var gaymer in gaymersList) {
          if (gaymer.gaymerName.toLowerCase() ==
              user['display_name'].toLowerCase()) {
            exists = true;
          }
        }
        if (exists) {
          _showSnackbar(context, '$twitchName has already been added.');
        } else {
          String writeKey = user['display_name'].toLowerCase() + user['_id'];
          gaymersRef.child(writeKey).set({
            'channelId': user['_id'],
            'gaymerName': user['display_name'],
            'streamPlatform': 'Twitch'
          }).then((value) {
            _showSnackbar(context, '$twitchName added successfully!');
          }).catchError((err) {
            _showSnackbar(
                context, 'Unable to add $twitchName. Try again later.');
          });
        }
      }
    }).catchError((err) {
      _showSnackbar(
          context, 'Unable to add $twitchName at this time. Try again later.');
    });
  }

  ///
  /// TABS
  ///
  Widget _buildGamesView() {
    return new Games(parentState: this, gameItems: gameItems);
  }

  Widget _buildAddStreamerView() {
    return new AddGaymer(parentState: this);
  }

  Widget _buildStreamsView(context) {
    return new RefreshIndicator(
      key: refreshIndicatorKey,
      onRefresh: () => handleRefresh(context, false),
      child: new Streams(
          parentState: this,
          gameName: selectedGame == null ? 'All Games' : selectedGame,
          liveStreamItems: allLiveStreamItems == null
              ? filteredLiveStreamItems
              : allLiveStreamItems),
    );
  }

  Widget _buildView(context, AppTab choice, int iosTabIndex) {
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      switch (iosTabIndex) {
        case 1:
          return _buildGamesView();
        case 2:
          return _buildAddStreamerView();
        default:
          return _buildStreamsView(context);
      }
    }

    switch (choice.title) {
      case 'GAMES':
        return _buildGamesView();
      case 'ADD':
        return _buildAddStreamerView();
      default:
        return _buildStreamsView(context);
    }
  }

  Future<Null> handleRefresh(context, fromFab) async {
    if (fromFab) {
      refreshIndicatorKey.currentState.show();
    }
    final Completer<Null> completer = new Completer<Null>();

    onGameSelected('All Games')
        .then((Future<Null> n) => completer.complete(null));

    return completer.future.then((_) {
      //TODO ios snackbar?
//      Scaffold.of(context).showSnackBar(new SnackBar(
//          content: const Text('Refresh complete'),
//          action: new SnackBarAction(
//              label: 'RETRY',
//              onPressed: () {
//                refreshIndicatorKey.currentState.show();
//              })));
    });
  }

  tabChangeCallbackAndroid() {
    setState(() {
      _tabIndex = _tabController.index;
    });
    FocusScope.of(context).requestFocus(new FocusNode()); //close keyboard
  }

  _showSnackbar(BuildContext context, String message) {
    Scaffold.of(context).showSnackBar(new SnackBar(
          content: new Text(message),
          duration: const Duration(milliseconds: 3500),
        ));
  }

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: appTabs.length);
    _tabController.addListener(tabChangeCallbackAndroid);
    _tabIndex = 0;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new DefaultTabController(
      length: appTabs.length,
      child: new Scaffold(
        bottomNavigationBar: Theme.of(context).platform == TargetPlatform.iOS
            ? new CupertinoTabBar(
                currentIndex: _tabIndex,
                onTap: (int _index) {
                  setState(() {
                    this._tabIndex = _index;
                  });
                },
                items: <BottomNavigationBarItem>[
                    new BottomNavigationBarItem(
                      icon: new Icon(Icons.visibility),
                      title: new Text('Live'),
                    ),
                    new BottomNavigationBarItem(
                      icon: new Icon(Icons.games),
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
                  controller: _tabController,
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
        body: new Builder(
          builder: (BuildContext context) {
            return new Container(
                child: new TabBarView(
                  controller: _tabController,
                  children: appTabs.map((AppTab appTab) {
                    return new Container(
                      child: _buildView(context, appTab, _tabIndex),
                    );
                  }).toList(),
                ),
                decoration: Theme.of(context).platform == TargetPlatform.iOS
                    ? new BoxDecoration(
                        border: new Border(
                          top: new BorderSide(color: Colors.grey[200]),
                        ),
                      )
                    : null);
          },
        ),
        floatingActionButton: Theme.of(context).platform ==
                    TargetPlatform.iOS ||
                (_tabController.index == 1 || _tabController.index == 2)
            ? null
            : new Builder(
                builder: (BuildContext context) {
                  return new FloatingActionButton(
                    onPressed: () => handleRefresh(context, true),
                    tooltip: 'Refresh',
                    child: new Icon(Icons.refresh),
                  );
                },
              ), // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }
}
