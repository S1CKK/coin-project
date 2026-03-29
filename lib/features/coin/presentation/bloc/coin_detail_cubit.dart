
import 'package:coin_proj/features/coin/domain/entities/coin_detail_entity.dart';
import 'package:coin_proj/features/coin/domain/repositories/coin_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum CoinDetailStatus { initial, loading, success, failure }

class CoinDetailState {
  final CoinDetailStatus status;
  final CoinDetailEntity? coin;
  final String? errorMessage;

  const CoinDetailState({
    this.status = CoinDetailStatus.initial,
    this.coin,
    this.errorMessage,
  });

  CoinDetailState copyWith({
    CoinDetailStatus? status,
    CoinDetailEntity? coin,
    String? errorMessage,
  }) {
    return CoinDetailState(
      status: status ?? this.status,
      coin: coin ?? this.coin,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}


class CoinDetailCubit extends Cubit<CoinDetailState> {
  final CoinRepository repository;

  CoinDetailCubit(this.repository) : super(const CoinDetailState());

  Future<void> getCoinDetail(String uuid) async {
    emit(state.copyWith(status: CoinDetailStatus.loading));

    try {
      final detail = await repository.getCoinDetail(uuid);
      emit(state.copyWith(
        status: CoinDetailStatus.success,
        coin: detail,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: CoinDetailStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  void clearDetail() {
    emit(const CoinDetailState());
  }
}