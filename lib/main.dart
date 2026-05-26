library menu_book;

import 'dart:convert';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

part 'app/menu_book_app.dart';
part 'models/recipes.dart';
part 'services/recipe_store.dart';
part 'screens/menu_home_screen.dart';
part 'widgets/backgrounds/cinnamoroll_background.dart';
part 'widgets/sheets/themed_recipe_sheet.dart';
part 'widgets/common/empty_collection.dart';
part 'features/dishes/dish_list.dart';
part 'features/cocktails/cocktail_list.dart';
part 'features/calendar/cocktail_calendar_view.dart';
part 'widgets/common/recipe_card.dart';
part 'features/dishes/dish_form_sheet.dart';
part 'features/cocktails/cocktail_form_sheet.dart';
part 'features/calendar/cocktail_memory_form_sheet.dart';
part 'features/cocktails/ingredient_measure_row.dart';
part 'features/dishes/dish_details_sheet.dart';
part 'features/cocktails/cocktail_details_sheet.dart';
part 'widgets/common/recipe_details_scaffold.dart';
part 'widgets/common/form_header.dart';
part 'widgets/common/save_button.dart';
part 'widgets/common/recipe_image.dart';
part 'utils/date_formatters.dart';
part 'utils/form_helpers.dart';

void main() {
  runApp(const MenuBookApp());
}
