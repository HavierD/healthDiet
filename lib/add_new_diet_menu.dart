import 'package:flutter/material.dart';
import 'package:health_diet/data/data_one_day.dart';
import 'package:health_diet/sub_menu/milk_menu.dart';
import 'package:provider/provider.dart';

import 'customized_widgets/common_format.dart';
import 'customized_widgets/menu_button.dart';

class AddingNewDietMenu extends StatelessWidget {
  const AddingNewDietMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<DataOneDayModel>(
      builder: buildScaffold,
    );
  }

  Scaffold buildScaffold(BuildContext context, DataOneDayModel dataOneDayModel, _) {
    return Scaffold(
    appBar: AppBar(
      title: const Text("选择一个类："),
    ),
    body: CommonFormat(
      child: Column(
        children: <Widget>[
          RichText(
            text: const TextSpan(
                text: "hello ",
                style: TextStyle(fontSize: 25, color: Colors.black),
                children: <TextSpan>[
                  TextSpan(
                      text: 'bold',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: ' world!'),
                ]),
          ),
          MenuButton(
            title: "奶类",
            destinationClass: const MilkMenu(),
            hasCompleted: dataOneDayModel.dataOfToday.milk != null,
          )
        ],
      ),
    ),
  );
  }
}
