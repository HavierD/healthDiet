import 'package:flutter/material.dart';
import 'package:health_diet/customized_widgets/common_format.dart';
import 'package:provider/provider.dart';

import 'data/data_one_day.dart';

class DataTablePage extends StatefulWidget {
  const DataTablePage({Key? key}) : super(key: key);

  @override
  State<DataTablePage> createState() => _DataTablePageState();
}

class _DataTablePageState extends State<DataTablePage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<DataOneDayModel>(builder: buildScaffold);
  }

  Scaffold buildScaffold(BuildContext context, DataOneDayModel model, _) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("饮食数据"),
      ),
      body: CommonFormat(
        child: Column(
          children: <Widget>[
            const Text("所有饮食数据"),
            DataTable(
              columnSpacing: 10,
              columns: const <DataColumn>[
                DataColumn(
                  label: Expanded(
                    child: Text(
                      '日期',
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ),
                ),
                DataColumn(
                  label: Expanded(
                    child: Text(
                      '奶类',
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ),
                ),
                DataColumn(
                  label: Expanded(
                    child: Text(
                      '坚果',
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ),
                ),
                DataColumn(
                  label: Expanded(
                    child: Text(
                      '肉',
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ),
                ),
                DataColumn(
                  label: Expanded(
                    child: Text(
                      '蛋',
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ),
                ),
                DataColumn(
                  label: Expanded(
                    child: Text(
                      '菜',
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ),
                ),
                DataColumn(
                  label: Expanded(
                    child: Text(
                      '水果',
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ),
                ),
                DataColumn(
                  label: Expanded(
                    child: Text(
                      '全谷',
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ),
                ),
                DataColumn(
                  label: Expanded(
                    child: Text(
                      '走路',
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ),
                ),
              ],
              rows: _generateRows(model),
            )
          ],
        ),
      ),
    );
  }

  Widget generateCell(String? string) {
    if (string == "null" || string == null) {
      return Icon(Icons.close);
    }
    return Icon(Icons.check);
  }

  Widget generateDateCell(String string) {
    return Text(string.substring(2).replaceAll("/", ""));
  }

  List<DataRow> _generateRows(DataOneDayModel model) {
    List<DataRow> re = [];
    for (var data in model.getData(0)) {
      var w = DataRow(cells: <DataCell>[
        DataCell(generateDateCell(data.date)),
        DataCell(generateCell(data.milk)),
        DataCell(generateCell(data.nut)),
        DataCell(generateCell(data.meat)),
        DataCell(generateCell(data.egg)),
        DataCell(generateCell(data.vegetable)),
        DataCell(generateCell(data.fruit)),
        DataCell(generateCell(data.allGrain)),
        DataCell(generateCell(data.walk)),
      ]);
      re.add(w);
    }
    return re;
  }
}
