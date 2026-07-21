final class Offer {
  const Offer({
    required this.id,
    required this.orderId,
    required this.masterId,
    required this.price,
    required this.arrivalTime,
    required this.status,
    this.comment,
    this.masterName,
  });

  final String id;
  final String orderId;
  final String masterId;
  final double price;
  final String arrivalTime;
  final String status;
  final String? comment;
  final String? masterName;
}
