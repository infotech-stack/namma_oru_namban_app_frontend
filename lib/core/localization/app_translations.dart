import 'package:get/get.dart';
import 'package:userapp/core/localization/tamil.dart';
import 'english.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {'en': en, 'ta': ta}; //'hi': hi
}
