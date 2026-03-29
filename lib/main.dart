import 'package:coin_proj/features/coin/data/datasources/coin_datasource.dart';
import 'package:coin_proj/features/coin/data/repositories/coin_repository.dart';
import 'package:coin_proj/features/coin/presentation/bloc/search_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'features/coin/presentation/bloc/coin_list_cubit.dart';
import 'features/coin/presentation/pages/coin_list_page.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() {
  final dio = Dio(BaseOptions(
    baseUrl: 'https://api.coinranking.com',
  ));

  final remote = CoinRemoteDataSource(dio);
  final repository = CoinRepositoryImpl(remote);

  runApp(MyApp(repository: repository));
}

class MyApp extends StatelessWidget {
  final CoinRepositoryImpl repository;

  const MyApp({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
  supportedLocales: const [
    Locale('en'),
  ],
      debugShowCheckedModeBanner: false,
      title: 'Coin App',
      home: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => CoinListCubit(repository)..fetchInitial(),
          ),
          BlocProvider(
            create: (_) => SearchCubit(repository),
          ),
        ],
        child: CoinListPage(repository: repository),
      ),
    );
  }
}