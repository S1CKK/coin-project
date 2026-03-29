import 'package:coin_proj/features/coin/domain/entities/coin.dart';

class CoinModel {
  final String uuid;
  final String name;
  final String symbol;
  final String iconUrl;
  final String color;
  final num rank;
  final double price;
  final double change;
  final double marketCap;

  CoinModel({
    required this.uuid,
    required this.name,
    required this.symbol,
    required this.iconUrl,
    required this.color,
    required this.rank,
    required this.price,
    required this.change,
    required this.marketCap,
  });

  factory CoinModel.fromJson(Map<String, dynamic> json) {
    return CoinModel(
      uuid: json['uuid'],
      name: json['name'],
      symbol: json['symbol'],
      iconUrl: json['iconUrl'] ?? '',
      color: json['color'] ?? '',
      rank: json['rank'] ?? 0,
      price: double.tryParse(json['price'] ?? '0') ?? 0,
      change: double.tryParse(json['change'] ?? '0') ?? 0,
      marketCap: double.tryParse(json['marketCap'] ?? '0') ?? 0,
    );
  }
}

extension CoinMapper on CoinModel {
  CoinEntity toEntity() {
    return CoinEntity(
      uuid: uuid,
      name: name,
      symbol: symbol,
      rank: rank,
      iconUrl: iconUrl,
      price: price,
      change: change,
      marketCap: marketCap,
    );
  }
}