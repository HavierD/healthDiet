import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:health_diet/add_new_diet_menu_page.dart';
import 'package:health_diet/data/data_one_day.dart';
import 'package:health_diet/notifications.dart';
import 'package:health_diet/suggestion_page.dart';
import 'package:path/path.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());

  Notifications.showScheduledNotification(
    title: "别忘了记录今天的饮食哦！",
    // scheduledTime: DateTime.now().add(Duration(seconds: 5))
    scheduledTime: DateTime(2022, 11, 2, 20, 0, 0),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => DataOneDayModel(),
      child: MaterialApp(
        title: '健康饮食',
        theme: ThemeData(
          primarySwatch: Colors.lightGreen,
        ),
        home: const MyHomePage(title: '戴怀志的健康饮食app'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  @override
  void initState() {
    super.initState();
    Notifications.initialize(flutterLocalNotificationsPlugin);
  }

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

  @override
  Widget build(BuildContext context) {
    return Consumer<DataOneDayModel>(
      builder: buildScaffold,
    );
  }

  Scaffold buildScaffold(BuildContext context, DataOneDayModel dataOneDayModel, _) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: GoogleFonts.maShanZheng(fontSize: 25, fontStyle: FontStyle.italic),
        ),
      ),
      body: Center(
        child: dataOneDayModel.loading
            ? const CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "今日健康饮食状况：",
                    style: GoogleFonts.maShanZheng(fontSize: 30),
                  ),
                  PieChart(
                    dataMap: {"已经完成": dataOneDayModel.completedCount()},
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
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.add_circle_outline),
                        Text("增加新的饮食", style: GoogleFonts.maShanZheng(fontSize: 20)),
                      ],
                    ),
                  ),
                  CupertinoButton(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.bar_chart),
                          Text(
                            "查看统计数据与未来建议",
                            style: GoogleFonts.maShanZheng(fontSize: 20),
                          ),
                        ],
                      ),
                      onPressed: () => {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SuggestionPage()),
                            ),
                          }),
                  const Text(
                    'You have pushed the button this many times:',
                  ),
                  Text(
                    '$_counter',
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  CupertinoButton(
                    child: const Text("test button"),
                    onPressed: () => {

                    },
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
