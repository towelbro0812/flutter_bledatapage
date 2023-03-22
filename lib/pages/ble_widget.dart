import 'package:flutter/material.dart';

// 有三個數值，red,green,ir
class ItemBox extends StatefulWidget {
  final double red;
  final double green;
  final double ir;
  const ItemBox({super.key, this.red = 0, this.green = 0, this.ir = 0});

  @override
  State<ItemBox> createState() => _ItemBoxState();
}

class _ItemBoxState extends State<ItemBox> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Expanded(
          flex: 1,
          child: ValueContainer(
            color: const Color(0xffFF9494),
            value: widget.red.toInt(),
          ),
        ),
        Expanded(
          flex: 1,
          child: ValueContainer(
            color: const Color(0xff9ED2C6),
            value: widget.green.toInt(),
          ),
        ),
        Visibility(
          visible: true,
          child: Expanded(
            flex: 1,
            child: ValueContainer(
              color: const Color(0xffAF7AB3),
              value: widget.ir.toInt(),
            ),
          ),
        ),
      ],
    );
  }
}

// 兩個數值，spo2,bpm
class ItemBox2 extends StatefulWidget {
  final double spo2;
  final double bpm;
  const ItemBox2({super.key, this.spo2 = 0, this.bpm = 0});

  @override
  State<ItemBox2> createState() => _ItemBox2State();
}

class _ItemBox2State extends State<ItemBox2> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Expanded(
          flex: 1,
          child: ValueContainer(
            color: const Color(0xff6ECCAF),
            value: widget.spo2.toInt(),
          ),
        ),
        Expanded(
          flex: 1,
          child: ValueContainer(
            color: const Color(0xffF06292),
            value: widget.bpm.toInt(),
          ),
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
  late String initString;
  @override
  void initState() {
    super.initState();
    //用顏色判斷要輸出的文字
    if (widget.color == const Color(0xffFF9494)) {
      initString = "Red";
    } else if (widget.color == const Color(0xff9ED2C6)) {
      initString = "Green";
    } else if (widget.color == const Color(0xffAF7AB3)) {
      initString = "IR";
    } else if (widget.color == const Color(0xff6ECCAF)) {
      initString = "SPO2%";
    } else if (widget.color == const Color(0xffF06292)) {
      initString = "BPM";
    }
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
        alignment: Alignment.center,
        //height: 120,
        //width: 120,
        decoration: BoxDecoration(
          color: widget.color,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              initString,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 40, color: Colors.white),
            ),
            Text(
              "${widget.value}",
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 50, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
