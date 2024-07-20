import 'dart:async';
import 'dart:developer';

import 'package:bubble_trouble/ball.dart';
import 'package:bubble_trouble/button.dart';
import 'package:bubble_trouble/missile.dart';
import 'package:bubble_trouble/player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

enum Direction { left, right }

class _HomePageState extends State<HomePage> {
  late final Size mq;
  bool _midShot = false;

  //player variables
  final _player = StreamController<double>();
  double _playerPositionX = 0;
  final double _playerSpeed = 0.05;

  //missile variables
  final _missileHeightController = StreamController<List<double>>();
  double _missileX = 0.0;
  double _missileHeight = 10;

  //Ball variables
  final _ballController = StreamController<List<double>>();
  double ballX = 0.5;
  double ballY = 0;

  @override
  void initState() {
    super.initState();
    _player.add(_playerPositionX);
    _missileHeightController.add([_missileHeight, _missileX]);
    _ballController.add([ballX, ballY]);
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
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
          } else if (value.logicalKey.debugName == 'Arrow Up' &&
              value is! KeyRepeatEvent) {
            fireMissile();
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
                  children: [
                    MyBall(
                      ballController: _ballController,
                    ),
                    MyMissile(
                        missileHeightController: _missileHeightController),
                    MyPlayer(playerX: _player),
                  ],
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
                    icon: Icons.play_arrow,
                    onButtonPress: playGame,
                  ),
                  MyButton(
                    icon: Icons.arrow_back,
                    onButtonPress: moveLeft,
                  ),
                  MyButton(
                    icon: Icons.arrow_upward,
                    onButtonPress: fireMissile,
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
    _playerPositionX += _playerSpeed;
    if (!_midShot) {
      _missileX = _playerPositionX;
      _missileHeightController.add([_missileHeight, _missileX]);
    }
    if (_playerPositionX > 1.00001) _playerPositionX = -1;
    _player.add(_playerPositionX);
  }

  void moveLeft() {
    _playerPositionX -= _playerSpeed;
    if (!_midShot) {
      _missileX = _playerPositionX;
      _missileHeightController.add([_missileHeight, _missileX]);
    }
    if (_playerPositionX <= -1.00001) _playerPositionX = 1;
    _player.add(_playerPositionX);
  }

  void fireMissile() {
    if (_midShot == false) {
      Timer.periodic(const Duration(microseconds: 100), (timer) {
        _midShot = true;
        _missileHeight += 10;
        if (_missileHeight > mq.height * 3 / 4) {
          resetMissile();
          timer.cancel();
        }
        _missileHeightController.add([_missileHeight, _missileX]);
        if (ballY < heightToPosition(_missileHeight) &&
            (ballX - _missileX).abs() < 0.03) {
          ballX = 5;
          resetMissile();
          timer.cancel();
        }
      });
    }
  }

  bool playerDies() {
    if ((ballX - _playerPositionX).abs() < 0.05 && ballY > 0.95) {
      return true;
    } else {
      return false;
    }
  }

  void resetMissile() {
    _midShot = false;
    _missileHeight = 0;
    _missileX = _playerPositionX;
  }

  void playGame() {
    var ballDirection = Direction.left;
    double time = 0;
    double height = 0;
    double velocity = 60;

    Timer.periodic(const Duration(milliseconds: 50), (timer) {
      //quardratic equation that models a bounce (upside down parabloa)
      height = -5 * time * time + velocity * time;

      if (height < 0) {
        time = 0;
      }

      ballY = heightToPosition(height);

      if (ballX - 0.005 < -1) {
        ballDirection = Direction.right;
      } else if (ballX + 0.005 > 1) {
        ballDirection = Direction.left;
      }
      if (ballDirection == Direction.left) {
        ballX -= 0.005;
      } else if (ballDirection == Direction.right) {
        ballX += 0.005;
      }
      _ballController.add([ballX, ballY]);
      time += 0.1;

      if (playerDies()) {
        timer.cancel();
        _showDialog();
        log("Dead💀");
      }
    });
  }

  double heightToPosition(double height) {
    double totalHeight = mq.height * 3 / 4;
    double missileY = 1 - height / totalHeight * 2;
    return missileY;
  }

  void _showDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.grey[700],
          title: const Text(
            "You dead bro!",
            style: TextStyle(color: Colors.white),
          ),
        );
      },
    );
  }
}
