import 'dart:developer';

import 'package:flutter/material.dart';
import '../../Backend/sqlite_management/databaseDiary.dart';
import '../../Backend/sqlite_management/diaryModel/diaryModel.dart';
import '../../Themes/ThemeColors.dart';
import '../NewUserEntry/enter_diary_detail.dart';

class Diary extends StatefulWidget {
  const Diary({Key? key}) : super(key: key);

  @override
  _DiaryState createState() => _DiaryState();
}

class _DiaryState extends State<Diary> {
  var _databaseprovider;
  late Future<List<DogModel>> expenseTransactionsList;
  late Future<List<DogModel>> transactionsList;
  var totalIncome;
  var totalExpense;

  void initState() {
    super.initState();
    _databaseprovider = Databaseprovider.instance;
    refreshData();
  }

  refreshData() {
    setState(() {
      getTransactions();
    });
  }

  getTransactions() {
    setState(() {
      transactionsList = _databaseprovider.getAllTransactions();
      log('Data from categoryList $transactionsList');
    });
  }

  var size, width, height, oreintation;
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    width = size.width;
    height = size.height;
    oreintation = MediaQuery.of(context).orientation;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: ThemeColors.kLightGreen,
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 10, right: 10, top: 10, bottom: 5),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(15, 209, 42, 139),
                        borderRadius: BorderRadius.circular(5),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.greenAccent,
                            offset: Offset(
                              5.0,
                              5.0,
                            ),
                            blurRadius: 10.0,
                            spreadRadius: 2.0,
                          ),
                          BoxShadow(
                            color: Colors.white,
                            offset: Offset(0.0, 0.0),
                            blurRadius: 0.0,
                            spreadRadius: 0.0,
                          ),
                        ],
                      ),
                      width: 300,
                      height: 40,
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: FittedBox(
                          child: Text(
                            '👀 See Available Dogs 🐕',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 2,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 460,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: FutureBuilder(
                          future: transactionsList,
                          builder: (BuildContext context,
                              AsyncSnapshot<List<DogModel>> snapshot) {
                            if (snapshot.hasData) {
                              log('Length of transaction $snapshot.data?.length');
                              return ListView.builder(
                                itemCount: snapshot.data?.length,
                                itemBuilder: (BuildContext context, int index) {
                                  DogModel dogModel = snapshot.data![index];

                                  return Card(
                                    elevation: 0.8,
                                    child: Column(
                                      children: [
                                        const SizedBox(
                                          height: 2,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            left: 6,
                                            right: 6,
                                            bottom: 1,
                                            top: 8,
                                          ),
                                          child: Container(
                                            child: Row(
                                              children: [
                                                Container(
                                                  width: 210,
                                                  child: Text(
                                                    'Dog Name : ${dogModel.dogName}',
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 7.0, top: 2),
                                          child: Row(
                                            children: [
                                              Container(
                                                width: 220,
                                                child: Text(
                                                  'Dog Breed  : ${dogModel.dogBreed}',
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                'Dog Age : ${dogModel.dogAge}',
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.green,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 7.0, top: 2),
                                          child: Row(
                                            children: [
                                              Text(
                                                'Dog Color   : ${dogModel.dogColor}',
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            const SizedBox(
                                              width: 7,
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.only(top: 3),
                                              child: Container(
                                                width: 300,
                                                child: Text(
                                                  dogModel.date,
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 8,
                                              right: 10,
                                              bottom: 6,
                                              top: 5),
                                          child: Container(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Container(
                                                  height: 25,
                                                  width: 100,
                                                  child: MaterialButton(
                                                    color: Colors.grey[200],
                                                    onPressed: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              EnterDetail(
                                                            title:
                                                                'Update Category',
                                                            newexpenseModel:
                                                                dogModel,
                                                            buttonName:
                                                                'Update',
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                    child: const Icon(
                                                      Icons.update,
                                                      color: Colors.blue,
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  height: 25,
                                                  width: 100,
                                                  child: MaterialButton(
                                                    color: Colors.grey[200],
                                                    onPressed: () {
                                                      _databaseprovider
                                                          .deleteTransaction(
                                                              dogModel.id);
                                                      refreshData();
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        const SnackBar(
                                                          content: Text(
                                                              'Category Deleted'),
                                                          duration: Duration(
                                                              seconds: 1),
                                                        ),
                                                      );
                                                    },
                                                    child: const Icon(
                                                      Icons.delete,
                                                      color: Colors.red,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            } else {
                              return Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Text('Please Wait.....'),
                                    SizedBox(height: 30),
                                    CircularProgressIndicator(),
                                  ],
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: 75,
            child: Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                    color: Colors.cyanAccent,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          const SizedBox(
                            width: 30,
                          ),
                          MaterialButton(
                            height: 42,
                            minWidth: 280,
                            color: Colors.amber,
                            child: const Text(
                              'Add Dog Detail',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EnterDetail(title: ''),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
