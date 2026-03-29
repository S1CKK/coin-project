import 'package:coin_proj/features/coin/domain/entities/coin.dart';
import 'package:coin_proj/features/coin/domain/repositories/coin_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CoinListState {
  final List<CoinEntity> coins;
  final bool isLoading;
  final bool isLoadingMore;
  final bool hasReachedMax;
  final String? error;
  final String? nextCursor;

  CoinListState({
    this.coins = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.hasReachedMax = false,
    this.error,
    this.nextCursor,
  });

  CoinListState copyWith({
    List<CoinEntity>? coins,
    bool? isLoading,
    bool? isLoadingMore,
    bool? hasReachedMax,
    String? error,
    String? nextCursor,
  }) {
    return CoinListState(
      coins: coins ?? this.coins,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      error: error,
      nextCursor: nextCursor ?? this.nextCursor,
    );
  }
}

class CoinListCubit extends Cubit<CoinListState> {
  final CoinRepository repository;

  CoinListCubit(this.repository) : super(CoinListState());

  Future<void> fetchInitial() async {
    emit(state.copyWith(isLoading: true, error: null));

    try {
      final response = await repository.getCoins(null, 10);

      emit(state.copyWith(
        isLoading: false,
        coins: response.coins, 
        nextCursor: response.nextCursor, 
        hasReachedMax: !response.hasNextPage, 
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: e.toString().replaceAll('Exception: ', ''),
      ));
    }
  }

  Future<void> fetchMore() async {
    if (state.isLoadingMore || state.hasReachedMax) return;

    emit(state.copyWith(isLoadingMore: true));

    try {
      final response = await repository.getCoins(state.nextCursor, 10);

      emit(state.copyWith(
        coins: [...state.coins, ...response.coins],
        isLoadingMore: false,
        nextCursor: response.nextCursor,
        hasReachedMax: !response.hasNextPage,
      ));
    } catch (e) {
      emit(state.copyWith(isLoadingMore: false));
    }
  }

  Future<void> refresh() async {
    try {
      final response = await repository.getCoins(null, 10);

      emit(state.copyWith(
        coins: response.coins,
        nextCursor: response.nextCursor,
        hasReachedMax: !response.hasNextPage,
      ));
    } catch (e) {
      emit(state.copyWith(error: 'Refresh failed'));
    }
  }
}
