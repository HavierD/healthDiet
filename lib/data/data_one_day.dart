import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DataOneDay{

  int? _id;
  late String date;
  String? milk;
  String? nut;
  String? egg;
  String? vegetable;
  String? fruit;
  String? allGrain;
  String? walk;

  DataOneDay({this.milk, this.nut, this.egg, this.vegetable, this.fruit,
    this.allGrain, this.walk, required this.date});


  Map<String, dynamic> toMap(){
    return {
      'date': date,
      'milk': milk,
      'nut': nut,
      'egg': egg,
      'vegetable': vegetable,
      'fruit': fruit,
      'allgrain': allGrain,
      'walk': walk,
    };
  }

}

class DataOneDayModel extends ChangeNotifier{
  late final DataOneDay dataOfToday;
  final List<DataOneDay> allData = [];

  DataOneDayModel() {
    fetch();
  }

  Future fetch() async{
    allData.clear();
    final database = openDatabase(
      join(await getDatabasesPath(), 'health_diet.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE data (id INTEGER PRIMARY KEY, date TEXT,milk TEXT, nut TEXT, egg TEXT, vegetable TEXT, fruit TEXT, allgrain TEXT , walk TEXT)',
        );
      },
      version: 1,
    );
    final db = await database;

    var querySnapshot = await db.query('data');
    var allDataTemp = List.generate(querySnapshot.length, (i){
      return DataOneDay(
        milk: querySnapshot[i]["milk"].toString(),
        nut: querySnapshot[i]["nut"].toString(),
        egg: querySnapshot[i]["egg"].toString(),
        vegetable: querySnapshot[i]["vegetable"].toString(),
        fruit: querySnapshot[i]["fruit"].toString(),
        allGrain: querySnapshot[i]["allgrain"].toString(),
        walk: querySnapshot[i]["walk"].toString(),
        date: querySnapshot[i].toString(),
      );
    });
    allDataTemp.addAll(allDataTemp);
  }

  DataOneDay getTodayData(){
    for (var element in allData) {
      if(element.date == getTodayDate()){
        return element;
      }
    }
    return DataOneDay(date: getTodayDate());
  }

  String getTodayDate() {
    DateTime dateTime = DateTime.now();
    return "${dateTime.year}/${dateTime.month}/${dateTime.day}";
  }


  // void add (DataOneDay dataOneDay){
  //   data.add(dataOneDay);
  //   update();
  // }

  void refreshUI(){
    notifyListeners();
  }

  Future update(DietCategories categories, String content)async{
    switch (categories){
      case DietCategories.milk:
        dataOfToday.milk = content;
        break;
      case DietCategories.nut:
        dataOfToday.nut = content;
        break;
      case DietCategories.egg:
        dataOfToday.egg = content;
        break;
      case DietCategories.vegetable:
        dataOfToday.vegetable = content;
        break;
      case DietCategories.fruit:
        dataOfToday.fruit = content;
        break;
      case DietCategories.allGrain:
        dataOfToday.allGrain = content;
        break;
      case DietCategories.walk:
        dataOfToday.walk = content;
        break;
    }
    await
  }



}

enum DietCategories{
  milk,
  nut,
  egg,
  vegetable,
  fruit,
  allGrain,
  walk,
}