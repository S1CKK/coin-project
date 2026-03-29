import 'package:coin_proj/features/coin/domain/entities/coin.dart';
import 'package:flutter/material.dart';

class Capsule extends StatelessWidget {
  const Capsule({
    super.key,
    required this.isNegative,
    required this.coin,
  });

  final bool isNegative;
  final CoinEntity coin;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: isNegative
            ? Colors.red
            : Colors.green,
        borderRadius: BorderRadius.circular(
          10,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment:
            MainAxisAlignment.end,
        children: [
          Icon(
            isNegative
                ? Icons.arrow_downward
                : Icons.arrow_upward,
            color: Colors.white,
            size: 10,
          ),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              '${coin.change.abs().toStringAsFixed(2)}%',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 8,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
