import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nowplaying/nowplaying.dart';
import 'dart:async';

class DataList extends StatefulWidget {
  DataList({Key? key}) : super(key: key);

  @override
  _DataListState createState() => _DataListState();
}

class _DataListState extends State<DataList> {
  Future<void> getPermission() async {
    NowPlaying.instance.isEnabled().then((bool isEnabled) async {
      if (!isEnabled) {
        final shown = await NowPlaying.instance.requestPermissions();
        print("Manage to show permissions:$shown ");
      }
    });
  }

  void _addMusicToUser() async {
    print('hlo');
    // NowPlaying.instance.stream.map((test) => {
    //       print('salut---' + test.id.toString()),
    //       print('hello'),
    //     });
    var data = await NowPlaying.instance.start().then(
          (value) => {
            print('value'),
          },
        );

    print(data.toList());

    // print(data.listen((event) {
    //   print('hello');
    //   print(event.title);
    // }));
  }

  @override
  void initState() {
    super.initState();
    // _addMusicToUser();
  }

  @override
  Widget build(BuildContext context) {
    final db = FirebaseFirestore.instance;
    return Scaffold(
      appBar: AppBar(
        title: Text('Musics of user'),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: db.collection('users').snapshots(),
              // initialData: InitialData,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        title: Text(
                          snapshot.data.docs[index]['nom'],
                        ),
                        subtitle: Text('adress'),
                      );
                    },
                  );
                }
              },
            ),
          ),
          ElevatedButton(
            onPressed: () {
              _addMusicToUser();
              print('hello');
            },
            child: Text('Find Musics'),
          )
        ],
      ),
    );
  }
}
