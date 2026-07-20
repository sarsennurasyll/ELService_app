import '../../domain/models/order.dart';
import '../models/order_dto.dart';

/// Маппер OrderDto ↔ Order.
final class OrderMapper {
  const OrderMapper();

  Order fromDto(OrderDto dto) {
    // TODO: расширить маппинг по полям Backend.
    return Order(
      id: dto.id,
      customerId: dto.customerId,
      categoryId: dto.categoryId,
      status: dto.status,
      description: dto.description,
      technicianId: dto.technicianId,
      address: dto.address,
      price: dto.price,
    );
  }

  OrderDto toDto(Order entity) {
    // TODO: расширить маппинг по полям Backend.
    return OrderDto(
      id: entity.id,
      customerId: entity.customerId,
      categoryId: entity.categoryId,
      status: entity.status,
      description: entity.description,
      technicianId: entity.technicianId,
      address: entity.address,
      price: entity.price,
    );
  }
}
