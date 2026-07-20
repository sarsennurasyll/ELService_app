import '../../../../core/utils/result.dart';
import '../../../customer/domain/models/customer.dart';
import '../../../customer/domain/models/order.dart';
import '../../../technician/domain/models/technician.dart';

/// Контракт репозитория администратора.
///
/// TODO: подключить Repository к RemoteDataSource.
abstract interface class AdminRepository {
  Future<Result<List<Order>>> getOrders();

  Future<Result<List<Customer>>> getCustomers();

  Future<Result<List<Technician>>> getTechnicians();

  Future<Result<Map<String, num>>> getAnalytics();
}
