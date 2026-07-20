/// Доменная модель категории техники/услуги.
final class Category {
  const Category({
    required this.id,
    required this.name,
    this.icon,
  });

  final String id;
  final String name;
  final String? icon;
}
