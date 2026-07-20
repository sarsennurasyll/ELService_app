import '../../../../core/utils/result.dart';
import '../../../customer/domain/models/order.dart';
import '../models/technician.dart';

/// Контракт репозитория мастера.
///
/// TODO: подключить Repository к RemoteDataSource.
abstract interface class TechnicianRepository {
  Future<Result<Technician?>> getProfile();

  Future<Result<List<Order>>> getIncomingOrders();

  Future<Result<List<Order>>> getAcceptedOrders();

  Future<Result<Order>> acceptOrder(String orderId);

  Future<Result<double>> getEarnings();
}
