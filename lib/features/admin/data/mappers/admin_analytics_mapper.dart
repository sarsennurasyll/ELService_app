import '../../domain/models/admin_analytics.dart';
import '../models/admin_analytics_dto.dart';

/// Маппер AdminAnalyticsDto ↔ AdminAnalytics.
final class AdminAnalyticsMapper {
  const AdminAnalyticsMapper();

  AdminAnalytics fromDto(AdminAnalyticsDto dto) {
    return AdminAnalytics(
      revenue: dto.revenue,
      ordersCount: dto.ordersCount,
      customersCount: dto.customersCount,
      techniciansCount: dto.techniciansCount,
    );
  }

  AdminAnalyticsDto toDto(AdminAnalytics entity) {
    return AdminAnalyticsDto(
      revenue: entity.revenue,
      ordersCount: entity.ordersCount,
      customersCount: entity.customersCount,
      techniciansCount: entity.techniciansCount,
    );
  }
}
