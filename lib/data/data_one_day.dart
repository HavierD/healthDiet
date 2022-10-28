import 'dart:mirrors';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:health_diet/toast_exception_alert.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'diet_category.dart';

class DataOneDay {
  late String date;
  String? milk;
  String? nut;
  String? meat;
  String? egg;
  String? vegetable;
  String? fruit;
  String? allGrain;
  String? walk;

  DataOneDay({this.milk,
    this.nut,
    this.meat,
    this.egg,
    this.vegetable,
    this.fruit,
    this.allGrain,
    this.walk,
    required this.date});

  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'milk': milk,
      'nut': nut,
      'meat': meat,
      'egg': egg,
      'vegetable': vegetable,
      'fruit': fruit,
      'allgrain': allGrain,
      'walk': walk,
    };
  }
}

class DataOneDayModel extends ChangeNotifier {
  DataOneDay? dataOfToday;
  final List<DataOneDay> allData = [];
  bool loading = true;
  Database? db;

  final List<DietCategory> _dietCategoriesInfo = [];

  DataOneDayModel() {
    _initDietCategoriesInfo();
    fetchAllData();
  }

  Future fetchAllData() async {
    db = await initiateDatabase();
    var querySnapshot = await db!.query('data');
    for (var e in querySnapshot) {
      allData.add(DataOneDay(
        milk: e["milk"].toString(),
        nut: e["nut"].toString(),
        meat: e["meat"].toString(),
        egg: e["egg"].toString(),
        vegetable: e["vegetable"].toString(),
        fruit: e["fruit"].toString(),
        allGrain: e["allGrain"].toString(),
        walk: e["walk"].toString(),
        date: e["date"].toString(),
      ));
    }
    getTodayData();
    loading = false;
    refreshUI();
  }
  void dbInitChecking()async{
    while(db == null){
      print("delay 0,1 second");
      await Future.delayed(const Duration(seconds: 1));
    }
  }
  Future<Map<String, Object?>> getTodaySnapshot()async{
    db = await initiateDatabase();
    var all = await db!.query('data');
    for (var element in all) {
      if (element['date'] == getTodayDate()){return element;}
    }
    ToastExceptionAlert.alert("获取数据错误！！data_one_day.getTodaySnapshot()");
    refreshUI();
    return <String, Object?>{};
  }

  test(){
    InstanceMirror mirror = reflect(dataOfToday);
  }

  Future<Database> initiateDatabase() async {
    allData.clear();
    final database = openDatabase(
      join(await getDatabasesPath(), 'health_diet.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE if not exists data (date TEXT PRIMARY KEY,milk TEXT, '
              'nut TEXT, meat TEXT, egg TEXT, vegetable TEXT, fruit TEXT, '
              'allgrain TEXT , walk TEXT)',
        );
      },
      version: 1,
    );

    return database;
  }

  void getTodayData() async {
    for (var element in allData) {
      if (element.date == getTodayDate()) {
        dataOfToday = element;
        return;
      }
    }
    if (dataOfToday == null) {
      dataOfToday = DataOneDay(date: getTodayDate());
      await db!.insert("data", dataOfToday!.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
      update();
    }
  }

  String getTodayDate() {
    DateTime dateTime = DateTime.now();
    return "${dateTime.year}/${dateTime.month}/${dateTime.day}";
  }

  // void add (DataOneDay dataOneDay){
  //   data.add(dataOneDay);
  //   update();
  // }

  void refreshUI() {
    notifyListeners();
  }

  void allNullForDebugging() async {
    var nullA = DataOneDay(date: getTodayDate());
    await db!.insert(
        "data", nullA.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    refreshUI();
  }


  DietCategory getDietCategory(DietCategoriesEnum c) {
    for (var e in _dietCategoriesInfo) {
      if (e.category == c) {
        return e;
      }
    }
    ToastExceptionAlert.alert("类别信息获取错误！: DataOneDayModel.getDietCategory()");
    return _dietCategoriesInfo.first;
  }

  Future update([DietCategoriesEnum? categories, String? content]) async {
    switch (categories) {
      case DietCategoriesEnum.milk:
        dataOfToday!.milk = content;
        break;
      case DietCategoriesEnum.nut:
        dataOfToday!.nut = content;
        break;
      case DietCategoriesEnum.meat:
        dataOfToday!.meat = content;
        break;
      case DietCategoriesEnum.egg:
        dataOfToday!.egg = content;
        break;
      case DietCategoriesEnum.vegetable:
        dataOfToday!.vegetable = content;
        break;
      case DietCategoriesEnum.fruit:
        dataOfToday!.fruit = content;
        break;
      case DietCategoriesEnum.allGrain:
        dataOfToday!.allGrain = content;
        break;
      case DietCategoriesEnum.walk:
        dataOfToday!.walk = content;
        break;
      default:
        break;
    }
    await db!.update("data", dataOfToday!.toMap(),
        where: 'date = ?', whereArgs: [dataOfToday!.date]);
    print("have been here?");
    await fetchAllData();
    refreshUI();
  }

  String getDBValueByCategory(DietCategoriesEnum category) {
    switch (category) {
      case DietCategoriesEnum.milk:
        return dataOfToday!.milk.toString();
      case DietCategoriesEnum.nut:
        return dataOfToday!.milk.toString();
      case DietCategoriesEnum.egg:
        return dataOfToday!.milk.toString();
      case DietCategoriesEnum.vegetable:
        return dataOfToday!.milk.toString();
      case DietCategoriesEnum.fruit:
        return dataOfToday!.milk.toString();
      case DietCategoriesEnum.allGrain:
        return dataOfToday!.milk.toString();
      case DietCategoriesEnum.walk:
        return dataOfToday!.milk.toString();
      default:
        return "";
    }
  }

  void _initDietCategoriesInfo() {
    var milkBtns = {
      "milk": "1 ~ 2杯牛奶",
      "yogurt": "1 ~ 2杯酸奶",
      "others": "其他奶制品",
      "less": "摄入很少奶制品",
      "null": "完全没摄入奶制品"
    };
    var nutBtns = {
      "soybeans": "豆腐等大豆制品",
      "seeds": "花生 / 葵花子等",
      "others": "其他常见坚果",
      "less": "吃了很少的豆制品/坚果",
      "null": "没吃豆制品/坚果",
    };
    var meatBtns = {
      "seafood": "水产品",
      "redmeat": "猪牛羊肉",
      "poultry": "鸡鸭鹅肉",
      "less": "吃了很少的肉",
      "null": "没吃肉",
    };
    var eggBtns = {
      "eggs": "鸡蛋1 ~ 2个",
      "toomuch": "鸡蛋2个以上",
      "less": "吃了很少鸡蛋",
      "null": "没吃鸡蛋",
    };
    var vegBtns = {
      "vegetable": "蔬菜半斤~1斤（生重）",
      "less": "吃了很少蔬菜",
      "null": "没吃蔬菜",
    };
    var fruitBtns = {
      "fruit": "半斤水果",
      "toomuch": "远超半斤水果",
      "less": "吃了很少水果",
      "null": "没吃水果",
    };
    var allGrainBtns = {
      "allGrain": "粗粮",
      "beans": "杂豆饭",
      "less": "吃了很少粗粮/杂豆",
      "null": "没吃粗粮/杂豆",
    };
    var walkBtns = {
      "1000": "少于1000步",
      "4000": "1000~4000步",
      "7000": "4000~7000步",
      "10000": "7000~10000步",
      "13000": "10000~13000步",
      "16000": "13000步以上",
    };
    var milk = DietCategory(
      DietCategoriesEnum.milk, "奶类", "milk is a ....", milkBtns,);
    var nut = DietCategory(
      DietCategoriesEnum.nut, "豆制品和坚果", "nut is a ...", nutBtns,);
    var meat = DietCategory(
      DietCategoriesEnum.meat, "肉类", "meat is a kind of ...", meatBtns,);
    var egg = DietCategory(
        DietCategoriesEnum.egg, "蛋", "Egg is dsfsd... ", eggBtns);
    var vegetable = DietCategory(
        DietCategoriesEnum.vegetable, "茎叶类蔬菜", "vegetable is...", vegBtns);
    var fruit = DietCategory(
        DietCategoriesEnum.fruit, "水果", "Fruit cannot have... ", fruitBtns);
    var allGrain = DietCategory(
        DietCategoriesEnum.allGrain, "全谷物/杂豆", "all grains is...",
        allGrainBtns);
    var walk = DietCategory(
        DietCategoriesEnum.walk, "步数", "walk counts....", walkBtns);

    _dietCategoriesInfo.add(milk);
    _dietCategoriesInfo.add(nut);
    _dietCategoriesInfo.add(meat);
    _dietCategoriesInfo.add(egg);
    _dietCategoriesInfo.add(vegetable);
    _dietCategoriesInfo.add(fruit);
    _dietCategoriesInfo.add(allGrain);
    _dietCategoriesInfo.add(walk);
  }


}

enum DietCategoriesEnum {
  milk,
  nut,
  meat,
  egg,
  vegetable,
  fruit,
  allGrain,
  walk,
  forDefault,
}
