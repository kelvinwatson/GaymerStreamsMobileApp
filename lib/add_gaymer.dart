import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddGaymer extends StatefulWidget {
  var _homeScreenState;

  AddGaymer(_homeScreenState) {
    this._homeScreenState = _homeScreenState;
  }

  @override
  _AddGaymerState createState() => new _AddGaymerState(_homeScreenState);
}

class _AddGaymerState extends State<AddGaymer> {
  var _homeScreenState;
  final TextEditingController _textController = new TextEditingController();
  bool _isComposing = false;

  _AddGaymerState(_homeScreenState) {
    this._homeScreenState = _homeScreenState;
  }

  void _handleSubmitted(String text) {
    _homeScreenState.onGaymerSubmitted(text); //pass text to parent state
    _textController.clear();
    setState(() {
      //new
      _isComposing = false; //new
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      child: new IconTheme(
        data: new IconThemeData(color: Theme.of(context).accentColor),
        child: new Column(
          children: <Widget>[
            new Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                new Flexible(
                  child: new TextField(
                    controller: _textController,
                    onChanged: (String text) {
                      setState(() {
                        _isComposing = text.length > 0;
                      });
                    },
                    onSubmitted: _handleSubmitted,
                    decoration: new InputDecoration(
                        labelText: 'Know of a Twitch Gaymer?',
                        hintText: 'Enter a Twitch Username'),
                  ),
                ),
                new Container(
                  margin: const EdgeInsets.all(0.0),
                  child: Theme.of(context).platform == TargetPlatform.iOS
                      ? new CupertinoButton(
                          //new
                          child: new Text('Submit'),
                          onPressed: _isComposing
                              ? () => _handleSubmitted(_textController.text)
                              : null,
                        )
                      : new IconButton(
                          alignment: Alignment.bottomCenter,
                          icon: new Icon(Icons.send),
                          onPressed: _isComposing
                              ? () => _handleSubmitted(_textController.text)
                              : null,
                        ),
                ),
              ],
            ),
            new Container(
              margin: const EdgeInsets.symmetric(vertical: 24.0),
              child: new Text(
                  'Are you a LGBT or LGBT-friendly streamer? Do you know '
                  'a LGBT or LGBT-friendly streamer? If so, enter the Twitch '
                  'username to be featured here'),
            )
          ],
//          alignment: AlignmentDirectional.topStart,
        ),
      ),
    );
  }
}
