import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:health_diet/customized_widgets/common_format.dart';
import 'package:provider/provider.dart';

import 'data/data_one_day.dart';

class SubMenu extends StatefulWidget {
  final DietCategoriesEnum categories;

  const SubMenu({Key? key, required this.categories}) : super(key: key);

  @override
  State<SubMenu> createState() => _SubMenuState();
}

class _SubMenuState extends State<SubMenu> {
  @override
  Widget build(BuildContext context) {
    return Consumer<DataOneDayModel>(builder: buildScaffold);
  }

  Scaffold buildScaffold(BuildContext context, DataOneDayModel dataOneDayModel, _) {
    var c = dataOneDayModel.getDietCategory(widget.categories);

    List<Widget> generateMenuButtons() {
      List<Widget> re = [];
      for (var btnInfo in c.buttonValueAndTitles.entries) {
        print('${dataOneDayModel.getDBValueByCategory(widget.categories)} ?= ${btnInfo.key}');
        var w = FractionallySizedBox(
          widthFactor: 0.9,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: CupertinoButton(
              color:
                  dataOneDayModel.getDBValueByCategory(widget.categories) == btnInfo.key
                      ? const Color.fromRGBO(215, 215, 27, 1.0)
                      : const Color.fromRGBO(180, 170, 105, 1.0),
              onPressed: () {
                dataOneDayModel.update(widget.categories, btnInfo.key);
                Navigator.pop(context);
              },
              child: Row(
                children: [
                  Text(btnInfo.value, style: GoogleFonts.maShanZheng(fontSize: 20)),
                  dataOneDayModel.getDBValueByCategory(widget.categories) == btnInfo.key
                      ? const Icon(Icons.check)
                      : const Text(""),
                ],
              ),
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
                    text: c.categoryText.length > 50? c.categoryText.substring(0, 50) :
                    c.categoryText,
                    style: GoogleFonts.notoSans(fontSize: 15, color: Colors.black),
                    children:  <TextSpan>[
                      const TextSpan(text: '......'),
                      TextSpan(
                        text: '点击此处查看详细内容',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        recognizer: TapGestureRecognizer()..onTap = (){
                          // Navigator.of(context).push(AllContentModal());
                          Navigator.of(context).push(AllContentModal(c.categoryText));
                        }
                      ),
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

class AllContentModal extends ModalRoute<void>{

  late String content;

  AllContentModal(String string){
    content = string;
  }


  @override
  // TODO: implement barrierColor
  Color? get barrierColor => const Color.fromRGBO(234, 255, 230, 1.0)  .withOpacity(0.9);

  @override
  // TODO: implement barrierDismissible
  bool get barrierDismissible => true;

  @override
  // TODO: implement barrierLabel
  String? get barrierLabel => "Details";

  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
    return SizedBox(
      child: Center(
            heightFactor: 1,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  content,
                  style: GoogleFonts.maShanZheng(fontSize: 25, color: Colors.black,
                      decoration: TextDecoration.none),
                ),
                CupertinoButton(onPressed: (){
                  Navigator.pop(context);
                }, child: const Icon(Icons.check))
              ],
            ),
          ),
    );
  }

  @override
  // TODO: implement maintainState
  bool get maintainState => false;

  @override
  // TODO: implement opaque
  bool get opaque => false;

  @override
  // TODO: implement transitionDuration
  Duration get transitionDuration => const Duration(milliseconds: 500);

}