import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:health_diet/customized_widgets/common_format.dart';
import 'package:provider/provider.dart';

import 'data/data_one_day.dart';

class MilkMenu extends StatefulWidget {
  final DietCategoriesEnum categories;

  const MilkMenu({Key? key, required this.categories}) : super(key: key);

  @override
  State<MilkMenu> createState() => _MilkMenuState();
}

class _MilkMenuState extends State<MilkMenu> {
  @override
  Widget build(BuildContext context) {
    return Consumer<DataOneDayModel>(builder: buildScaffold);
  }

  Scaffold buildScaffold(
      BuildContext context, DataOneDayModel dataOneDayModel, _) {
    var c = dataOneDayModel.getDietCategory(widget.categories);

    List<Widget> generateMenuButtons() {
      List<Widget> re = [];
      for (var btnInfo in c.buttonValueAndTitles.entries) {
        var w = FractionallySizedBox(
          widthFactor: 0.9,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: CupertinoButton(
              color: dataOneDayModel.getDBValueByCategory(widget.categories) == btnInfo.key
                  ? const Color.fromRGBO(51, 204, 51, 1)
                  : const Color.fromRGBO(153, 255, 153, 1),
              onPressed: () {
                dataOneDayModel.update(widget.categories, btnInfo.key);
                Navigator.pop(context);
              },
              child: Text(btnInfo.value, style: GoogleFonts.maShanZheng(fontSize: 20)),
            ),
          ),
        );
        re.add(w);
      }
      return re;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(c.categoryTitle),
      ),
      body: CommonFormat(
        child: Column(
          children: <Column>[
            Column(
              children: <Widget>[
                RichText(
                  text: TextSpan(
                    text: c.categoryText,
                    style: const TextStyle(fontSize: 25, color: Colors.black),
                    children: const <TextSpan>[
                      TextSpan(
                        text: 'qqqqqqqqqqqqqqqqqqq',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: ''),
                    ],
                  ),
                ),
              ],
            ),
            Column(
              children: generateMenuButtons(),
            ),
          ],
        ),
      ),
    );
  }
}
