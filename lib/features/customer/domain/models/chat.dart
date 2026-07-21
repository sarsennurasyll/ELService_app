final class Chat {
  const Chat({required this.id, required this.orderId, required this.userAId, required this.userBId, this.lastMessage});
  final String id; final String orderId; final String userAId; final String userBId; final String? lastMessage;
}
