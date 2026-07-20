import '../../../../core/utils/result.dart';
import '../models/category.dart';
import '../models/customer.dart';
import '../models/message.dart';
import '../models/order.dart';
import '../models/review.dart';

/// Контракт репозитория клиента.
///
/// TODO: подключить Repository к RemoteDataSource.
abstract interface class CustomerRepository {
  Future<Result<Customer?>> getProfile();

  Future<Result<List<Order>>> getOrders();

  Future<Result<Order>> getOrderById(String id);

  Future<Result<Order>> createOrder(Order order);

  Future<Result<List<Category>>> getCategories();

  Future<Result<List<Message>>> getMessages(String orderId);

  Future<Result<Review>> createReview(Review review);
}
