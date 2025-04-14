import 'package:easy_localization/easy_localization.dart';

// Translates the category string to the appropriate language.
String translateCategory(String category) {
  switch (category.toLowerCase()) {
    case 'safe':
      return 'Safe'.tr();
    case 'suspicious':
      return 'Suspicious'.tr();
    case 'dangerous':
      return 'Dangerous'.tr();
    default:
      return category;
  }
}
