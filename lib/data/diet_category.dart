import 'package:flutter/material.dart';
import 'package:health_diet/data/data_one_day.dart';

class DietCategory {
  final DietCategoriesEnum category;
  final String categoryTitle;
  final String categoryText;
  // final String valueInModel;
  final Map<String, String> buttonValueAndTitles;

  DietCategory(this.category, this.categoryTitle, this.categoryText, this.buttonValueAndTitles,);
}

