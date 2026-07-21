final class OfferDto {
  const OfferDto({required this.id, required this.orderId, required this.masterId, required this.price, required this.arrivalTime, required this.status, this.comment, this.masterName});
  final String id; final String orderId; final String masterId; final double price; final String arrivalTime; final String status; final String? comment; final String? masterName;
  factory OfferDto.fromMap(Map<String, dynamic> map) {
    final id = map['id']; final orderId = map['orderId']; final masterId = map['masterId']; final price = map['price']; final arrivalTime = map['arrivalTime']; final status = map['status'];
    if (id is! String || orderId is! String || masterId is! String || arrivalTime is! String || status is! String) throw const FormatException('Некорректные данные предложения');
    final parsedPrice = price is num ? price.toDouble() : price is String ? double.tryParse(price) : null;
    if (parsedPrice == null) throw const FormatException('Некорректная стоимость предложения');
    final master = map['master'];
    return OfferDto(id: id, orderId: orderId, masterId: masterId, price: parsedPrice, arrivalTime: arrivalTime, status: status, comment: map['comment'] as String?, masterName: master is Map ? master['fullName'] as String? : null);
  }
  Map<String, dynamic> toCreateMap() => {'orderId': orderId, 'price': price, 'arrivalTime': arrivalTime, if (comment != null) 'comment': comment};
}
