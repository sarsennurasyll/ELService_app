import '../../../../core/errors/api_exception.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../models/category_dto.dart';

abstract interface class CategoryRemoteDataSource {
  Future<List<CategoryDto>> getCategories();

  Future<CategoryDto> getCategoryById(String id);
}

final class CategoryRemoteDataSourceImpl implements CategoryRemoteDataSource {
  const CategoryRemoteDataSourceImpl({required ApiClient apiClient})
    : _apiClient = apiClient;

  final ApiClient _apiClient;

  @override
  Future<List<CategoryDto>> getCategories() async {
    final response = await _apiClient.get(ApiEndpoints.categories);
    final data = response['data'];

    if (data is! List) {
      throw const ApiException(message: 'Некорректный ответ сервера');
    }

    return data.map(_categoryFromJson).toList();
  }

  @override
  Future<CategoryDto> getCategoryById(String id) async {
    final response = await _apiClient.get('${ApiEndpoints.categories}/$id');
    return _categoryFromJson(response['data']);
  }

  CategoryDto _categoryFromJson(dynamic json) {
    if (json is! Map) {
      throw const ApiException(message: 'Некорректный ответ сервера');
    }

    return CategoryDto.fromMap(Map<String, dynamic>.from(json));
  }
}
