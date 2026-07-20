/// Сводка аналитики администратора.
final class AdminAnalytics {
  const AdminAnalytics({
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
