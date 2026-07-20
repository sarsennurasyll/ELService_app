/// DTO аналитики администратора.
///
/// TODO: добавить fromJson / toJson после контракта Backend.
final class AdminAnalyticsDto {
  const AdminAnalyticsDto({
    required this.revenue,
    required this.ordersCount,
    required this.customersCount,
    required this.techniciansCount,
  });

  final double revenue;
  final int ordersCount;
  final int customersCount;
  final int techniciansCount;
}
