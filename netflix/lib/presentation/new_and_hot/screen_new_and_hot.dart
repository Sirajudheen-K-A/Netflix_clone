import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:netflix/application/hot_and_new/hot_and_new_bloc.dart';
import 'package:netflix/core/colors/colors.dart';
import 'package:netflix/core/constants.dart';

import 'widgets/coming_soon_widgets.dart';
import 'widgets/eveyones_watching_widget.dart';

class ScreenNewAndHot extends StatelessWidget {
  const ScreenNewAndHot({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(80),
            child: AppBar(
              title: const Text(
                'New & Hot',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                ),
              ),
              actions: [
                const Icon(
                  Icons.cast,
                  color: Colors.white,
                  size: 30,
                ),
                kWidth,
                Container(
                  width: 30,
                  height: 30,
                  color: Colors.blue,
                ),
              ],
              bottom: TabBar(
                  isScrollable: true,
                  labelColor: kBlackColor,
                  unselectedLabelColor: kWhiteColor,
                  labelStyle: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                  indicator: BoxDecoration(
                    color: kWhiteColor,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  tabs: const [
                    Tab(text: '🍿 Coming Soon'),
                    Tab(text: "👀 Everyone's watching"),
                  ]),
            ),
          ),
          body: const TabBarView(children: [
            ComingSoonList(
              key: Key('coming soon'),
            ),
            EveryonesWatchingList(
              key: Key('Everyone\'s watching'),
            )
          ])),
    );
  }
}

class ComingSoonList extends StatelessWidget {
  const ComingSoonList({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        BlocProvider.of<HotAndNewBloc>(context)
            .add(const LoadDataInComingSoon());
      },
    );
    return RefreshIndicator(
      onRefresh: () async {
        BlocProvider.of<HotAndNewBloc>(context)
            .add(const LoadDataInComingSoon());
      },
      child: BlocBuilder<HotAndNewBloc, HotAndNewState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(
                child: CircularProgressIndicator(
              strokeWidth: 2,
            ));
          } else if (state.hasError) {
            return const Center(
              child: Text('Error while loading coming soon list'),
            );
          } else if (state.comingSoonList.isEmpty) {
            return const Center(
              child: Text('Coming soon list is empty'),
            );
          } else {
            return ListView.builder(
              //shrinkWrap: true,
              padding: const EdgeInsets.only(top: 10),
              itemCount: state.comingSoonList.length,
              itemBuilder: (BuildContext context, int index) {
                final movie = state.comingSoonList[index];
                if (movie.id == null) {
                  return const SizedBox();
                }

                final _date = DateTime.parse(movie.releaseDate!);
                final formatedDate = DateFormat.yMMMMd('en_US').format(_date);
                return ComingSoonWidget(
                  id: movie.id.toString(),
                  month: formatedDate
                      .split(' ')
                      .first
                      .substring(0, 3)
                      .toUpperCase(),
                  day: movie.releaseDate!.split('-')[2],
                  posterPath: '$imageAppendUrl${movie.posterPath}',
                  movieName: movie.originalTitle ?? 'No title',
                  description: movie.overview ?? 'No description',
                );
              },
            );
          }
        },
      ),
    );
  }
}

class EveryonesWatchingList extends StatelessWidget {
  const EveryonesWatchingList({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        BlocProvider.of<HotAndNewBloc>(context)
            .add(const LoadDataInEveryonesWatching());
      },
    );
    return RefreshIndicator(
      onRefresh: () async {
        BlocProvider.of<HotAndNewBloc>(context)
            .add(const LoadDataInEveryonesWatching());
      },
      child: BlocBuilder<HotAndNewBloc, HotAndNewState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(
                child: CircularProgressIndicator(
              strokeWidth: 2,
            ));
          } else if (state.hasError) {
            return const Center(
              child: Text('Error while loading Everyone\'s watching list'),
            );
          } else if (state.everyOnesWatchingList.isEmpty) {
            return const Center(
              child: Text('Everyone\'s watching list is empty'),
            );
          } else {
            return ListView.builder(
              //shrinkWrap: true,
              padding: const EdgeInsets.all(10),
              itemCount: state.everyOnesWatchingList.length,
              itemBuilder: (BuildContext context, int index) {
                final tv = state.everyOnesWatchingList[index];
                if (tv.id == null) {
                  return const SizedBox();
                }

                return EveryonesWatchingWidgets(
                  posterPath: '$imageAppendUrl${tv.posterPath}',
                  movieName: tv.originalName ?? 'No Name',
                  description: tv.overview ?? 'No Description',
                );
              },
            );
          }
        },
      ),
    );
  }
}
