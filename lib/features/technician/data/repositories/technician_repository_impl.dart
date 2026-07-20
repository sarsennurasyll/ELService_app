import '../../../../core/errors/failure.dart';
import '../../../../core/utils/result.dart';
import '../../../customer/data/mappers/order_mapper.dart';
import '../../../customer/domain/models/order.dart';
import '../../domain/models/technician.dart';
import '../../domain/repositories/technician_repository.dart';
import '../datasources/technician_remote_datasource.dart';
import '../mappers/technician_mapper.dart';

/// Реализация [TechnicianRepository].
///
/// TODO: подключить Repository к RemoteDataSource.
final class TechnicianRepositoryImpl implements TechnicianRepository {
  const TechnicianRepositoryImpl({
    required TechnicianRemoteDataSource remoteDataSource,
    required TechnicianMapper technicianMapper,
    required OrderMapper orderMapper,
  }) : _remoteDataSource = remoteDataSource,
       _technicianMapper = technicianMapper,
       _orderMapper = orderMapper;

  final TechnicianRemoteDataSource _remoteDataSource;
  final TechnicianMapper _technicianMapper;
  final OrderMapper _orderMapper;

  @override
  Future<Result<Technician?>> getProfile() async {
    try {
      final dto = await _remoteDataSource.getProfile();
      if (dto == null) {
        return const Success(null);
      }
      return Success(_technicianMapper.fromDto(dto));
    } on Exception catch (error) {
      return ErrorResult(Failure(message: error.toString()));
    }
  }

  @override
  Future<Result<List<Order>>> getIncomingOrders() async {
    try {
      final dtos = await _remoteDataSource.getIncomingOrders();
      return Success(dtos.map(_orderMapper.fromDto).toList());
    } on Exception catch (error) {
      return ErrorResult(Failure(message: error.toString()));
    }
  }

  @override
  Future<Result<List<Order>>> getAcceptedOrders() async {
    try {
      final dtos = await _remoteDataSource.getAcceptedOrders();
      return Success(dtos.map(_orderMapper.fromDto).toList());
    } on Exception catch (error) {
      return ErrorResult(Failure(message: error.toString()));
    }
  }

  @override
  Future<Result<Order>> acceptOrder(String orderId) async {
    try {
      final dto = await _remoteDataSource.acceptOrder(orderId);
      return Success(_orderMapper.fromDto(dto));
    } on Exception catch (error) {
      return ErrorResult(Failure(message: error.toString()));
    }
  }

  @override
  Future<Result<double>> getEarnings() async {
    try {
      final value = await _remoteDataSource.getEarnings();
      return Success(value);
    } on Exception catch (error) {
      return ErrorResult(Failure(message: error.toString()));
    }
  }
}
