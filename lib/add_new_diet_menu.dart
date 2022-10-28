import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:health_diet/data/data_one_day.dart';
import 'package:health_diet/sub_menu.dart';
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
        title: Text("选择一个类：", style: GoogleFonts.maShanZheng(fontSize: 20),),
      ),
      body: CommonFormat(
        child: dataOneDayModel.loading
            ? const CircularProgressIndicator()
            : Column(
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
                    title: dataOneDayModel
                        .getDietCategory(DietCategoriesEnum.milk)
                        .categoryTitle,
                    destinationClass: const MilkMenu(categories: DietCategoriesEnum.milk),
                    hasCompleted: dataOneDayModel.dataOfToday!.milk != "null",
                  ),
                  MenuButton(
                    title: dataOneDayModel
                        .getDietCategory(DietCategoriesEnum.nut)
                        .categoryTitle,
                    destinationClass: const MilkMenu(categories: DietCategoriesEnum.nut),
                    hasCompleted: dataOneDayModel.dataOfToday!.nut != "null",
                  ),
                  MenuButton(
                    title: dataOneDayModel
                        .getDietCategory(DietCategoriesEnum.meat)
                        .categoryTitle,
                    destinationClass: const MilkMenu(categories: DietCategoriesEnum.meat),
                    hasCompleted: dataOneDayModel.dataOfToday!.meat != "null",
                  ),
                  MenuButton(
                    title: dataOneDayModel
                        .getDietCategory(DietCategoriesEnum.egg)
                        .categoryTitle,
                    destinationClass: const MilkMenu(categories: DietCategoriesEnum.egg),
                    hasCompleted: dataOneDayModel.dataOfToday!.egg != "null",
                  ),
                  MenuButton(
                    title: dataOneDayModel
                        .getDietCategory(DietCategoriesEnum.vegetable)
                        .categoryTitle,
                    destinationClass:
                        const MilkMenu(categories: DietCategoriesEnum.vegetable),
                    hasCompleted: dataOneDayModel.dataOfToday!.vegetable != "null",
                  ),
                  MenuButton(
                    title: dataOneDayModel
                        .getDietCategory(DietCategoriesEnum.fruit)
                        .categoryTitle,
                    destinationClass:
                        const MilkMenu(categories: DietCategoriesEnum.fruit),
                    hasCompleted: dataOneDayModel.dataOfToday!.fruit != "null",
                  ),
                  MenuButton(
                    title: dataOneDayModel
                        .getDietCategory(DietCategoriesEnum.allGrain)
                        .categoryTitle,
                    destinationClass:
                        const MilkMenu(categories: DietCategoriesEnum.allGrain),
                    hasCompleted: dataOneDayModel.dataOfToday!.allGrain != "null",
                  ),
                  MenuButton(
                    title: dataOneDayModel
                        .getDietCategory(DietCategoriesEnum.walk)
                        .categoryTitle,
                    destinationClass: const MilkMenu(categories: DietCategoriesEnum.walk),
                    hasCompleted: dataOneDayModel.dataOfToday!.walk != "null",
                  ),
                ],
              ),
      ),
    );
  }
}
