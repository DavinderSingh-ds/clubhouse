import 'package:flutter/material.dart';

import 'package:loading_overlay/loading_overlay.dart';

class LogsCollection extends StatefulWidget {
  const LogsCollection({Key? key}) : super(key: key);

  @override
  _LogsCollectionState createState() => _LogsCollectionState();
}

class _LogsCollectionState extends State<LogsCollection> {
  final bool _isLoading = false;

  final List<String> _callingConnection = [
    'Davinder Singh',
    'Ketika Sharma',
    'Jahnvi Kapoor',
    'Amitabh Bachchan',
    'Hrithik Roshan',
    'VikramJit Singh',
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: LoadingOverlay(
          color: const Color.fromRGBO(0, 0, 0, 0.5),
          progressIndicator: const CircularProgressIndicator(
            backgroundColor: Colors.black87,
          ),
          isLoading: _isLoading,
          child: Container(
            margin: const EdgeInsets.all(12.0),
            width: double.maxFinite,
            height: double.maxFinite,
            child: ListView.builder(
              itemCount: _callingConnection.length,
              itemBuilder: (upperContext, index) =>
                  _everyConnectionHistory(index),
            ),
          ),
        ),
      ),
    );
  }

  Widget _everyConnectionHistory(int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 3.0),
      child: Card(
        elevation: 1,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const CircleAvatar(
              radius: 30.0,
              backgroundColor: Color.fromARGB(255, 248, 244, 244),
              backgroundImage: ExactAssetImage('assets/images/google.png'),
              //getProperImageProviderForConnectionsCollection(
              //    _userName),
            ),
            Text(
              _callingConnection[index],
              style: const TextStyle(color: Colors.black, fontSize: 20.0),
            ),
            IconButton(
              icon: const Icon(
                Icons.call,
                size: 30.0,
                color: Colors.green,
              ),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
