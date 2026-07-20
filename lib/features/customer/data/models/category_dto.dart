/// DTO категории.
///
/// TODO: добавить fromJson / toJson после контракта Backend.
final class CategoryDto {
  const CategoryDto({
    required this.id,
    required this.name,
    this.icon,
  });

  final String id;
  final String name;
  final String? icon;
}
