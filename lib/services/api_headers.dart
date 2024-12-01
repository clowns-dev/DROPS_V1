import 'package:ps3_drops_v1/tools/session_manager.dart';

class ApiHeaders {
  ApiHeaders._privateBuild();

  static final ApiHeaders _instance = ApiHeaders._privateBuild();
  static ApiHeaders get instance => _instance;

  Map<String, String> buildHeaders() {
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${sessionManager.token}'
    };
  }
}