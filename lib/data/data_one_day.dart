import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:health_diet/toast_exception_alert.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'diet_categories_enum.dart';
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

  set _setMilk(String string) {
    milk = string;
  }

  DataOneDay(
      {this.milk,
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
  final List<DataOneDay> _allData = [];
  bool loading = true;
  Database? db;

  final List<DietCategory> _dietCategoriesInfo = [];

  DataOneDayModel() {
    _initDietCategoriesInfo();
    _fetchAllData();
  }

  Future _fetchAllData() async {
    db = await initiateDatabase();
    var querySnapshot = await db!.query('data');
    for (var e in querySnapshot) {
      _allData.add(DataOneDay(
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
    _allData.sort((a, b)=> a.date.compareTo(b.date) );
    getTodayData();
    loading = false;
    refreshUI();
  }

  void dbInitChecking() async {
    while (db == null) {
      await Future.delayed(const Duration(seconds: 1));
    }
  }

  Future<Map<String, Object?>> getTodaySnapshot() async {
    db = await initiateDatabase();
    var all = await db!.query('data');
    for (var element in all) {
      if (element['date'] == _getTodayDate()) {
        return element;
      }
    }
    ToastExceptionAlert.alert("获取数据错误！！data_one_day.getTodaySnapshot()");
    refreshUI();
    return <String, Object?>{};
  }

  Future<Database> initiateDatabase() async {
    _allData.clear();
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
    for (var element in _allData) {
      if (element.date == _getTodayDate()) {
        dataOfToday = element;
        return;
      }
    }
    if (dataOfToday == null) {
      dataOfToday = DataOneDay(date: _getTodayDate());
      await db!.insert("data", dataOfToday!.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
      update();
    }
  }

  String _getTodayDate() {
    DateTime dateTime = DateTime.now();
    var month = _monthDateFormat(dateTime.month);
    var day = _monthDateFormat(dateTime.day);
    return "${dateTime.year}/$month/$day";
  }

  String _monthDateFormat(int int) {
    if (int < 10) {
      return "0$int";
    }
    return "$int";
  }

  double completedCount() {
    if (dataOfToday == null) {
      ToastExceptionAlert.alert("数据初始化错误！ DataOneDayModel"
          ".completedCount()");
      return 0.0;
    }
    var all = dataOfToday!.toMap();
    double count = -1.0;
    all.forEach((key, value) {
      if (value != null && value != "null") {
        count++;
      }
    });
    return count;
  }



  String getChineseWordsByCategory(DietCategoriesEnum category){
    switch (category) {
      case DietCategoriesEnum.milk:
        return "奶类";
      case DietCategoriesEnum.nut:
        return "坚果";
      case DietCategoriesEnum.meat:
        return "肉";
      case DietCategoriesEnum.egg:
        return "蛋";
      case DietCategoriesEnum.vegetable:
        return "菜";
      case DietCategoriesEnum.fruit:
        return "水果";
      case DietCategoriesEnum.allgrain:
        return "全谷";
      case DietCategoriesEnum.walk:
        return "走路";
      default:
        ToastExceptionAlert.alert("获取中文名错误！DataOneDayModel.getChineseWordsByCategory()");
        return "";
    }
  }

  List<DataOneDay> getData(int days) {
    if(days == 0){
      return _allData;
    }
    return _allData.take(days).toList();
  }

  // void add (DataOneDay dataOneDay){
  //   data.add(dataOneDay);
  //   update();
  // }

  void refreshUI() {
    notifyListeners();
  }

  void allNullForDebugging() async {
    var nullA = DataOneDay(date: _getTodayDate());
    await db!.insert("data", nullA.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
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
      case DietCategoriesEnum.allgrain:
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
    await _fetchAllData();
    refreshUI();
  }


  String completeness(DietCategoriesEnum category){
    num total = 0;
    for(var one in getData(10)){
      var second = one.toMap();

      print("what is the value? ${second[category.toString().substring(19)]}");
      if(second[category.toString().substring(19)] != "null" && second[category
          .toString().substring(19)] != null){
        total = total + 1;
      }
    }
    print("the total? $total");
    double arg = total / getData(10).length;
    double percentage2 = arg * 100;
    int percentage = percentage2.round();
    return "$percentage";
  }


  String getDBValueByCategory(DietCategoriesEnum category) {
    switch (category) {
      case DietCategoriesEnum.milk:
        return dataOfToday!.milk.toString();
      case DietCategoriesEnum.nut:
        return dataOfToday!.nut.toString();
      case DietCategoriesEnum.egg:
        return dataOfToday!.egg.toString();
      case DietCategoriesEnum.vegetable:
        return dataOfToday!.vegetable.toString();
      case DietCategoriesEnum.fruit:
        return dataOfToday!.fruit.toString();
      case DietCategoriesEnum.allgrain:
        return dataOfToday!.allGrain.toString();
      case DietCategoriesEnum.walk:
        return dataOfToday!.walk.toString();
      case DietCategoriesEnum.meat:
        return dataOfToday!.meat.toString();
      default:
        return "";
    }
  }

  void _initDietCategoriesInfo() {
    var milkBtns = {
      "milk": "1 ~ 2杯牛奶",
      "yogurt": "1 ~ 2杯酸奶",
      "others": "其他相似重量奶制品",
      "toomuch": "摄入过多奶制品",
      "less": "摄入很少奶制品",
      "null": "完全没摄入奶制品"
    };
    var nutBtns = {
      "soybeans": "豆腐等大豆制品",
      "seeds": "花生 / 葵花子等",
      "others": "其他常见坚果",
      "toomuch": "吃了太多坚果",
      "less": "很少的豆制品/坚果",
      "null": "没吃豆制品/坚果",
    };
    var meatBtns = {
      "seafood": "水产品",
      "redmeat": "猪牛羊肉",
      "poultry": "鸡鸭鹅肉",
      "toomuch": "吃了过多的肉",
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
      "vegetable": "蔬菜半斤~1斤",
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
      "less": "很少的粗粮/杂豆",
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
      DietCategoriesEnum.milk,
      "奶类",
      "奶类包括：纯牛奶；无乳糖牛奶；无糖或少糖酸奶；奶酪；奶片等。名字叫”牛奶饮品“，“奶风味饮料”等为勾兑产品，含过多"
          "的糖等不健康"
          "成分。不仅不算此类，还要少吃。如果摄入过多奶制品（比如3盒以上酸奶），请选择“摄入过多奶制品”选项。",
      milkBtns,
    );
    var nut = DietCategory(
      DietCategoriesEnum.nut,
      "豆制品和坚果",
      "豆制品和坚果类包括：大豆本身和豆腐，腐竹等豆制品；坚果不仅包括常见坚果（榛子，碧根果等），还包括瓜子，花生。坚果一天不能超过一小把，否则选择：”吃了太多坚果“。",
      nutBtns,
    );
    var meat = DietCategory(
      DietCategoriesEnum.meat,
      "肉类",
      "meat is a kind of ...",
      meatBtns,
    );
    var egg = DietCategory(DietCategoriesEnum.egg, "蛋", "Egg is dsfsd... ", eggBtns);
    var vegetable =
        DietCategory(DietCategoriesEnum.vegetable, "茎叶类蔬菜", "vegetable is...", vegBtns);
    var fruit =
        DietCategory(DietCategoriesEnum.fruit, "水果", "Fruit cannot have... ", fruitBtns);
    var allGrain = DietCategory(
        DietCategoriesEnum.allgrain, "全谷物/杂豆", "all grains is...", allGrainBtns);
    var walk = DietCategory(DietCategoriesEnum.walk, "步数", "walk counts....", walkBtns);

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


