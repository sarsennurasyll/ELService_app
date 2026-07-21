import '../../domain/models/category.dart';
import '../models/category_dto.dart';

/// Преобразует DTO категории в доменную модель.
final class CategoryMapper {
  const CategoryMapper();

  Category fromDto(CategoryDto dto) {
    return Category(id: dto.id, name: dto.name, icon: dto.icon);
  }
}
