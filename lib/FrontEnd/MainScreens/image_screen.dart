import 'package:flutter/material.dart';
import 'package:google_signin/FrontEnd/GamesScreens/maze_runner.dart';

class ImageScreen extends StatefulWidget {
  const ImageScreen({Key? key}) : super(key: key);

  @override
  State<ImageScreen> createState() => _ImageScreenState();
}

class _ImageScreenState extends State<ImageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => const MazeRunner()));
            },
            child: const Text('MazeRunner'),
          ),
        ],
      )),
    );
  }
}
