import 'package:coin_proj/features/coin/domain/entities/coin.dart';
import 'package:coin_proj/features/coin/domain/repositories/coin_repository.dart';
import 'package:coin_proj/features/coin/presentation/bloc/coin_detail_cubit.dart';
import 'package:coin_proj/features/coin/presentation/bloc/coin_list_cubit.dart';
import 'package:coin_proj/features/coin/presentation/bloc/search_cubit.dart';
import 'package:coin_proj/features/coin/presentation/widgets/coin_item.dart';
import 'package:coin_proj/features/coin/presentation/widgets/detail_view.dart';
import 'package:coin_proj/features/coin/presentation/widgets/invite_item.dart';
import 'package:coin_proj/features/coin/presentation/widgets/top3_section.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CoinListPage extends StatefulWidget {
  final CoinRepository repository;

  const CoinListPage({super.key, required this.repository});

  @override
  State<CoinListPage> createState() => _CoinListPageState();
}

class _CoinListPageState extends State<CoinListPage> {
  final ScrollController _controller = ScrollController();
  String _query = '';

  bool isInviteIndex(int index) {
    int pos = 5;

    while (pos <= index + 1) {
      if (pos == index + 1) return true;
      pos *= 2;
    }

    return false;
  }

  int _inviteCount(int length) {
    int count = 0;
    int pos = 5;

    while (pos <= length + count) {
      count++;
      pos *= 2;
    }

    return count;
  }

  int _getRealIndex(int index) {
    int inviteSeen = 0;
    int pos = 5;

    for (int i = 0; i <= index; i++) {
      if (i + 1 == pos) {
        inviteSeen++;
        pos *= 2;
      }
    }

    return index - inviteSeen;
  }

  void showCoinDetailBottomSheet(
    BuildContext context,
    CoinEntity coin,
    CoinRepository repository,
  ) async {
    FocusManager.instance.primaryFocus?.unfocus();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 50),
          child: Wrap(children: [
            BlocProvider(
              create: (_) =>
                  CoinDetailCubit(repository)..getCoinDetail(coin.uuid),
              child: CoinDetailView(coinEntity: coin),
            ),
          ]),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();

    context.read<CoinListCubit>().fetchInitial();

    _controller.addListener(() {
      if (_controller.position.pixels >=
          _controller.position.maxScrollExtent - 200) {
        context.read<CoinListCubit>().fetchMore();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    await context.read<CoinListCubit>().refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: CupertinoSearchTextField(
            placeholder: AppLocalizations.of(context)!.search,
            onChanged: (value) {
              setState(() {
                _query = value;
              });

              context.read<SearchCubit>().search(value);
            },
          )),
      body: SafeArea(
        child: _query.isEmpty
            ? BlocBuilder<CoinListCubit, CoinListState>(
                builder: (context, state) {
                  if (state.isLoading && state.coins.isEmpty) {
                    return const Center(child: CupertinoActivityIndicator());
                  }

                  if (state.error != null && state.coins.isEmpty) {
                    return _buildError();
                  }

                  return _buildList(state);
                },
              )
            : BlocBuilder<SearchCubit, SearchState>(
                builder: (context, state) {
                  if (state.isLoading) {
                    return const Center(child: CupertinoActivityIndicator());
                  }

                  if (state.error != null) {
                    return  Center(child: Text(AppLocalizations.of(context)!.somethingWrong,));
                  }

                  return _buildSearchList(state);
                },
              ),
      ),
    );
  }

  Widget _buildSearchList(SearchState state) {
    if (state.coins.isEmpty) {
      return const Center(
        child: Text(
          'No coins found',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      itemCount: state.coins.length + _inviteCount(state.coins.length),
      itemBuilder: (context, index) {
        if (isInviteIndex(index)) {
          return const InviteItem();
        }

        final coinIndex = _getRealIndex(index);

        final coin = state.coins[coinIndex];

        return CoinItem(
          coin: coin,
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
            showCoinDetailBottomSheet(
              context,
              coin,
              widget.repository,
            );
          },
        );
      },
    );
  }

  Widget _buildError() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
           Text(
            AppLocalizations.of(context)!.somethingWrong,
            style: const TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: () {
              context.read<CoinListCubit>().fetchInitial();
            },
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  Widget _buildList(CoinListState state) {
    final top3 = state.coins
        .where((coin) => coin.rank == 1 || coin.rank == 2 || coin.rank == 3)
        .toList();
    final others = state.coins
        .where((coin) => coin.rank != 1 && coin.rank != 2 && coin.rank != 3)
        .toList();

    return CustomScrollView(
      controller: _controller,
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      slivers: [
        CupertinoSliverRefreshControl(
          onRefresh: _onRefresh,
        ),
        SliverToBoxAdapter(
          child: Top3Section(coins: top3),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              if (isInviteIndex(index)) {
                return const InviteItem();
              }

              final coinIndex = _getRealIndex(index);

              if (coinIndex < others.length) {
                final coin = others[coinIndex];

                return CoinItem(
                  coin: coin,
                  onTap: () {
                    showCoinDetailBottomSheet(
                      context,
                      coin,
                      widget.repository,
                    );
                  },
                );
              }

              if (state.isLoadingMore) {
                return const Padding(
                  padding: EdgeInsets.all(32),
                  child: Center(child: CupertinoActivityIndicator()),
                );
              }
              

              return const SizedBox(height: 50);
            },
            childCount: others.length + _inviteCount(others.length),
          ),
        ),
      ],
    );
  }
}
