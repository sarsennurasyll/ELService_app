import '../../domain/models/order.dart';
import '../models/order_dto.dart';

/// Преобразует DTO заказа в доменную модель.
final class OrderMapper {
  const OrderMapper();

  Order fromDto(OrderDto dto) {
    return Order(
      id: dto.id,
      customerId: dto.customerId,
      categoryId: dto.categoryId,
      status: dto.status,
      description: dto.description,
      technicianId: dto.technicianId,
      address: dto.address,
      price: dto.price,
      preferredDate: dto.preferredDate,
    );
  }

  OrderDto toDto(Order entity) {
    return OrderDto(
      id: entity.id,
      customerId: entity.customerId,
      categoryId: entity.categoryId,
      status: entity.status,
      description: entity.description,
      technicianId: entity.technicianId,
      address: entity.address,
      price: entity.price,
      preferredDate: entity.preferredDate,
    );
  }
}
