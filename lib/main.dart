import 'dart:js_util';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:health_diet/add_new_diet_menu.dart';
import 'package:health_diet/data/data_one_day.dart';
import 'package:path/path.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
  final database = openDatabase(
    join(await getDatabasesPath(), 'health_diet.db'),
    onCreate: (db, version) {
      return db.execute(
        'CREATE TABLE data (id INTEGER PRIMARY KEY, date TEXT,milk TEXT, nut TEXT, egg TEXT, vegetable TEXT, fruit TEXT, allgrain TEXT , walk TEXT)',
      );
    },
    version: 1,
  );



  Future<void> insertData(DataOneDay dataOneDay) async {
    final db = await database;
    await db.insert('data', dataOneDay.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // var fido = DataOneDay(date: "1010");

  // insertData(fido);
  Future<List<DataOneDay>> datata() async {
    // Get a reference to the database.
    final db = await database;

    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps = await db.query('data');

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return DataOneDay(
        // id: maps[i]['id'],
        date: maps[i]['date'],
      );
    });
  }

  var aaa = await datata();
  var bbb = aaa.length;
  print("here");
  print(bbb);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => DataOneDayModel(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.lightGreen,
        ),
        home: const MyHomePage(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });

  }

  Map<String, double> dataMap = {
    "已经完成": 5,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "今日健康饮食状况：",
              style: GoogleFonts.maShanZheng(fontSize: 30),
            ),
            PieChart(
              dataMap: dataMap,
              baseChartColor: Colors.grey,
              totalValue: 7,
              chartRadius: MediaQuery.of(context).size.width / 2,
              legendOptions:
                  const LegendOptions(legendPosition: LegendPosition.bottom),
            ),
            CupertinoButton.filled(
              onPressed: () => {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AddingNewDietMenu()))
              },
              child: const Text(
                "增加新的饮食",
                style: TextStyle(fontSize: 20),
              ),
            ),
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
            CupertinoButton(
              child: const Text("test button"),
              onPressed: () => {},
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
