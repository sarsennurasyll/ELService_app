/// Точки входа Node.js REST API.
///
/// TODO: синхронизировать пути с Backend-контрактом.
abstract final class ApiEndpoints {
  static const authLogin = '/auth/login';
  static const authRegister = '/auth/register';
  static const authRefresh = '/auth/refresh';
  static const authLogout = '/auth/logout';

  static const users = '/users';
  static const customers = '/customers';
  static const technicians = '/technicians';

  static const orders = '/orders';
  static const categories = '/categories';
  static const messages = '/messages';
  static const reviews = '/reviews';

  static String orderById(String id) => '/orders/$id';
  static String userById(String id) => '/users/$id';
  static String technicianById(String id) => '/technicians/$id';
  static String customerById(String id) => '/customers/$id';
}
