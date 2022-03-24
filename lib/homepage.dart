import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_application_ble/functions.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
// import 'package:flutter_bluetooth_basic/flutter_bluetooth_basic.dart';
// import 'package:nearby_connections/nearby_connections.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  StreamSubscription<BluetoothDiscoveryResult>? _streamSubscription;
  List<BluetoothDiscoveryResult> results =
      List<BluetoothDiscoveryResult>.empty(growable: true);
  bool isDiscovering = false;
  final db = FirebaseFirestore.instance;

  void _addAccount() async {
    // for (var test in results) {
    //   print(test.device.address);
    // }
    // db.collection('users').doc('benj').set({'nom': 'dszkz'});

    db.collection('users').get().then(
          (snapshot) => {
            snapshot.docs.forEach((doc) {
              // print(doc.id);
            })
          },
        );
    //Recure les info de
    db.collection('users').snapshots().forEach((doc) {
      print('hello');
      // print(doc.docs.map((e) => {print(e.data()[1]['nom'].toString())}));
      print(doc.docs.map((e) => {print(e.data()['nom'].toString())}));
    });
  }

  void _restartDiscovery() {
    setState(() {
      results.clear();
      isDiscovering = true;
    });

    _startDiscovery();
  }

  void _startDiscovery() {
    _streamSubscription =
        FlutterBluetoothSerial.instance.startDiscovery().listen((r) {
      setState(() {
        final existingIndex = results.indexWhere(
            (element) => element.device.address == r.device.address);
        if (existingIndex >= 0)
          results[existingIndex] = r;
        else {
          results.add(r);
          db.collection('users').add({
            'adress': r.device.address,
          });
        }
      });
    });

    _streamSubscription!.onDone(() {
      setState(() {
        isDiscovering = false;
      });
    });
  }

  @override
  void initState() {
    FirebaseFirestore.instance;
    super.initState();
    // getListDevices();
    getPermission();
    _addAccount();
  }

  @override
  void dispose() {
    // Avoid memory leak (`setState` after dispose) and cancel discovery
    _streamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: isDiscovering
            ? Text('Discovering devices')
            : Text('Discovered devices'),
        actions: <Widget>[
          isDiscovering
              ? FittedBox(
                  child: Container(
                    margin: new EdgeInsets.all(16.0),
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                )
              : IconButton(
                  icon: Icon(Icons.replay),
                  onPressed: _restartDiscovery,
                )
        ],
      ),
      body: ListView.builder(
        itemCount: results.length,
        itemBuilder: (BuildContext context, index) {
          BluetoothDiscoveryResult result = results[index];
          final device = result.device;
          final address = device.address;
          return Column(
            children: [
              Text(address.toString()),
            ],
          );
        },
      ),
    );
  }
}
// StreamBuilder<List<BluetoothDevice>>(
//         stream: bluetoothManager.scanResults,
//         initialData: [],
//         builder: (c, AsyncSnapshot snapshot) => Column(
//           children: snapshot.data
//               .map((d) => ListTile(
//                     onTap: () async {
//                       setState(() {
//                         _device = d;
//                       });
//                     },
//                     title: Text(d.name),
//                   ))
//               .toList(),
//         ),
//       ),
