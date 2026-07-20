import '../../../../core/errors/failure.dart';
import '../../../../core/utils/result.dart';
import '../../../customer/data/mappers/customer_mapper.dart';
import '../../../customer/data/mappers/order_mapper.dart';
import '../../../customer/domain/models/customer.dart';
import '../../../customer/domain/models/order.dart';
import '../../../technician/data/mappers/technician_mapper.dart';
import '../../../technician/domain/models/technician.dart';
import '../../domain/repositories/admin_repository.dart';
import '../datasources/admin_remote_datasource.dart';

/// Реализация [AdminRepository].
///
/// TODO: подключить Repository к RemoteDataSource.
final class AdminRepositoryImpl implements AdminRepository {
  const AdminRepositoryImpl({
    required AdminRemoteDataSource remoteDataSource,
    required OrderMapper orderMapper,
    required CustomerMapper customerMapper,
    required TechnicianMapper technicianMapper,
  }) : _remoteDataSource = remoteDataSource,
       _orderMapper = orderMapper,
       _customerMapper = customerMapper,
       _technicianMapper = technicianMapper;

  final AdminRemoteDataSource _remoteDataSource;
  final OrderMapper _orderMapper;
  final CustomerMapper _customerMapper;
  final TechnicianMapper _technicianMapper;

  @override
  Future<Result<List<Order>>> getOrders() async {
    try {
      final dtos = await _remoteDataSource.getOrders();
      return Success(dtos.map(_orderMapper.fromDto).toList());
    } on Exception catch (error) {
      return ErrorResult(Failure(message: error.toString()));
    }
  }

  @override
  Future<Result<List<Customer>>> getCustomers() async {
    try {
      final dtos = await _remoteDataSource.getCustomers();
      return Success(dtos.map(_customerMapper.fromDto).toList());
    } on Exception catch (error) {
      return ErrorResult(Failure(message: error.toString()));
    }
  }

  @override
  Future<Result<List<Technician>>> getTechnicians() async {
    try {
      final dtos = await _remoteDataSource.getTechnicians();
      return Success(dtos.map(_technicianMapper.fromDto).toList());
    } on Exception catch (error) {
      return ErrorResult(Failure(message: error.toString()));
    }
  }

  @override
  Future<Result<Map<String, num>>> getAnalytics() async {
    try {
      final data = await _remoteDataSource.getAnalytics();
      return Success(data);
    } on Exception catch (error) {
      return ErrorResult(Failure(message: error.toString()));
    }
  }
}
