import '../../../../core/errors/api_exception.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/errors/network_exception.dart';
import '../../../../core/utils/result.dart';
import '../../domain/models/order.dart';
import '../../domain/repositories/order_repository.dart';
import '../datasources/order_remote_datasource.dart';
import '../mappers/order_mapper.dart';

final class OrderRepositoryImpl implements OrderRepository {
  const OrderRepositoryImpl({
    required OrderRemoteDataSource remoteDataSource,
    this.orderMapper = const OrderMapper(),
  }) : _remoteDataSource = remoteDataSource;

  final OrderRemoteDataSource _remoteDataSource;
  final OrderMapper orderMapper;

  @override
  Future<Result<List<Order>>> getOrders() async {
    try {
      final orders = await _remoteDataSource.getOrders();
      return Success(orders.map(orderMapper.fromDto).toList());
    } on Exception catch (error) {
      return ErrorResult(_mapFailure(error));
    }
  }

  @override
  Future<Result<Order>> getOrderById(String id) async {
    try {
      final order = await _remoteDataSource.getOrderById(id);
      return Success(orderMapper.fromDto(order));
    } on Exception catch (error) {
      return ErrorResult(_mapFailure(error));
    }
  }

  @override
  Future<Result<Order>> createOrder(Order order) async {
    try {
      final dto = await _remoteDataSource.createOrder(orderMapper.toDto(order));
      return Success(orderMapper.fromDto(dto));
    } on Exception catch (error) {
      return ErrorResult(_mapFailure(error));
    }
  }

  @override
  Future<Result<Order>> startOrder(String id) async {
    try {
      final order = await _remoteDataSource.startOrder(id);
      return Success(orderMapper.fromDto(order));
    } on Exception catch (error) {
      return ErrorResult(_mapFailure(error));
    }
  }

  @override
  Future<Result<Order>> completeOrder(String id) async {
    try {
      final order = await _remoteDataSource.completeOrder(id);
      return Success(orderMapper.fromDto(order));
    } on Exception catch (error) {
      return ErrorResult(_mapFailure(error));
    }
  }

  @override
  Future<Result<Order>> cancelOrder(String id) async {
    try {
      final order = await _remoteDataSource.cancelOrder(id);
      return Success(orderMapper.fromDto(order));
    } on Exception catch (error) {
      return ErrorResult(_mapFailure(error));
    }
  }

  Failure _mapFailure(Exception error) {
    if (error is ApiException) {
      return Failure(
        message: error.message,
        code: error.code,
        statusCode: error.statusCode,
      );
    }
    if (error is NetworkException) {
      return Failure(message: error.message);
    }
    return Failure(message: error.toString());
  }
}
