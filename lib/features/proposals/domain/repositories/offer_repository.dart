import '../../../../core/utils/result.dart';
import '../models/offer.dart';
abstract interface class OfferRepository { Future<Result<List<Offer>>> getOffers(String orderId); Future<Result<Offer>> createOffer(Offer offer); Future<Result<Offer>> acceptOffer(String id); }
