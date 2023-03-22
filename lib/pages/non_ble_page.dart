import 'dart:async';
import 'dart:math';

import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue/flutter_blue.dart';

import 'ble_widget.dart';

class ViewPage extends StatefulWidget {
  late BluetoothDevice device;
  ViewPage({super.key, required this.device});

  @override
  State<ViewPage> createState() => _ViewPageState();
}

class _ViewPageState extends State<ViewPage> {
  //接收藍芽設備
  late BluetoothDevice device;

  //是否繼續計時
  bool _timerRunning = false;
  // 計時器，第一個為數值計時器，第二個為PLOT計時器
  Timer? _timer1;
  Timer? _timer2;

  // 定義兩個數值
  double spo2 = 0;
  double bpm = 0;

  // 定義csv list
  List<ChartData> _alldata = [];
  List<ChartData> _plotdata = [];
  @override
  void initState() {
    super.initState();
    device = widget.device;

    //連接藍芽
    device.connect();
    //調用csv
    _getcsvdata();
  }

  @override
  void dispose() {
    device.disconnect();
    super.dispose();
  }

  void _getcsvdata() async {
    final indata = await rootBundle.loadString("assets/data.csv");
    List<List<dynamic>> listdata = const CsvToListConverter().convert(indata);
    // print(listdata);
    for (var element in listdata) {
      _alldata.add(ChartData(element[0], element[1], element[2], element[3]));
    }

    _getplotinitdata();
  }

  // 初始化plot陣列
  void _getplotinitdata() {
    for (var i = 0; i < 1000; i++) {
      _plotdata.add(ChartData(i, _alldata[i % 2464].ir, _alldata[i % 2464].red,
          _alldata[i % 2464].green));
    }
  }

  int time = 1000;
  //按鈕控制timer
  void _toggleTimer() {
    // for (var element in _alldata) {
    //   print(element.time);
    // }
    if (_timerRunning) {
      _stopTimer();
      setState(() {
        _timerRunning = false;
        //_plotdata = [];
      });
    } else {
      setState(() {
        _timerRunning = true;
        _plotdata = [];
        _getplotinitdata();
      });
      _startTimer();
    }
  }

  void _startTimer() {
    _timer1 = Timer.periodic(const Duration(seconds: 1), _btnfunc);
    _timer2 =
        Timer.periodic(const Duration(milliseconds: 10), updateDataSource);
  }

  void _stopTimer() {
    time = 1000;
    _timer1?.cancel();
    _timer1 = null;
    _timer2?.cancel();
    _timer2 = null;
  }

  void _btnfunc(Timer time) {
    setState(() {
      spo2 = Random().nextDouble() * 2 + 97;
      bpm = Random().nextDouble() * 10 + 60;
    });
  }

  void updateDataSource(Timer timer) {
    time = (time + 1);
    _plotdata.add(ChartData(time, _alldata[time % 2463].ir,
        _alldata[time % 2463].red, _alldata[time % 2463].green));
    _plotdata.removeAt(0);
  }

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
              child: Plot(
                indata: _plotdata,
                timerRunning: _timerRunning,
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
                  const Spacer(),
                  ItemBox2(
                    spo2: spo2,
                    bpm: bpm,
                  ),
                  const Spacer(),
                  // START按鈕
                  Container(
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    width: screenSize.width,
                    height: 85,
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              _timerRunning
                                  ? Colors.red.shade400
                                  : Colors.blue)),
                      onPressed: () {
                        _toggleTimer();
                      },
                      child: Text(
                        _timerRunning ? "STOP" : "START",
                        style: const TextStyle(fontSize: 55),
                      ),
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 顯示PLOT
class Plot extends StatefulWidget {
  final List<ChartData> indata;
  final bool timerRunning;
  const Plot({super.key, required this.indata, required this.timerRunning});

  @override
  State<Plot> createState() => _PlotState();
}

class _PlotState extends State<Plot> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SfCartesianChart(
        title: ChartTitle(text: "已連接至藍芽設備"),
        primaryXAxis: NumericAxis(interval: 100),
        primaryYAxis: NumericAxis(minimum: 124500, interval: 1000),
        //可選擇要不要加
        zoomPanBehavior: ZoomPanBehavior(enablePinching: !widget.timerRunning),
        series: <ChartSeries>[
          LineSeries<ChartData, int>(
              color: Colors.purple.shade300,
              dataSource: widget.indata,
              xValueMapper: (ChartData point, _) => point.time,
              yValueMapper: (ChartData point, _) => point.ir),
          LineSeries<ChartData, int>(
              color: Colors.red.shade100,
              dataSource: widget.indata,
              xValueMapper: (ChartData point, _) => point.time,
              yValueMapper: (ChartData point, _) => point.red),
          // LineSeries<ChartData, int>(
          //     color: Colors.green.shade100,
          //     dataSource: widget.indata,
          //     xValueMapper: (ChartData point, _) => point.time,
          //     yValueMapper: (ChartData point, _) => point.green),
        ],
      ),
    );
  }
}

class ChartData {
  final int time;
  final int ir;
  final int red;
  final int green;
  ChartData(this.time, this.ir, this.red, this.green);
}
