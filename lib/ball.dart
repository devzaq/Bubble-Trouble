import 'dart:async';

import 'package:flutter/material.dart';

class MyBall extends StatelessWidget {
  const MyBall({super.key, required this.ballController});
  final StreamController<List<double>> ballController;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<double>>(
        stream: ballController.stream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Container();
          return Container(
            alignment: Alignment(snapshot.data![0], snapshot.data![1]),
            child: Container(
              height: 10,
              width: 10,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.brown,
              ),
            ),
          );
        });
  }
}
