import 'dart:async';

import 'package:flutter/material.dart';

class MyMissile extends StatelessWidget {
  final StreamController<List<double>> missileHeightController;
  const MyMissile({
    super.key,
    required this.missileHeightController,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<double>>(
        stream: missileHeightController.stream,
        builder: (context, snapshot) {
          return Container(
            alignment: Alignment(snapshot.data![1], 1),
            child: Container(
              height: snapshot.data!.first,
              width: 2,
              color: Colors.grey,
            ),
          );
        });
  }
}
