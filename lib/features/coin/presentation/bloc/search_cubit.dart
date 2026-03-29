import 'dart:async';
import 'package:coin_proj/features/coin/domain/entities/coin.dart';
import 'package:coin_proj/features/coin/domain/repositories/coin_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchState {
  final List<CoinEntity> coins;
  final bool isLoading;
  final String? error;

  SearchState({
    this.coins = const [],
    this.isLoading = false,
    this.error,
  });

  SearchState copyWith({
    List<CoinEntity>? coins,
    bool? isLoading,
    String? error,
  }) {
    return SearchState(
      coins: coins ?? this.coins,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class SearchCubit extends Cubit<SearchState> {
  final CoinRepository repository;

  SearchCubit(this.repository) : super(SearchState());

  Timer? _debounce;

  void search(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () async {
      await _fetch(query);
    });
  }

  Future<void> _fetch(String query) async {
    if (query.isEmpty) {
      emit(state.copyWith(coins: [], isLoading: false));
      return;
    }

    emit(state.copyWith(isLoading: true));

    try {
      final response = await repository.searchCoins(query, null, 10);

      emit(state.copyWith(
        isLoading: false,
        coins: response.coins,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
    }
  }
}
