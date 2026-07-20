import '../models/category_dto.dart';
import '../models/customer_dto.dart';
import '../models/message_dto.dart';
import '../models/order_dto.dart';
import '../models/review_dto.dart';

/// Удалённый источник данных клиента.
///
/// TODO: подключить RemoteDataSource к Node.js REST API.
abstract interface class CustomerRemoteDataSource {
  Future<CustomerDto?> getProfile();

  Future<List<OrderDto>> getOrders();

  Future<OrderDto> getOrderById(String id);

  Future<OrderDto> createOrder(OrderDto order);

  Future<List<CategoryDto>> getCategories();

  Future<List<MessageDto>> getMessages(String orderId);

  Future<ReviewDto> createReview(ReviewDto review);
}

final class CustomerRemoteDataSourceImpl implements CustomerRemoteDataSource {
  const CustomerRemoteDataSourceImpl();

  @override
  Future<CustomerDto?> getProfile() {
    throw UnimplementedError('TODO: RemoteDataSource.getProfile');
  }

  @override
  Future<List<OrderDto>> getOrders() {
    throw UnimplementedError('TODO: RemoteDataSource.getOrders');
  }

  @override
  Future<OrderDto> getOrderById(String id) {
    throw UnimplementedError('TODO: RemoteDataSource.getOrderById');
  }

  @override
  Future<OrderDto> createOrder(OrderDto order) {
    throw UnimplementedError('TODO: RemoteDataSource.createOrder');
  }

  @override
  Future<List<CategoryDto>> getCategories() {
    throw UnimplementedError('TODO: RemoteDataSource.getCategories');
  }

  @override
  Future<List<MessageDto>> getMessages(String orderId) {
    throw UnimplementedError('TODO: RemoteDataSource.getMessages');
  }

  @override
  Future<ReviewDto> createReview(ReviewDto review) {
    throw UnimplementedError('TODO: RemoteDataSource.createReview');
  }
}
