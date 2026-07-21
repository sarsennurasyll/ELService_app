import '../../../../core/errors/api_exception.dart';
import '../../../../core/network/api_client.dart';
import '../models/offer_dto.dart';
abstract interface class OfferRemoteDataSource { Future<List<OfferDto>> getOffers(String orderId); Future<OfferDto> createOffer(OfferDto offer); Future<OfferDto> acceptOffer(String id); }
final class OfferRemoteDataSourceImpl implements OfferRemoteDataSource { const OfferRemoteDataSourceImpl({required ApiClient apiClient}) : _apiClient = apiClient; final ApiClient _apiClient;
  @override Future<List<OfferDto>> getOffers(String orderId) async { final response = await _apiClient.get('/orders/$orderId/offers'); final data = response['data']; if (data is! List) throw const ApiException(message: 'Некорректный ответ сервера'); return data.map((item) => OfferDto.fromMap(Map<String, dynamic>.from(item as Map))).toList(); }
  @override Future<OfferDto> createOffer(OfferDto offer) async => _fromResponse(await _apiClient.post('/offers', body: offer.toCreateMap()));
  @override Future<OfferDto> acceptOffer(String id) async => _fromResponse(await _apiClient.patch('/offers/$id/accept'));
  OfferDto _fromResponse(Map<String, dynamic> response) { final data = response['data']; if (data is! Map) throw const ApiException(message: 'Некорректный ответ сервера'); return OfferDto.fromMap(Map<String, dynamic>.from(data)); }
}
