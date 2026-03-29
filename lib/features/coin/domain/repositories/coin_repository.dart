import 'package:coin_proj/features/coin/domain/entities/coin_detail_entity.dart';
import 'package:coin_proj/features/coin/domain/entities/coin_response_entity.dart';

abstract class CoinRepository {
  Future<CoinResponseEntity> getCoins(String? cursor, num limit);
  Future<CoinResponseEntity> searchCoins(String query, String? cursor, num limit);
  Future<CoinDetailEntity> getCoinDetail(String uuid); 
}