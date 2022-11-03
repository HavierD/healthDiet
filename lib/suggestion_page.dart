import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:health_diet/customized_widgets/common_format.dart';
import 'package:health_diet/data/data_one_day.dart';
import 'package:health_diet/data_table_page.dart';
import 'package:provider/provider.dart';

import 'data/diet_categories_enum.dart';
import 'global_customized_words.dart';

class SuggestionPage extends StatefulWidget {
  const SuggestionPage({Key? key}) : super(key: key);

  @override
  State<SuggestionPage> createState() => _SuggestionPageState();
}

class _SuggestionPageState extends State<SuggestionPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<DataOneDayModel>(builder: buildScaffold);
  }

  String goodCategories = "";
  String canBeBetterCategories = "";
  String badCategories = "";
  String walkContent = "";

  Scaffold buildScaffold(BuildContext context, DataOneDayModel model, _) {
    return Scaffold(
      appBar: AppBar(
        title: Text("总结和建议"),
      ),
      body: CommonFormat(
        child: Scrollbar(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: <Widget>[
                Text(
                  "过去10天饮食情况总结:",
                  style: GoogleFonts.maShanZheng(fontSize: 18),
                ),
                GridView.count(
                  childAspectRatio: (2),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  primary: false,
                  padding: const EdgeInsets.all(5),
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 5,
                  crossAxisCount: 3,
                  children: _generateTiles(model),
                ),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: 260,
                  height: 50,
                  child: CupertinoButton(
                      color:Colors.green,
                      child: Row(
                        children: [
                          Icon(Icons.table_chart_outlined),
                          Text("查看所有数据", style: GoogleFonts.maShanZheng(fontSize: 18),),
                        ],
                      ),
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (
                                context) => const DataTablePage()));
                      }),
                ),
                SizedBox(
                  height: 10,
                ),
                goodCategories == "" ? Text("") : Text(
                    "$goodCategories 很均衡，可以按照这个习惯保持下去。"),
                SizedBox(
                  height: 10,
                ),
                canBeBetterCategories == ""
                    ? Text("")
                    : Text(
                  "$canBeBetterCategories 不够，应该尽量在每天都摄入 "
                      "$canBeBetterCategories。",
                  style: GoogleFonts.maShanZheng(
                    fontSize: 20,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "$badCategories 摄入远远不够！以后要有意识地增加 $badCategories的摄入，否则将会严重影响健康！",
                  style: GoogleFonts.maShanZheng(fontSize: 20),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "过去10天的运动量$walkContent.",
                  style: GoogleFonts.maShanZheng(fontSize: 20),
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _generateTiles(DataOneDayModel model) {
    List<Container> re = [];
    for (var category in DietCategoriesEnum.values) {
      var title = model.getChineseWordsByCategory(category);
      var c = Container(
        padding: const EdgeInsets.all(5),
        child: Column(
          children: <Widget>[
            Text("$title:"),
            Text("完成度： ${model.completeness(category)}%")
          ],
        ),
      );
      if (category != DietCategoriesEnum.walk) {
        if (int.parse(model.completeness(category)) > 80) {
          goodCategories =
              goodCategories + "," + model.getChineseWordsByCategory(category);
        } else if (int.parse(model.completeness(category)) > 60) {
          canBeBetterCategories =
              canBeBetterCategories + "," + model.getChineseWordsByCategory(category);
        } else {
          badCategories = badCategories + "," + model.getChineseWordsByCategory(category);
        }
      }
      if (category == DietCategoriesEnum.walk) {
        if (int.parse(model.completeness(category)) > 80) {
          walkContent = "很好！${Global.title}继续保持！足够的运动量才能精力十足，身体倍棒，越活越年轻！";
        } else {
          walkContent = "不足！${Global.title}得增加运动量！否则将更容易疲劳，长此以往影响健康！";
        }
      }
      re.add(c);
    }
    return re;
  }
}
