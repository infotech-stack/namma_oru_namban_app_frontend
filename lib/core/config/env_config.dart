import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvConfig {
  static String get baseUrl => dotenv.env['BASE_URL'] ?? "";

  static int get connectTimeout =>
      int.parse(dotenv.env['CONNECT_TIMEOUT'] ?? "30000");

  static int get receiveTimeout =>
      int.parse(dotenv.env['RECEIVE_TIMEOUT'] ?? "30000");
}
