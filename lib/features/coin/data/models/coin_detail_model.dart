import 'package:coin_proj/features/coin/domain/entities/coin_detail_entity.dart';

class CoinDetail {
  final String uuid;
  final String name;
  final String symbol;
  final String description;
  final String iconUrl;
  final String price;
  final String marketCap;
  final String change;
  final String websiteUrl;
  final String color;

  CoinDetail({
    required this.uuid,
    required this.name,
    required this.symbol,
    required this.description,
    required this.iconUrl,
    required this.price,
    required this.marketCap,
    required this.change,
    required this.websiteUrl,
    required this.color,
  });

  factory CoinDetail.fromJson(Map<String, dynamic> json) {
    final data = json['data']['coin'];
    return CoinDetail(
      uuid: data['uuid'] ?? '',
      name: data['name'] ?? '',
      symbol: data['symbol'] ?? '',
      description: data['description'] ?? '',
      iconUrl: data['iconUrl'] ?? '',
      price: data['price'] ?? '0',
      marketCap: data['marketCap'] ?? '0',
      change: data['change'] ?? '0',
      websiteUrl: data['websiteUrl'] ?? '',
      color: data['color'] ?? '',
    );
  }
}

extension CoinMapper on CoinDetail {
  CoinDetailEntity toEntity() {
    return CoinDetailEntity(
      uuid: uuid,
      name: name,
      symbol: symbol,
      iconUrl: iconUrl,
      price: price,
      change: change,
      marketCap: marketCap,
      description: description,
      websiteUrl: websiteUrl,
      color: color,
    );
  }
}
