import 'package:flutter/foundation.dart';

enum DietCategoriesEnum {
  milk,
  nut,
  meat,
  egg,
  vegetable,
  fruit,
  allgrain,
  walk,
  // forDefault,

}

extension DietCategoriesEnumExtension on DietCategoriesEnum{
  String get test =>describeEnum(this);
}