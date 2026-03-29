import 'package:coin_proj/core/utils/number_format.dart';
import 'package:coin_proj/features/coin/presentation/widgets/capsule.dart';
import 'package:flutter/material.dart';
import 'package:coin_proj/features/coin/domain/entities/coin.dart';

class Top3Section extends StatelessWidget {
  final List<CoinEntity> coins;
  // final Function() onTap;

  const Top3Section({
    super.key,
    required this.coins,
    // required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (coins.isEmpty) return const SizedBox();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: coins.map((coin) {
              return Expanded(
                child: GestureDetector(
                  // onTap: () => onTap(coin),
                  child: Card(
                    color: Colors.white,
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        children: [
                          Image.network(
                            coin.iconUrl,
                            width: 40,
                            height: 40,
                            errorBuilder: (_, __, ___) =>
                                const Icon(Icons.currency_bitcoin),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            coin.symbol,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            coin.price.toCurrency(),
                            style: const TextStyle(fontSize: 12),
                          ),
                           const SizedBox(height: 4),
                           Capsule(isNegative: coin.change < 0, coin: coin)
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}