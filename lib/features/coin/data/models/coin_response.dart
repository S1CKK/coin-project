import 'package:coin_proj/features/coin/data/models/coin_model.dart';

class CoinResponseModel {
  final String status;
  final List<CoinModel> coins;
  final PaginationModel pagination;

  CoinResponseModel({
    required this.status,
    required this.coins,
    required this.pagination,
  });

  factory CoinResponseModel.fromJson(Map<String, dynamic> json) {
    return CoinResponseModel(
      status: json['status'] ?? '',
      coins: (json['data']?['coins'] as List? ?? [])
          .map((e) => CoinModel.fromJson(e))
          .toList(),
      pagination: PaginationModel.fromJson(json['pagination'] ?? {}),
    );
  }
  String? get nextCursor => pagination.nextCursor;
  bool get hasNextPage => pagination.hasNextPage;
}

class PaginationModel {
  final int limit;
  final bool hasNextPage;
  final bool hasPreviousPage;
  final String? nextCursor;
  final String? previousCursor;

  PaginationModel({
    required this.limit,
    required this.hasNextPage,
    required this.hasPreviousPage,
    required this.nextCursor,
    required this.previousCursor,
  });

  factory PaginationModel.fromJson(Map<String, dynamic> json) {
    return PaginationModel(
      limit: json['limit'] ?? 10,
      hasNextPage: json['hasNextPage'] ?? false,
      hasPreviousPage: json['hasPreviousPage'] ?? false,
      nextCursor: json['nextCursor'],
      previousCursor: json['previousCursor'],
    );
  }
}
