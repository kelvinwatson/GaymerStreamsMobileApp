import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddGaymer extends StatefulWidget {
  final parentState;

  AddGaymer({this.parentState});

  @override
  _AddGaymerState createState() => new _AddGaymerState();
}

class _AddGaymerState extends State<AddGaymer> {
  final TextEditingController _textController = new TextEditingController();
  bool _isComposing = false;

  void _handleSubmitted(BuildContext context, String text) {
    _textController.clear();
    FocusScope.of(context).requestFocus(new FocusNode());

    setState(() {
      //new
      _isComposing = false; //new
    });

    widget.parentState.onGaymerSubmitted(context, text);
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
                    onSubmitted: (text) => _handleSubmitted(context, text),
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
                              ? () => _handleSubmitted(
                                  context, _textController.text)
                              : null,
                        )
                      : new IconButton(
                          alignment: Alignment.bottomCenter,
                          icon: new Icon(Icons.send),
                          onPressed: _isComposing
                              ? () => _handleSubmitted(
                                  context, _textController.text)
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
