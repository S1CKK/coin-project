import 'package:coin_proj/features/coin/data/datasources/coin_datasource.dart';
import 'package:coin_proj/features/coin/data/models/coin_detail_model.dart';
import 'package:coin_proj/features/coin/data/models/coin_model.dart';
import 'package:coin_proj/features/coin/domain/entities/coin.dart';
import 'package:coin_proj/features/coin/domain/entities/coin_detail_entity.dart';
import 'package:coin_proj/features/coin/domain/entities/coin_response_entity.dart';
import 'package:coin_proj/features/coin/domain/repositories/coin_repository.dart';

class CoinRepositoryImpl implements CoinRepository {
  final CoinRemoteDataSource remote;

  CoinRepositoryImpl(this.remote);

  @override
  Future<CoinResponseEntity> getCoins(String? cursor, num limit) async {
    final model = await remote.getCoins(cursor, limit);

    return CoinResponseEntity(
      coins: model.coins
          .map((m) => CoinEntity(
                uuid: m.uuid,
                name: m.name,
                symbol: m.symbol,
                rank: m.rank,
                iconUrl: m.iconUrl,
                price: m.price,
                change: m.change,
                marketCap: m.marketCap,
              ))
          .toList(),
      nextCursor: model.pagination.nextCursor,
      hasNextPage: model.pagination.hasNextPage,
    );
  }

  @override
  Future<CoinDetailEntity> getCoinDetail(String uuid) async {
    try {
      final model = await remote.getCoinDetail(uuid);
      return model.toEntity();
    } catch (e) {
      throw Exception('Repository: Cannot get coin detail - $e');
    }
  }

  @override
  Future<CoinResponseEntity> searchCoins(
      String query, String? cursor, num limit) async {
    final model = await remote.searchCoins(query, cursor, limit);

    return CoinResponseEntity(
      coins: model.coins.map((m) => m.toEntity()).toList(),
      nextCursor: model.pagination.nextCursor,
      hasNextPage: model.pagination.hasNextPage,
    );
  }
}
