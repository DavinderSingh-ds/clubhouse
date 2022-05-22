// ignore_for_file: prefer_final_fields

import 'dart:developer';

import 'package:flutter/material.dart';

import '../../Backend/sqlite_management/databaseDiary.dart';
import '../../Backend/sqlite_management/diaryModel/diaryModel.dart';

class EnterDetail extends StatefulWidget {
  const EnterDetail({
    Key? key,
    required this.title,
    this.newexpenseModel,
    this.buttonName,
  }) : super(key: key);
  final String title;
  final DogModel? newexpenseModel;
  final String? buttonName;

  @override
  _EnterDetailState createState() => _EnterDetailState();
}

class _EnterDetailState extends State<EnterDetail> {
  final TextEditingController _nameController = TextEditingController();
  TextEditingController _dateController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _colorController = TextEditingController();
  TextEditingController _amountController = TextEditingController();
  GlobalKey _formKey = GlobalKey();

  final _databaseProvider = Databaseprovider.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Dog Detail',
          style: TextStyle(fontSize: 18),
        ),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20, right: 4, left: 4),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    blurRadius: 10,
                    color: Colors.blueAccent,
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(
                      top: 25,
                    ),
                    child: Text(
                      'ADD DETAIL OF DOG',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(
                          height: 2,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 8, left: 14, right: 14),
                          child: TextFormField(
                            controller: _nameController,
                            textInputAction: TextInputAction.next,
                            validator: (s) {
                              if (s!.isEmpty) {
                                return 'Enter the name of dog First';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              labelText: 'Dog Name',
                              labelStyle: TextStyle(fontSize: 14),
                              hintText: 'Enter Name Of Dog',
                              hintStyle: TextStyle(fontSize: 14),
                              icon: Icon(Icons.pets_rounded),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 16, left: 14, right: 14),
                          child: TextFormField(
                            controller: _colorController,
                            textInputAction: TextInputAction.next,
                            validator: (s) {
                              if (s!.isEmpty) {
                                return 'Enter the dog color First';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              labelText: 'Dog Color',
                              labelStyle: TextStyle(fontSize: 14),
                              hintText: 'Enter Color Of Dog',
                              hintStyle: TextStyle(fontSize: 14),
                              icon: Icon(Icons.color_lens),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 16, left: 14, right: 14),
                          child: TextFormField(
                            controller: _amountController,
                            textInputAction: TextInputAction.next,
                            validator: (s) {
                              if (s!.isEmpty) {
                                return 'Enter the age of dog First';
                              }
                              return null;
                            },
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Dog Age',
                              labelStyle: TextStyle(fontSize: 14),
                              hintText: 'Enter the Age of Dog',
                              hintStyle: TextStyle(fontSize: 14),
                              icon: Icon(Icons.add_reaction),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 16, left: 14, right: 14),
                          child: TextFormField(
                            controller: _descriptionController,
                            textInputAction: TextInputAction.next,
                            validator: (des) {
                              if (des!.isEmpty) {
                                return 'Enter the breed of dog First';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              labelText: 'Dog Breed',
                              labelStyle: TextStyle(fontSize: 14),
                              hintText: 'Enter Breed of Dog',
                              hintStyle: TextStyle(fontSize: 14),
                              icon: Icon(Icons.whatshot_rounded),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 16, left: 14, right: 14),
                          child: TextFormField(
                            controller: _dateController,
                            textInputAction: TextInputAction.done,
                            decoration: const InputDecoration(
                              labelText: 'Description',
                              labelStyle: TextStyle(fontSize: 14),
                              hintText: 'Enter extra info of Dog',
                              hintStyle: TextStyle(fontSize: 14),
                              icon: Icon(Icons.description),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 24, left: 14, right: 14),
                          child: MaterialButton(
                            color: Colors.blue,
                            height: 45,
                            child: Text(
                              widget.buttonName != null
                                  ? widget.buttonName!
                                  : 'Save',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                            onPressed: () {
                              final FormState? formm =
                                  _formKey.currentState as FormState?;
                              if (formm!.validate()) {
                                log('Expense is ${_amountController.text.toString()}');
                                final newexpensess = DogModel(
                                  dogAge: _amountController.text.toString(),
                                  dogBreed:
                                      _descriptionController.text.toString(),
                                  dogName: _nameController.text.toString(),
                                  date: _dateController.text.toString(),
                                  dogColor: _colorController.text.toString(),
                                );

                                if (_amountController.text
                                    .toString()
                                    .isNotEmpty) {
                                  var catId = _databaseProvider
                                      .addTransaction(newexpensess);
                                  log(catId.toString());
                                }
                                if (widget.newexpenseModel != null) {
                                  newexpensess.id = widget.newexpenseModel!.id;
                                  _databaseProvider
                                      .updateTransaction(newexpensess);
                                }
                                Navigator.pop(context);
                              }
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
