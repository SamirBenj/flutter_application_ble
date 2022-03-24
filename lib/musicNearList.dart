import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nowplaying/nowplaying.dart';
import 'package:provider/provider.dart';

import 'functions.dart';

class MusicsList extends StatefulWidget {
  MusicsList({Key? key}) : super(key: key);

  @override
  _MusicsListState createState() => _MusicsListState();
}

class _MusicsListState extends State<MusicsList> {
  final db = FirebaseFirestore.instance;
  @override
  void initState() {
    // NowPlaying.instance.start();
    getPermission();
    getListDevices();

    super.initState();
  }

  Future<void> getPermission() async {
    NowPlaying.instance.isEnabled().then((bool isEnabled) async {
      if (!isEnabled) {
        final shown = await NowPlaying.instance.requestPermissions();
        print("Manage to show permissions:$shown ");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamProvider.value(
      value: NowPlaying.instance.stream,
      // initialData: Stre,
      initialData: null,
      child: MaterialApp(
        home: Scaffold(
          appBar: AppBar(),
          body: Consumer<NowPlayingTrack?>(
            builder: (context, track, _) {
              print(track);
              if (track == null) {
                return CircularProgressIndicator(
                  color: Colors.red,
                );
              } else {
                db.collection('users').doc('samir').set({
                  'musicName': track.title.toString(),
                  'album': track.album.toString(),
                });
                return Column(
                  children: [
                    Card(
                      margin: EdgeInsets.all(20),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text(track.title.toString()),
                      ),
                    ),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
