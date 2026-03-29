
import 'package:coin_proj/features/coin/domain/entities/coin.dart';

class CoinResponseEntity {
  final List<CoinEntity> coins;
  final String? nextCursor;
  final bool hasNextPage;

  CoinResponseEntity({
    required this.coins,
    this.nextCursor,
    required this.hasNextPage,
  });
}
