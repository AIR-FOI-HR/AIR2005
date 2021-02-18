import 'package:theme_mode_handler/theme_mode_manager_interface.dart';

class MyManager implements IThemeModeManager {
  @override
  Future<String> loadThemeMode() async {}

  @override
  Future<bool> saveThemeMode(String value) async {}
}