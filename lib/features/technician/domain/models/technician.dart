/// Доменная модель мастера.
final class Technician {
  const Technician({
    required this.id,
    required this.userId,
    required this.name,
    required this.rating,
    required this.jobsCount,
    this.city,
    this.isVerified = false,
    this.specialization,
  });

  final String id;
  final String userId;
  final String name;
  final double rating;
  final int jobsCount;
  final String? city;
  final bool isVerified;
  final String? specialization;
}
