import '../../../../core/utils/result.dart';
import '../models/order.dart';

abstract interface class OrderRepository {
  Future<Result<List<Order>>> getOrders();

  Future<Result<Order>> getOrderById(String id);

  Future<Result<Order>> createOrder(Order order);
}
