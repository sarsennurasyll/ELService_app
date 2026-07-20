import '../../domain/models/technician.dart';
import '../models/technician_dto.dart';

/// Маппер TechnicianDto ↔ Technician.
final class TechnicianMapper {
  const TechnicianMapper();

  Technician fromDto(TechnicianDto dto) {
    return Technician(
      id: dto.id,
      userId: dto.userId,
      name: dto.name,
      rating: dto.rating,
      jobsCount: dto.jobsCount,
      city: dto.city,
      isVerified: dto.isVerified,
      specialization: dto.specialization,
    );
  }

  TechnicianDto toDto(Technician entity) {
    return TechnicianDto(
      id: entity.id,
      userId: entity.userId,
      name: entity.name,
      rating: entity.rating,
      jobsCount: entity.jobsCount,
      city: entity.city,
      isVerified: entity.isVerified,
      specialization: entity.specialization,
    );
  }
}
