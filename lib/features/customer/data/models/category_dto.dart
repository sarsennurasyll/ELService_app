/// DTO категории из Backend.
final class CategoryDto {
  const CategoryDto({
    required this.id,
    required this.name,
    this.icon,
  });

  final String id;
  final String name;
  final String? icon;

  factory CategoryDto.fromMap(Map<String, dynamic> map) {
    final id = map['id'];
    final name = map['name'];

    if (id is! String || name is! String) {
      throw const FormatException('Некорректные данные категории');
    }

    return CategoryDto(
      id: id,
      name: name,
      icon: map['icon'] as String?,
    );
  }
}
