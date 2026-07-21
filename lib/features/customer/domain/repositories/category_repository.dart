import '../../../../core/utils/result.dart';
import '../models/category.dart';

abstract interface class CategoryRepository {
  Future<Result<List<Category>>> getCategories();

  Future<Result<Category>> getCategoryById(String id);
}
