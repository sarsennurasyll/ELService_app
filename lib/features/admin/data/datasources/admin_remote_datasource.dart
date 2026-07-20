import '../../../customer/data/models/customer_dto.dart';
import '../../../customer/data/models/order_dto.dart';
import '../../../technician/data/models/technician_dto.dart';

/// Удалённый источник данных администратора.
///
/// TODO: подключить RemoteDataSource к Node.js REST API.
abstract interface class AdminRemoteDataSource {
  Future<List<OrderDto>> getOrders();

  Future<List<CustomerDto>> getCustomers();

  Future<List<TechnicianDto>> getTechnicians();

  Future<Map<String, num>> getAnalytics();
}

final class AdminRemoteDataSourceImpl implements AdminRemoteDataSource {
  const AdminRemoteDataSourceImpl();

  @override
  Future<List<OrderDto>> getOrders() {
    throw UnimplementedError('TODO: RemoteDataSource.getOrders');
  }

  @override
  Future<List<CustomerDto>> getCustomers() {
    throw UnimplementedError('TODO: RemoteDataSource.getCustomers');
  }

  @override
  Future<List<TechnicianDto>> getTechnicians() {
    throw UnimplementedError('TODO: RemoteDataSource.getTechnicians');
  }

  @override
  Future<Map<String, num>> getAnalytics() {
    throw UnimplementedError('TODO: RemoteDataSource.getAnalytics');
  }
}
