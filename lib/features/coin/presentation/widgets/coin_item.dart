import 'package:coin_proj/core/utils/number_format.dart';
import 'package:coin_proj/features/coin/domain/entities/coin.dart';
import 'package:coin_proj/features/coin/presentation/widgets/capsule.dart';
import 'package:flutter/material.dart';

class CoinItem extends StatelessWidget {
  final CoinEntity coin;
  final VoidCallback onTap;

  const CoinItem({
    super.key,
    required this.coin,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isNegative = coin.change < 0;

    return Column(
      children: [
        ListTile(
          onTap: onTap,
          leading: Image.network(
            coin.iconUrl,
            width: 32,
            height: 32,
            errorBuilder: (_, __, ___) =>
                const Icon(Icons.currency_bitcoin),
          ),
          title: Text(
            coin.symbol,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            '\$${coin.marketCap.formatMarketCap()}',
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.grey,
              fontSize: 12,
            ),
          ),
          trailing: SizedBox(
            width: 150,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  coin.price.toCurrency(),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(width: 10),
                Capsule(isNegative: isNegative, coin: coin),
              ],
            ),
          ),
        ),
        const Divider(
          color: Colors.grey,
          thickness: 1,
          indent: 60,
          height: 1,
        ),
      ],
    );
  }
}