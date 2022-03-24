import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:nearby_connections/nearby_connections.dart';

final Strategy strategy = Strategy.P2P_STAR;
void dicovery() async {
  try {
    bool a = await Nearby().startDiscovery('samir', strategy,
        onEndpointFound: (id, name, serviceId) async {
      print(name);
      print('les nom des appareil trouvé');
    }, onEndpointLost: (id) {
      print(id);
    });
    print('DISCOVERING: ${a.toString()}');
  } catch (error) {
    print(error);
  }
  ;
}

void getPermission() async {
  Nearby().askLocationAndExternalStoragePermission();
  Nearby().enableLocationServices();
}

void getListDevices() async {
  FlutterBluetoothSerial.instance.startDiscovery().listen((r) {
    print(r);
  });
}
