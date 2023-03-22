import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'ble_process.dart';
import './pages/ble_page.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: ScanBlePage(),
    );
  }
}

class ScanBlePage extends StatefulWidget {
  const ScanBlePage({super.key});

  @override
  State<ScanBlePage> createState() => _ScanBlePageState();
}

class _ScanBlePageState extends State<ScanBlePage> {
  // 獲取藍芽實例
  FlutterBlue flutterBlue = FlutterBlue.instance;
  // 定義藍芽狀態
  bool isBlueOn = false;
  // 定義權限狀態
  bool isPermissionPass = false;
  // 藍芽設備列表
  List<BluetoothDevice> bluelist = [];
  @override
  void initState() {
    super.initState();
    //監聽藍芽有無開啟
    flutterBlue.state.listen((event) async {
      if (event == BluetoothState.on) {
        print("藍芽已開啟");
        setState(() {
          isBlueOn = true;
        });
        //權限確認
        isPermissionPass = await BleModule.requestPermission();
      } else {
        print("請打開藍芽");
        setState(() {
          isBlueOn = false;
        });
      }
    });
  }

  //掃描設備
  void startScan() {
    // Start scanning
    flutterBlue.startScan(timeout: const Duration(seconds: 4));
    // Listen to scan results
    var subscription = flutterBlue.scanResults.listen((results) {
      // do something with scan results
      for (ScanResult r in results) {
        // print('${r.device.name} found! rssi: ${r.rssi}');
        if (r.device.name.length > 2) {
          //避免重複把設備丟進去，這裡加一個判斷
          if (!bluelist.contains(r.device)) {
            setState(() {
              bluelist.add(r.device);
            });
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Service"),
      ),
      body: bluelist.isNotEmpty
          ? Column(
              children: bluelist.map((device) {
                return ListTile(
                  title: Text(device.name),
                  subtitle: Text(device.id.toString()),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) {
                        return ViewPage(device: device);
                      },
                    ));
                  },
                );
              }).toList(),
            )
          : Center(child: Text("請開啟藍芽並掃描")),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (isPermissionPass == true) {
            startScan();
          } else {
            Fluttertoast.showToast(
                msg: "請開啟權限",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.grey,
                textColor: Colors.white,
                fontSize: 16.0);
          }
        },
        child: const Icon(Icons.bluetooth),
      ),
    );
  }
}
