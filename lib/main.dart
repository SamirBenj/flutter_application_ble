import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_ble/bottomNavigationBar.dart';
import 'package:flutter_application_ble/firestoreList.dart';
import 'package:flutter_application_ble/musicNearList.dart';
import 'package:nowplaying/nowplaying.dart';

import 'homepage.dart';

void main() async {
  NowPlaying.instance.start(resolveImages: false);
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
  Firebase.initializeApp();
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // home: const MyHomePage(title: 'Flutter Demo Home Page'),
      // home: MusicsList(),
      home: BottomBar(),
    );
  }
}
