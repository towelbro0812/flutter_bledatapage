import 'package:flutter_blue/flutter_blue.dart';
import 'package:permission_handler/permission_handler.dart';

class BleModule {
  FlutterBlue flutterBlue = FlutterBlue.instance;

  // 申請定位權限
  static Future<bool> requestPermission() async {
    bool hasBluetoothPermission = await requestBluePermission();
    bool hasBluetoothScanPermission = await requestBlueScanPermission();
    bool hasBluetoothConnectPermission = await requestBlueConnectPermission();
    if (hasBluetoothPermission &
        hasBluetoothScanPermission &
        hasBluetoothConnectPermission) {
      print("藍芽權限已通過");
      //掃描設備
      return true;
    } else {
      print("藍芽權限未通過");
      return false;
    }
  }

  //獲取藍芽權限
  static Future<bool> requestBluePermission() async {
    //獲取當前權限
    var status = await Permission.bluetooth.status;
    if (status == PermissionStatus.granted) {
      //已經授權
      return true;
    } else {
      //未授權則發起一次申請
      status = await Permission.bluetooth.request();
      if (status == PermissionStatus.granted) {
        return true;
      } else {
        return false;
      }
    }
  }

  // 獲取藍芽權掃描權限
  static Future<bool> requestBlueScanPermission() async {
    //獲取當前權限
    var status = await Permission.bluetoothScan.status;
    if (status == PermissionStatus.granted) {
      //已經授權
      return true;
    } else {
      //未授權則發起一次申請
      status = await Permission.bluetoothScan.request();
      if (status == PermissionStatus.granted) {
        return true;
      } else {
        return false;
      }
    }
  }

  // 獲取藍芽連接權限
  static Future<bool> requestBlueConnectPermission() async {
    //獲取當前權限
    var status = await Permission.bluetoothConnect.status;
    if (status == PermissionStatus.granted) {
      //已經授權
      return true;
    } else {
      //未授權則發起一次申請
      status = await Permission.bluetoothConnect.request();
      if (status == PermissionStatus.granted) {
        return true;
      } else {
        return false;
      }
    }
  }
}
