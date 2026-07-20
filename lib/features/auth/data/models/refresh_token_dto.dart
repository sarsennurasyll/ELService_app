/// DTO refresh-токена.
///
/// TODO: добавить toJson / fromJson после контракта Backend.
final class RefreshTokenDto {
  const RefreshTokenDto({required this.refreshToken});

  final String refreshToken;

  Map<String, dynamic> toMap() {
    return {'refreshToken': refreshToken};
  }

  factory RefreshTokenDto.fromMap(Map<String, dynamic> map) {
    return RefreshTokenDto(
      refreshToken: map['refreshToken'] as String? ?? '',
    );
  }
}
