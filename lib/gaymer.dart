class Gaymer {
  final String channelId;
  final String gaymerName;
  final String streamPlatform;

  Gaymer({this.channelId, this.gaymerName, this.streamPlatform});

  Gaymer.fromSnapshot(Map map)
      :
        //initializer list
        channelId = map['channelId'],
        gaymerName = map['gaymerName'],
        streamPlatform = map["streamPlatform"];
}
