import 'dart:async';

import 'package:flutter/material.dart';

class MyPlayer extends StatelessWidget {
  const MyPlayer({super.key, required this.playerX});
  final StreamController<double> playerX;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: playerX.stream,
        builder: (context, snapshot) {
          return Container(
            alignment: Alignment(snapshot.data!.toDouble(), 1),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                height: 50,
                width: 50,
                color: Colors.purple,
              ),
            ),
          );
        });
  }
}
