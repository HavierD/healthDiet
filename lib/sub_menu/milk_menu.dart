import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:health_diet/customized_widgets/common_format.dart';
import 'package:provider/provider.dart';

import '../data/data_one_day.dart';

class MilkMenu extends StatelessWidget {
  const MilkMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<DataOneDayModel>(builder: buildScaffold);
  }

  Scaffold buildScaffold(BuildContext context, DataOneDayModel dataOneDayModel, _) {
    return Scaffold(
    appBar: AppBar(
      title: const Text("奶类"),
    ),
    body: CommonFormat(
      child: Column(
        children: <Widget>[
          RichText(
            text: TextSpan(
              text: 'sdfsf',
              style: DefaultTextStyle.of(context).style,
              children: const <TextSpan>[
                TextSpan(
                  text: 'bold',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(text: ' world!'),
              ],
            ),
          ),
          CupertinoButton.filled(
            child: const Text("1 ~ 2 杯牛奶"),
            onPressed: () => {
              dataOneDayModel.dataOfToday.milk = "milk",
              dataOneDayModel.refreshUI(),
            },
          ),
        ],
      ),
    ),
  );
  }
}
