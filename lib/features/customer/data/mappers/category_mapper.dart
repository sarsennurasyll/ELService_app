import '../../domain/models/category.dart';
import '../models/category_dto.dart';

/// Маппер CategoryDto ↔ Category.
final class CategoryMapper {
  const CategoryMapper();

  Category fromDto(CategoryDto dto) {
    return Category(id: dto.id, name: dto.name, icon: dto.icon);
  }

  CategoryDto toDto(Category entity) {
    return CategoryDto(id: entity.id, name: entity.name, icon: entity.icon);
  }
}
