import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:health_diet/customized_widgets/common_format.dart';
import 'package:provider/provider.dart';

import 'data/data_one_day.dart';

class StatPage extends StatefulWidget {
  const StatPage({Key? key}) : super(key: key);

  @override
  State<StatPage> createState() => _StatPageState();
}

class _StatPageState extends State<StatPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<DataOneDayModel>(builder: buildScaffold);
  }



  Scaffold buildScaffold(BuildContext context, DataOneDayModel model, _) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("统计与建议"),
      ),
      body: CommonFormat(
        child: Column(
          children: <Widget>[
            const Text("过去7天的饮食统计"),
            ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: model.get7DaysData().length>6? 7 : model.get7DaysData().length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  child: Row(
                    children: generateColumns(model)


                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }

  List<Widget> generateColumns(DataOneDayModel model) {
    List<Widget> re = [];
    // for (var data in ){
    //
    //   )
    // }
    return [];
  }
}
