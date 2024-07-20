import 'dart:async';
import 'dart:developer';

import 'package:bubble_trouble/button.dart';
import 'package:bubble_trouble/player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _playerX = StreamController<double>();
  double _playerPosition = 0;
  final double _playerSpeed = 0.05;

  @override
  void initState() {
    super.initState();
    _playerX.add(_playerPosition);
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: FocusNode(),
      autofocus: true,
      onKeyEvent: (value) {
        log(value.logicalKey.toString());
        if (value is KeyDownEvent || value is KeyRepeatEvent) {
          if (value.logicalKey.debugName == 'Arrow Left') {
            moveLeft();
          } else if (value.logicalKey.debugName == 'Arrow Right') {
            moveRight();
          }
        }
      },
      child: Column(
        children: [
          Expanded(
            flex: 3,
            child: Container(
              color: Colors.pink[100],
              child: Center(
                child: Stack(
                  children: [MyPlayer(playerX: _playerX)],
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.grey,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  MyButton(
                    icon: Icons.arrow_back,
                    onButtonPress: moveLeft,
                  ),
                  MyButton(
                    icon: Icons.arrow_upward,
                    onButtonPress: () {},
                  ),
                  MyButton(
                    icon: Icons.arrow_forward,
                    onButtonPress: moveRight,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void moveRight() {
    _playerPosition += _playerSpeed;
    if (_playerPosition > 1.00001) _playerPosition = -1;
    _playerX.add(_playerPosition);
  }

  void moveLeft() {
    _playerPosition -= _playerSpeed;
    if (_playerPosition <= -1.00001) _playerPosition = 1;
    _playerX.add(_playerPosition);
  }
}
