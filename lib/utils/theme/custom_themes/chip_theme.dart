import 'package:flutter/material.dart';
import 'package:t_store_admin_panel/utils/constants/colors.dart';

class TChipTheme {
  TChipTheme._();
  //light theme
  static ChipThemeData lightChipTheme = ChipThemeData(
    disabledColor: Color.fromRGBO(158, 158, 158, 0.4),
    labelStyle: const TextStyle(color: TColors.black),
    selectedColor: TColors.primary,
    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12),
    checkmarkColor: TColors.white,
  );

  //dark theme
  static ChipThemeData darkChipTheme = ChipThemeData(
    disabledColor: Color.fromRGBO(158, 158, 158, 0.4),
    labelStyle: const TextStyle(color: TColors.white),
    selectedColor: TColors.primary,
    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12),
    checkmarkColor: TColors.white,
  );
}
