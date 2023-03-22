import 'package:flutter/material.dart';
import 'dart:async';

// ignore: must_be_immutable
class ItemBox extends StatefulWidget {
  double red;
  double green;
  double ir;
  ItemBox({super.key, this.red = 0, this.green = 0, this.ir = 0});

  @override
  State<ItemBox> createState() => _ItemBoxState();
}

class _ItemBoxState extends State<ItemBox> {
  bool _timerRunning = false;
  Timer? _timer;

  // void _startTimer() {
  //   _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
  //     _btnfunc();
  //   });
  // }

  // void _stopTimer() {
  //   _timer?.cancel();
  //   _timer = null;
  // }

  // void _toggleTimer() {
  //   // print(_timerRunning);
  //   if (_timerRunning) {
  //     _stopTimer();
  //     setState(() {
  //       _timerRunning = false;
  //     });
  //   } else {
  //     setState(() {
  //       widget.red = 0;
  //       widget.green = 0;
  //       widget.ir = 0;
  //       _timerRunning = true;
  //     });
  //     _startTimer();
  //   }
  // }

  // void _btnfunc() {
  //   // TODO:這個區塊之後要調用藍芽讀取設備
  //   setState(() {
  //     widget.red++;
  //     widget.green++;
  //     widget.ir++;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ValueContainer(
              color: const Color(0xffFF9494),
              value: widget.red.toInt(),
            ),
            ValueContainer(
              color: const Color(0xff9ED2C6),
              value: widget.green.toInt(),
            ),
            ValueContainer(
              color: const Color(0xffAF7AB3),
              value: widget.ir.toInt(),
            ),
          ],
        ),
      ],
    );
  }
}

// 顯示數值UI
class ValueContainer extends StatefulWidget {
  final Color color;
  final int value;
  const ValueContainer({super.key, required this.color, required this.value});

  @override
  State<ValueContainer> createState() => _ValueContainerState();
}

class _ValueContainerState extends State<ValueContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: 120,
      width: 120,
      decoration: BoxDecoration(
        color: widget.color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        "${(widget.color == const Color(0xffFF9494)) ? "Red" : (widget.color == const Color(0xff9ED2C6)) ? "Green" : "IR"}\n${widget.value}",
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 40, color: Colors.white),
      ),
    );
  }
}
