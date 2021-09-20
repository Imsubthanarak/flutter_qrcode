import 'package:flutter/material.dart';

class Itemstatus extends StatefulWidget {
  final String id;
  const Itemstatus({Key? key, required this.id}) : super(key: key);

  @override
  _ItemstatusState createState() => _ItemstatusState();
}

class _ItemstatusState extends State<Itemstatus> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      child: Stack(
        children: [
          Positioned(
            child: Container(
              width: size.width,
              height: size.height,
              color: const Color(0xFFB6E3BC),
            ),
          ),
          Positioned(
            top: (size.height / 2) - ((size.height - 100.0) / 2),
            left: (size.width / 2) - ((size.width - 50.0) / 2),
            height: size.height - 100.0,
            width: size.width - 50.0,
            child: Container(
              height: size.height - 100.0,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.all(Radius.circular(40.0)),
                border: Border.all(
                  color: Colors.black,
                  width: 3,
                ),
              ),
              child: Text(
                widget.id,
                style: const TextStyle(color: Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
