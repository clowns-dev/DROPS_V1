class BaseUrlService {

  static final BaseUrlService _instance = BaseUrlService._internal();

  BaseUrlService._internal();

  factory BaseUrlService() {
    return _instance;
  }

  static const String baseUrl = 'http://127.0.0.1:5000/api/v1';
}
