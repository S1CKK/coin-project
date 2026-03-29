import 'package:coin_proj/core/utils/number_format.dart';
import 'package:coin_proj/features/coin/domain/entities/coin.dart';
import 'package:coin_proj/features/coin/presentation/bloc/coin_detail_cubit.dart';
import 'package:coin_proj/features/coin/presentation/widgets/capsule.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CoinDetailView extends StatelessWidget {
  final CoinEntity coinEntity;

  const CoinDetailView({
    super.key,
    required this.coinEntity,
  });

  Color getCoinColor(String? colorHex) {
    if (colorHex == null || colorHex.isEmpty) {
      return Colors.black;
    }

    try {
      final color = Color(
        int.parse(colorHex.replaceFirst('#', '0xff')),
      );

      if (colorHex.toLowerCase() == '#ffffff') {
        return Colors.black;
      }

      return color;
    } catch (_) {
      return Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    var isNegative = coinEntity.change < 0;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: BlocBuilder<CoinDetailCubit, CoinDetailState>(
        builder: (context, state) {
          if (state.status == CoinDetailStatus.loading) {
            return const SizedBox(
              height: 200,
              child: Center(child: CupertinoActivityIndicator()),
            );
          }

          if (state.status == CoinDetailStatus.failure) {
            return Column(
              children: [
                Container(
                  width: 80,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                 SizedBox(
                  height: 200,
                  child: Center(
                    child: Text(AppLocalizations.of(context)!.somethingWrong,),
                  ),
                ),
              ],
            );
          }

          if (state.status == CoinDetailStatus.success && state.coin != null) {
            final coin = state.coin!;

            return Column(
              children: [
                Container(
                  width: 80,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Image.network(
                          coin.iconUrl,
                          width: 60,
                          height: 60,
                          errorBuilder: (_, __, ___) =>
                              const Icon(Icons.currency_bitcoin),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    state.coin!.name,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: getCoinColor(state.coin?.color),
                                    ),
                                  ),
                                  Text(
                                    ' (${state.coin!.symbol})',
                                    style: const TextStyle(
                                        fontSize: 18,
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text.rich(
                                    TextSpan(
                                      text: 'Price: ',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: double.parse(state.coin!.price)
                                              .toCurrency(),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Capsule(
                                      isNegative: isNegative, coin: coinEntity)
                                ],
                              ),
                              Text.rich(
                                TextSpan(
                                  text: 'Market Cap: ',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: double.parse(state.coin!.marketCap)
                                          .formatMarketCap(),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      state.coin!.description,
                      style: const TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                    Visibility(
                      visible: coin.websiteUrl != '',
                      child: InkWell(
                        onTap: () async {
                          final url = Uri.parse(coin.websiteUrl);
                          await launchUrl(url,
                              mode: LaunchMode.externalApplication);
                        },
                        child: const Text(
                          'Read more',
                          style: TextStyle(
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.blue,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            );
          }

          return const SizedBox(
            height: 200,
            child: Center(child: Text("No data")),
          );
        },
      ),
    );
  }
}
