import 'package:coin_proj/features/coin/data/models/coin_detail_model.dart';
import 'package:coin_proj/features/coin/data/models/coin_response.dart';
import 'package:dio/dio.dart';

class CoinRemoteDataSource {
  final Dio dio;

  CoinRemoteDataSource(this.dio);

  Future<CoinResponseModel> getCoins(String? cursor, num limit) async {
    try {
      final response = await dio.get(
        '/v2/coins',
        queryParameters: {
          'limit': limit,
          if (cursor != null) 'cursor': cursor,
        },
      );

      return CoinResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception('Unexpected error');
    }
  }

  Future<CoinResponseModel> searchCoins(
      String query, String? cursor, num limit) async {
    try {
      final response = await dio.get(
        '/v2/coins',
        queryParameters: {
          'search': query,
          'limit': limit,
          if (cursor != null) 'cursor': cursor,
        },
      );

      return CoinResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception('Unexpected error');
    }
  }

  Future<CoinDetail> getCoinDetail(String uuid) async {
    try {
      final response = await dio.get('/v2/coin/$uuid');

      final data = response.data;

      if (data == null ||
          data['data'] == null ||
          data['data']['coin'] == null) {
        throw Exception("Invalid API response");
      }

      return CoinDetail.fromJson(data);
    } on DioException catch (e) {
      throw Exception(e.response?.data?['message'] ?? e.message);
    } catch (e) {
      throw Exception("Unexpected error: $e");
    }
  }
}
