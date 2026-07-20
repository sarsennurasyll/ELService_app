/// Общие константы сетевого слоя.
///
/// TODO: уточнить после появления контракта Node.js REST API.
abstract final class ApiConstants {
  static const apiVersion = 'v1';
  static const authorizationHeader = 'Authorization';
  static const bearerPrefix = 'Bearer';
  static const contentTypeHeader = 'Content-Type';
  static const jsonContentType = 'application/json';
}
