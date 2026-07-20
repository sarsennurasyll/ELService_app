import '../../domain/models/customer.dart';
import '../models/customer_dto.dart';

/// Маппер CustomerDto ↔ Customer.
final class CustomerMapper {
  const CustomerMapper();

  Customer fromDto(CustomerDto dto) {
    return Customer(
      id: dto.id,
      userId: dto.userId,
      name: dto.name,
      phone: dto.phone,
      city: dto.city,
    );
  }

  CustomerDto toDto(Customer entity) {
    return CustomerDto(
      id: entity.id,
      userId: entity.userId,
      name: entity.name,
      phone: entity.phone,
      city: entity.city,
    );
  }
}
