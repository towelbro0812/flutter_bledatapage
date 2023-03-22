import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'ble_widget.dart';
import 'package:flutter_blue/flutter_blue.dart';

class ViewPage extends StatefulWidget {
  late BluetoothDevice device;
  ViewPage({super.key, required this.device});

  @override
  State<ViewPage> createState() => _ViewPageState();
}

class _ViewPageState extends State<ViewPage> {
  //接收藍芽設備
  late BluetoothDevice device;
  //設備連線狀態
  String deviceState = "";
  //判斷頁面是否銷毀
  bool isDispose = false;
  //UUID合集
  String service_uuid = "6E400001-B5A3-F393-E0A9-E50E24DCCA9E".toLowerCase();
  String write_uuid = "6E400002-B5A3-F393-E0A9-E50E24DCCA9E".toLowerCase();
  String notify_uuid = "6E400003-B5A3-F393-E0A9-E50E24DCCA9E".toLowerCase();

  //是否繼續監聽
  bool isListening = false;

  // 定義三個數值
  double red = 0;
  double green = 0;
  double ir = 0;

  @override
  void initState() {
    super.initState();
    device = widget.device;

    //連接藍芽
    device.connect();

    //監聽藍牙設備狀態
    device.state.listen((state) {
      if (isDispose == false) {
        if (state == BluetoothDeviceState.connected) {
          setState(() => deviceState = "連接成功");
          discoverServices();
        } else if (state == BluetoothDeviceState.connecting) {
          setState(() => deviceState = "connecting...");
        } else if (state == BluetoothDeviceState.disconnected) {
          setState(() => deviceState = "disconnected...");
        }
      }
    });
  }

  // 兩個特徵值，分別維read，write
  late BluetoothCharacteristic mCharacteristic;
  late BluetoothCharacteristic writeCharacteristic;
  void discoverServices() async {
    List<BluetoothService> services = await device.discoverServices();
    services.forEach((service) async {
      // do something with service
      // print("-----------serviceUUID------------");
      // print(service.uuid);
      if (service.uuid.toString() == service_uuid) {
        // Reads all characteristics
        var characteristics = service.characteristics;
        for (BluetoothCharacteristic c in characteristics) {
          if (c.uuid.toString() == write_uuid) {
            print("----------write----------");
            print(c.uuid.toString());
            setState(() => writeCharacteristic = c);
            senddata("ok");
          } else if (c.uuid.toString() == notify_uuid) {
            print("----------notify----------");
            print(c.uuid.toString());
            setState(() => mCharacteristic = c);
          }
        }
      }
    });
  }

  //傳送資料到藍芽設備
  void senddata(String value) async {
    await writeCharacteristic.write(const AsciiEncoder().convert(value));
  }

  //監聽藍芽發送的訊息
  void datacallback() async {
    await mCharacteristic.setNotifyValue(true);
    mCharacteristic.value.listen((value) {
      //print(String.fromCharCodes(value));
      List<String> strs = String.fromCharCodes(value).split(",");
      setState(() {
        red = double.parse(strs[0]);
        green = double.parse(strs[1]);
        ir = double.parse(strs[2]);
      });
    });
  }

  @override
  void dispose() {
    isDispose = true;
    device.disconnect();
    // mCharacteristic.setNotifyValue(false);
    super.dispose();
  }

  Future<void> sleep(int seconds) => Future.delayed(Duration(seconds: seconds));
  //這裡定義一個變數first，第一次按下按鈕時，創建監聽，下次的話，直接改變監聽狀態isListiung
  bool first = false;
  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    const double viewsize = 450;
    return Scaffold(
      body: Container(
        color: Colors.grey,
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              height: viewsize,
              color: Colors.grey,
              child: Text(
                deviceState,
                style: const TextStyle(fontSize: 80, color: Colors.white),
              ),
            ),
            Container(
              width: double.infinity,
              height: screenSize.height - viewsize,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  Spacer(),
                  ItemBox(
                    red: red,
                    green: green,
                    ir: ir,
                  ),
                  Spacer(),
                  // START按鈕
                  Container(
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    width: screenSize.width,
                    height: 85,
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              isListening ? Colors.red.shade400 : Colors.blue)),
                      onPressed: () async {
                        setState(() {
                          isListening = !isListening;
                        });
                        if (!first) {
                          datacallback();
                          first = true;
                        } else {
                          await mCharacteristic.setNotifyValue(isListening);
                        }
                      },
                      child: Text(
                        isListening ? "STOP" : "START",
                        style: const TextStyle(fontSize: 55),
                      ),
                    ),
                  ),
                  Spacer()
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
