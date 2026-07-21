import '../../../../core/errors/api_exception.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/errors/network_exception.dart';
import '../../../../core/utils/result.dart';
import '../../domain/models/category.dart';
import '../../domain/repositories/category_repository.dart';
import '../datasources/category_remote_datasource.dart';
import '../mappers/category_mapper.dart';

final class CategoryRepositoryImpl implements CategoryRepository {
  const CategoryRepositoryImpl({
    required CategoryRemoteDataSource remoteDataSource,
    this.categoryMapper = const CategoryMapper(),
  }) : _remoteDataSource = remoteDataSource;

  final CategoryRemoteDataSource _remoteDataSource;
  final CategoryMapper categoryMapper;

  @override
  Future<Result<List<Category>>> getCategories() async {
    try {
      final categories = await _remoteDataSource.getCategories();
      return Success(categories.map(categoryMapper.fromDto).toList());
    } on Exception catch (error) {
      return ErrorResult(_mapFailure(error));
    }
  }

  @override
  Future<Result<Category>> getCategoryById(String id) async {
    try {
      final category = await _remoteDataSource.getCategoryById(id);
      return Success(categoryMapper.fromDto(category));
    } on Exception catch (error) {
      return ErrorResult(_mapFailure(error));
    }
  }

  Failure _mapFailure(Exception error) {
    if (error is ApiException) {
      return Failure(
        message: error.message,
        code: error.code,
        statusCode: error.statusCode,
      );
    }
    if (error is NetworkException) {
      return Failure(message: error.message);
    }
    return Failure(message: error.toString());
  }
}
