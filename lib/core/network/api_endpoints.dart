/// Точки входа Node.js REST API.
///
/// TODO: синхронизировать пути с Backend-контрактом.
abstract final class ApiEndpoints {
  static const auth = '/auth';
  static const users = '/users';
  static const orders = '/orders';
  static const categories = '/categories';
  static const messages = '/messages';
  static const reviews = '/reviews';
  static const technicians = '/technicians';
  static const admin = '/admin';

  static const authLogin = '$auth/login';
  static const authRegister = '$auth/register';
  static const authRefresh = '$auth/refresh';
  static const authLogout = '$auth/logout';
}
