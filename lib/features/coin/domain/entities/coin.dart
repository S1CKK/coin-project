class CoinEntity {
  final String uuid;
  final String name;
  final String symbol;
  final num rank;
  final String iconUrl;
  final double price;
  final double change;
  final double marketCap;

  CoinEntity({
    required this.uuid,
    required this.name,
    required this.symbol,
    required this.rank,
    required this.iconUrl,
    required this.price,
    required this.change,
    required this.marketCap,
  });
}