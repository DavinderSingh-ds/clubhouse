import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:maze/maze.dart';

class MazeRunner extends StatefulWidget {
  const MazeRunner({Key? key}) : super(key: key);

  @override
  State<MazeRunner> createState() => _MazeRunnerState();
}

class _MazeRunnerState extends State<MazeRunner> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Maze(
          player: MazeItem(
            'assets/images/ds.jpg',
            ImageType.asset,
          ),
          columns: 15,
          rows: 25,
          wallThickness: 4.0,
          wallColor: Theme.of(context).primaryColor,
          finish: MazeItem('assets/images/ds.jpg', ImageType.asset),
          onFinish: () => log("Game Finished"),
        ),
      ),
    );
  }
}
