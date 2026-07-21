import '../../domain/models/offer.dart';
import '../models/offer_dto.dart';
final class OfferMapper { const OfferMapper(); Offer fromDto(OfferDto dto) => Offer(id: dto.id, orderId: dto.orderId, masterId: dto.masterId, price: dto.price, arrivalTime: dto.arrivalTime, status: dto.status, comment: dto.comment, masterName: dto.masterName); OfferDto toDto(Offer offer) => OfferDto(id: offer.id, orderId: offer.orderId, masterId: offer.masterId, price: offer.price, arrivalTime: offer.arrivalTime, status: offer.status, comment: offer.comment, masterName: offer.masterName); }
