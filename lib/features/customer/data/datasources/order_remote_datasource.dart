import '../../../../core/errors/api_exception.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../models/order_dto.dart';

abstract interface class OrderRemoteDataSource {
  Future<List<OrderDto>> getOrders();

  Future<OrderDto> getOrderById(String id);

  Future<OrderDto> createOrder(OrderDto order);
}

final class OrderRemoteDataSourceImpl implements OrderRemoteDataSource {
  const OrderRemoteDataSourceImpl({required ApiClient apiClient})
    : _apiClient = apiClient;

  final ApiClient _apiClient;

  @override
  Future<List<OrderDto>> getOrders() async {
    final response = await _apiClient.get(ApiEndpoints.orders);
    final data = response['data'];

    if (data is! List) {
      throw const ApiException(message: 'Некорректный ответ сервера');
    }

    return data.map(_orderFromJson).toList();
  }

  @override
  Future<OrderDto> getOrderById(String id) async {
    final response = await _apiClient.get('${ApiEndpoints.orders}/$id');
    return _orderFromJson(response['data']);
  }

  @override
  Future<OrderDto> createOrder(OrderDto order) async {
    final response = await _apiClient.post(
      ApiEndpoints.orders,
      body: order.toCreateMap(),
    );
    return _orderFromJson(response['data']);
  }

  OrderDto _orderFromJson(dynamic json) {
    if (json is! Map) {
      throw const ApiException(message: 'Некорректный ответ сервера');
    }

    return OrderDto.fromMap(Map<String, dynamic>.from(json));
  }
}
