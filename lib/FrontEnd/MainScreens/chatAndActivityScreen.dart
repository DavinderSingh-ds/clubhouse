// ignore_for_file: file_names

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_signin/Backend/firebase/OnlineDatabaseManagement/cloud_data_management.dart';
import 'package:google_signin/Backend/sqlite_management/local_database_management.dart';
import 'package:google_signin/FrontEnd/Services/ChatManagement/chat_screen.dart';
import 'package:google_signin/FrontEnd/Services/search_screen.dart';
import 'package:google_signin/Global_Uses/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_signin/Global_Uses/enum_generation.dart';
import 'package:loading_overlay/loading_overlay.dart';

import 'package:animations/animations.dart';
import 'package:lottie/lottie.dart';

class ChatAndActivityScreen extends StatefulWidget {
  const ChatAndActivityScreen({Key? key}) : super(key: key);

  @override
  _ChatAndActivityScreenState createState() => _ChatAndActivityScreenState();
}

class _ChatAndActivityScreenState extends State<ChatAndActivityScreen> {
  bool _isLoading = false;
  final List<String> _allUserConnectionActivity = [
    'ClubHouse',
    'Davinder',
    'ClubHouse',
    'Davinder',
    'ClubHouse',
    'Davinder',
    'ClubHouse',
    'Davinder'
  ];
  final List<String> _allConnectionsUserName = [];

  final CloudStoreDataManagement _cloudStoreDataManagement =
      CloudStoreDataManagement();

  final LocalDatabase _localDatabase = LocalDatabase();

  static final FirestoreFieldConstants _firestoreFieldConstants =
      FirestoreFieldConstants();

  /// For New Connected User Data Entry
  Future<void> _checkingForNewConnection(
      QueryDocumentSnapshot<Map<String, dynamic>> queryDocumentSnapshot,
      List<QueryDocumentSnapshot<Map<String, dynamic>>> docs) async {
    if (mounted) {
      setState(() {
        _isLoading = true;
      });
    }

    final List<dynamic> _connectionRequestList =
        queryDocumentSnapshot.get(_firestoreFieldConstants.connectionRequest);

    for (var connectionRequestData in _connectionRequestList) {
      if (connectionRequestData.values.first.toString() ==
              OtherConnectionStatus.Invitation_Accepted.toString() ||
          connectionRequestData.values.first.toString() ==
              OtherConnectionStatus.Request_Accepted.toString()) {
        for (var everyDocument in docs) {
          if (everyDocument.id == connectionRequestData.keys.first.toString()) {
            final String _connectedUserName =
                everyDocument.get(_firestoreFieldConstants.userName);
            final String _token =
                everyDocument.get(_firestoreFieldConstants.token);
            final String _about =
                everyDocument.get(_firestoreFieldConstants.about);
            final String _accCreationDate =
                everyDocument.get(_firestoreFieldConstants.creationDate);
            final String _accCreationTime =
                everyDocument.get(_firestoreFieldConstants.creationTime);

            if (mounted) {
              setState(() {
                if (!_allConnectionsUserName.contains(_connectedUserName)) {
                  _allConnectionsUserName.add(_connectedUserName);
                }
              });
            }

            final bool _newConnectionUserNameInserted =
                await _localDatabase.insertOrUpdateDataForThisAccount(
                    userName: _connectedUserName,
                    userMail: everyDocument.id,
                    userToken: _token,
                    userAbout: _about,
                    userAccCreationDate: _accCreationDate,
                    userAccCreationTime: _accCreationTime);

            if (_newConnectionUserNameInserted) {
              await _localDatabase.createTableForEveryUser(
                  userName: _connectedUserName);
            }
          }
        }
      }
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// Fetch Real Time Data From Cloud Firestore
  Future<void> _fetchRealTimeDataFromCloudStorage() async {
    final realTimeSnapshot =
        await _cloudStoreDataManagement.fetchRealTimeDataFromFirestore();

    realTimeSnapshot!.listen((querySnapshot) {
      for (var queryDocumentSnapshot in querySnapshot.docs) {
        if (queryDocumentSnapshot.id ==
            FirebaseAuth.instance.currentUser!.email.toString()) {
          _checkingForNewConnection(queryDocumentSnapshot, querySnapshot.docs);
        }
      }
    });
  }

  @override
  void initState() {
    _fetchRealTimeDataFromCloudStorage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        floatingActionButton: _externalConnectionManagement(),
        body: LoadingOverlay(
          color: const Color.fromRGBO(0, 0, 0, 0.5),
          progressIndicator: const CircularProgressIndicator(
            backgroundColor: Colors.black87,
          ),
          isLoading: _isLoading,
          child: ListView(
            children: [
              _activityList(context),
              _connectionList(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _activityList(BuildContext context) {
    return Container(
      color: Colors.grey[100],
      margin: const EdgeInsets.only(
        top: 20.0,
        left: 10.0,
      ),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).orientation == Orientation.portrait
          ? MediaQuery.of(context).size.height * (1.5 / 11)
          : MediaQuery.of(context).size.height * (3 / 9),
      child: ListView.builder(
        scrollDirection: Axis.horizontal, // Make ListView Horizontally
        itemCount: _allUserConnectionActivity.length,
        itemBuilder: (context, position) {
          return _activityCollectionList(context, position);
        },
      ),
    );
  }

  Widget _activityCollectionList(BuildContext context, int index) {
    return Container(
      margin: EdgeInsets.only(right: MediaQuery.of(context).size.width / 40),
      child: Column(
        children: [
          Stack(
            children: [
              if (_allUserConnectionActivity[index]
                  .contains('[[[new_activity]]]'))
                Container(
                  color: Colors.red,
                  child: const CircularProgressIndicator(
                    color: Colors.blue,
                    value: 1.0,
                  ),
                ),
              OpenContainer(
                closedElevation: 0.0,
                closedShape: const CircleBorder(),
                transitionDuration: const Duration(
                  milliseconds: 500,
                ),
                transitionType: ContainerTransitionType.fadeThrough,
                openBuilder: (context, openWidget) {
                  return const Center();
                },
                closedBuilder: (context, closeWidget) {
                  return CircleAvatar(
                    backgroundColor: Colors.white,
                    backgroundImage:
                        const ExactAssetImage('assets/images/ds.jpg'),
                    radius: MediaQuery.of(context).orientation ==
                            Orientation.portrait
                        ? MediaQuery.of(context).size.height * (1.2 / 8) / 3.7
                        : MediaQuery.of(context).size.height * (1.2 / 8) / 3.7,
                  );
                },
              ),
              // index == 0 // This is for current user Account
              //     ? Padding(
              //         padding: EdgeInsets.only(
              //           top: MediaQuery.of(context).orientation ==
              //                   Orientation.portrait
              //               ? MediaQuery.of(context).size.height * (0.7 / 8) -
              //                   10
              //               : MediaQuery.of(context).size.height * (1.5 / 8) -
              //                   10,
              //           left: MediaQuery.of(context).orientation ==
              //                   Orientation.portrait
              //               ? MediaQuery.of(context).size.width / 3 - 65
              //               : MediaQuery.of(context).size.width / 8 - 15,
              //         ),
              //         child: Container(
              //             decoration: const BoxDecoration(
              //               shape: BoxShape.circle,
              //               color: Colors.lightBlue,
              //             ),
              //             child: GestureDetector(
              //               child: Icon(
              //                 Icons.add,
              //                 color: Colors.white,
              //                 size: MediaQuery.of(context).orientation ==
              //                         Orientation.portrait
              //                     ? MediaQuery.of(context).size.height *
              //                         (1.3 / 8) /
              //                         2.5 *
              //                         (3.5 / 6)
              //                     : MediaQuery.of(context).size.height *
              //                         (1.3 / 8) /
              //                         2,
              //               ),
              //             )),
              //       )
              //     : const SizedBox(),
            ],
          ),
          Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.only(
              top: 7.0,
            ),
            child: const Text(
              'ClubHouse',
              style: TextStyle(
                color: Colors.black,
                fontSize: 12.0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _connectionList(BuildContext context) {
    return LoadingOverlay(
      isLoading: _isLoading,
      child: Container(
        padding: const EdgeInsets.only(top: 18.0, bottom: 10.0),
        height: MediaQuery.of(context).size.height * (5.15 / 7.7),
        decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.blue,
              blurRadius: 0.5,
              spreadRadius: 0.0,
            )
          ],
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
        ),
        child: ReorderableListView.builder(
          onReorder: (first, last) {
            if (mounted) {
              setState(() {
                final String _draggableConnection =
                    _allConnectionsUserName.removeAt(first);

                _allConnectionsUserName.insert(
                    last >= _allConnectionsUserName.length
                        ? _allConnectionsUserName.length
                        : last > first
                            ? --last
                            : last,
                    _draggableConnection);
              });
            }
          },
          itemCount: _allConnectionsUserName.length,
          itemBuilder: (context, position) {
            return chatTileContainer(
                context, position, _allConnectionsUserName[position]);
          },
        ),
      ),
    );
  }

  Widget chatTileContainer(BuildContext context, int index, String _userName) {
    return Card(
        key: Key('$index'),
        elevation: 0.0,
        color: Colors.grey,
        child: Container(
          color: Colors.green,
          padding: const EdgeInsets.only(left: 3, right: 3),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              elevation: 0.0,
              primary: Colors.white,
              onPrimary: Colors.lightBlueAccent,
            ),
            onPressed: () {
              log("Chat List Pressed");
            },
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    top: 1.0,
                    bottom: 3.0,
                  ),
                  child: OpenContainer(
                    closedShape: const CircleBorder(),
                    closedElevation: 0.0,
                    transitionDuration: const Duration(milliseconds: 500),
                    transitionType: ContainerTransitionType.fadeThrough,
                    openBuilder: (_, __) {
                      return const Center();
                    },
                    closedBuilder: (_, __) {
                      return const CircleAvatar(
                        radius: 30.0,
                        backgroundColor: Colors.black12,
                        backgroundImage:
                            ExactAssetImage('assets/images/ds.jpg'),
                        // getProperImageProviderForConnectionsCollection(
                        //    _userName),
                      );
                    },
                  ),
                ),
                OpenContainer(
                  // closedColor: const Color.fromARGB(255, 236, 239, 247),
                  // openColor: const Color.fromARGB(255, 236, 239, 247),
                  // middleColor: const Color.fromARGB(255, 236, 239, 247),
                  closedElevation: 0.0,
                  openElevation: 0.0,
                  transitionDuration: const Duration(milliseconds: 500),
                  transitionType: ContainerTransitionType.fadeThrough,
                  openBuilder: (context, openWidget) {
                    return ChatScreen(
                      userName: _userName,
                    );
                  },
                  closedBuilder: (context, closeWidget) {
                    return Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width / 2 + 30,
                      padding: const EdgeInsets.only(
                        top: 5.0,
                        bottom: 5.0,
                        left: 5.0,
                      ),
                      child: Column(
                        children: [
                          Text(
                            _userName.length <= 18
                                ? _userName
                                : _userName.replaceRange(
                                    18, _userName.length, '...'),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 18.0,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(
                            height: 12.0,
                          ),

                          /// For Extract latest Conversation Message
//                          _latestDataForConnectionExtractPerfectly(_userName)
                          const Text(
                            'Hello Davinder',
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.only(
                      top: 2.0,
                      bottom: 2.0,
                    ),
                    child: Lottie.network(
                        'https://assets5.lottiefiles.com/packages/lf20_OHjIOS.json'),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Widget _externalConnectionManagement() {
    return OpenContainer(
      closedShape: const CircleBorder(),
      closedElevation: 15.0,
      transitionDuration: const Duration(
        milliseconds: 500,
      ),
      transitionType: ContainerTransitionType.fadeThrough,
      openBuilder: (_, __) {
        return const SearchScreen();
      },
      closedBuilder: (_, __) {
        return Container(
          padding: const EdgeInsets.all(10.0),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.add,
            color: Colors.green,
            size: 37.0,
          ),
        );
      },
    );
  }
}
