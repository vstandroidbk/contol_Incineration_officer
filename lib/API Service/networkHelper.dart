import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkHelper {
  static Future<bool> hasInternet() async {
    // Ye sirf device ka network state check karta hai (WiFi/Mobile/None)
    // — koi external ping nahi, koi extra round-trip nahi.
    final result = await Connectivity().checkConnectivity();
    return !result.contains(ConnectivityResult.none);
  }
}
