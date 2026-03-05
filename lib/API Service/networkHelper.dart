
import 'package:internet_connection_checker/internet_connection_checker.dart';

class NetworkHelper {
  static Future<bool> hasInternet() async {
    return await InternetConnectionChecker().hasConnection;
  }
}
