import '../../../../core/errors/failure.dart';
import '../../../../core/utils/result.dart';
import '../../domain/models/category.dart';
import '../../domain/models/customer.dart';
import '../../domain/models/message.dart';
import '../../domain/models/order.dart';
import '../../domain/models/review.dart';
import '../../domain/repositories/customer_repository.dart';
import '../datasources/customer_remote_datasource.dart';
import '../mappers/category_mapper.dart';
import '../mappers/customer_mapper.dart';
import '../mappers/message_mapper.dart';
import '../mappers/order_mapper.dart';
import '../mappers/review_mapper.dart';

/// Реализация [CustomerRepository].
///
/// TODO: подключить Repository к RemoteDataSource.
final class CustomerRepositoryImpl implements CustomerRepository {
  const CustomerRepositoryImpl({
    required CustomerRemoteDataSource remoteDataSource,
    required CustomerMapper customerMapper,
    required OrderMapper orderMapper,
    required CategoryMapper categoryMapper,
    required MessageMapper messageMapper,
    required ReviewMapper reviewMapper,
  }) : _remoteDataSource = remoteDataSource,
       _customerMapper = customerMapper,
       _orderMapper = orderMapper,
       _categoryMapper = categoryMapper,
       _messageMapper = messageMapper,
       _reviewMapper = reviewMapper;

  final CustomerRemoteDataSource _remoteDataSource;
  final CustomerMapper _customerMapper;
  final OrderMapper _orderMapper;
  final CategoryMapper _categoryMapper;
  final MessageMapper _messageMapper;
  final ReviewMapper _reviewMapper;

  @override
  Future<Result<Customer?>> getProfile() async {
    try {
      final dto = await _remoteDataSource.getProfile();
      if (dto == null) {
        return const Success(null);
      }
      return Success(_customerMapper.fromDto(dto));
    } on Exception catch (error) {
      return ErrorResult(Failure(message: error.toString()));
    }
  }

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
  Future<Result<Order>> getOrderById(String id) async {
    try {
      final dto = await _remoteDataSource.getOrderById(id);
      return Success(_orderMapper.fromDto(dto));
    } on Exception catch (error) {
      return ErrorResult(Failure(message: error.toString()));
    }
  }

  @override
  Future<Result<Order>> createOrder(Order order) async {
    try {
      final dto = await _remoteDataSource.createOrder(
        _orderMapper.toDto(order),
      );
      return Success(_orderMapper.fromDto(dto));
    } on Exception catch (error) {
      return ErrorResult(Failure(message: error.toString()));
    }
  }

  @override
  Future<Result<List<Category>>> getCategories() async {
    try {
      final dtos = await _remoteDataSource.getCategories();
      return Success(dtos.map(_categoryMapper.fromDto).toList());
    } on Exception catch (error) {
      return ErrorResult(Failure(message: error.toString()));
    }
  }

  @override
  Future<Result<List<Message>>> getMessages(String orderId) async {
    try {
      final dtos = await _remoteDataSource.getMessages(orderId);
      return Success(dtos.map(_messageMapper.fromDto).toList());
    } on Exception catch (error) {
      return ErrorResult(Failure(message: error.toString()));
    }
  }

  @override
  Future<Result<Review>> createReview(Review review) async {
    try {
      final dto = await _remoteDataSource.createReview(
        _reviewMapper.toDto(review),
      );
      return Success(_reviewMapper.fromDto(dto));
    } on Exception catch (error) {
      return ErrorResult(Failure(message: error.toString()));
    }
  }
}
