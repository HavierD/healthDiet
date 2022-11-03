import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:health_diet/data/data_one_day.dart';
import 'package:health_diet/sub_menu_page.dart';
import 'package:provider/provider.dart';

import 'customized_widgets/common_format.dart';
import 'customized_widgets/menu_button.dart';
import 'data/diet_categories_enum.dart';
import 'global_customized_words.dart';

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
        title: Text("选择一个类：", style: GoogleFonts.maShanZheng(fontSize: 20),),
      ),
      body: CommonFormat(
        child: dataOneDayModel.loading
            ? const CircularProgressIndicator()
            : Column(
                children: <Widget>[
                  RichText(
                    text: TextSpan(
                        text: "${Global.title}，选择一个你今天吃过的大类。每个大类里还有几个小类。",
                        style: TextStyle(fontSize: 20, color: Colors.black),
                        children: <TextSpan>[
                          TextSpan(
                              text: '',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(text: ' '),
                        ]),
                  ),
                  MenuButton(
                    title: dataOneDayModel
                        .getDietCategory(DietCategoriesEnum.milk)
                        .categoryTitle,
                    destinationClass: const SubMenu(categories: DietCategoriesEnum.milk),
                    hasCompleted: dataOneDayModel.dataOfToday!.milk != "null",
                  ),
                  MenuButton(
                    title: dataOneDayModel
                        .getDietCategory(DietCategoriesEnum.nut)
                        .categoryTitle,
                    destinationClass: const SubMenu(categories: DietCategoriesEnum.nut),
                    hasCompleted: dataOneDayModel.dataOfToday!.nut != "null",
                  ),
                  MenuButton(
                    title: dataOneDayModel
                        .getDietCategory(DietCategoriesEnum.meat)
                        .categoryTitle,
                    destinationClass: const SubMenu(categories: DietCategoriesEnum.meat),
                    hasCompleted: dataOneDayModel.dataOfToday!.meat != "null",
                  ),
                  MenuButton(
                    title: dataOneDayModel
                        .getDietCategory(DietCategoriesEnum.egg)
                        .categoryTitle,
                    destinationClass: const SubMenu(categories: DietCategoriesEnum.egg),
                    hasCompleted: dataOneDayModel.dataOfToday!.egg != "null",
                  ),
                  MenuButton(
                    title: dataOneDayModel
                        .getDietCategory(DietCategoriesEnum.vegetable)
                        .categoryTitle,
                    destinationClass:
                        const SubMenu(categories: DietCategoriesEnum.vegetable),
                    hasCompleted: dataOneDayModel.dataOfToday!.vegetable != "null",
                  ),
                  MenuButton(
                    title: dataOneDayModel
                        .getDietCategory(DietCategoriesEnum.fruit)
                        .categoryTitle,
                    destinationClass:
                        const SubMenu(categories: DietCategoriesEnum.fruit),
                    hasCompleted: dataOneDayModel.dataOfToday!.fruit != "null",
                  ),
                  MenuButton(
                    title: dataOneDayModel
                        .getDietCategory(DietCategoriesEnum.allgrain)
                        .categoryTitle,
                    destinationClass:
                        const SubMenu(categories: DietCategoriesEnum.allgrain),
                    hasCompleted: dataOneDayModel.dataOfToday!.allGrain != "null",
                  ),
                  MenuButton(
                    title: dataOneDayModel
                        .getDietCategory(DietCategoriesEnum.walk)
                        .categoryTitle,
                    destinationClass: const SubMenu(categories: DietCategoriesEnum.walk),
                    hasCompleted: dataOneDayModel.dataOfToday!.walk != "null",
                  ),
                ],
              ),
      ),
    );
  }
}
