import '../../../customer/data/models/order_dto.dart';
import '../models/technician_dto.dart';

/// Удалённый источник данных мастера.
///
/// TODO: подключить RemoteDataSource к Node.js REST API.
abstract interface class TechnicianRemoteDataSource {
  Future<TechnicianDto?> getProfile();

  Future<List<OrderDto>> getIncomingOrders();

  Future<List<OrderDto>> getAcceptedOrders();

  Future<OrderDto> acceptOrder(String orderId);

  Future<double> getEarnings();
}

final class TechnicianRemoteDataSourceImpl
    implements TechnicianRemoteDataSource {
  const TechnicianRemoteDataSourceImpl();

  @override
  Future<TechnicianDto?> getProfile() {
    throw UnimplementedError('TODO: RemoteDataSource.getProfile');
  }

  @override
  Future<List<OrderDto>> getIncomingOrders() {
    throw UnimplementedError('TODO: RemoteDataSource.getIncomingOrders');
  }

  @override
  Future<List<OrderDto>> getAcceptedOrders() {
    throw UnimplementedError('TODO: RemoteDataSource.getAcceptedOrders');
  }

  @override
  Future<OrderDto> acceptOrder(String orderId) {
    throw UnimplementedError('TODO: RemoteDataSource.acceptOrder');
  }

  @override
  Future<double> getEarnings() {
    throw UnimplementedError('TODO: RemoteDataSource.getEarnings');
  }
}
