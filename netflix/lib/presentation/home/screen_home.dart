import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:netflix/application/home/home_bloc.dart';
import 'package:netflix/presentation/home/widgets/number_title_card.dart';
import 'package:netflix/presentation/widgets/background_card.dart';
import 'package:netflix/presentation/widgets/main_title_card.dart';

import '../../core/constants.dart';

ValueNotifier<bool> scrollNotifier = ValueNotifier(true);

class ScreenHome extends StatelessWidget {
  const ScreenHome({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      BlocProvider.of<HomeBloc>(context).add(const GetHomeScreenData());
    });
    return Scaffold(
      body: ValueListenableBuilder(
        valueListenable: scrollNotifier,
        builder: (BuildContext context, index, _) {
          return NotificationListener<UserScrollNotification>(
            onNotification: (notification) {
              final ScrollDirection direction = notification.direction;
              if (direction == ScrollDirection.reverse) {
                scrollNotifier.value = false;
              } else if (direction == ScrollDirection.forward) {
                scrollNotifier.value = true;
              }
              return true;
            },
            child: Stack(
              children: [
                BlocBuilder<HomeBloc, HomeState>(
                  builder: (context, state) {
                    if (state.isLoading) {
                      return const Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      );
                    } else if (state.hasError) {
                      return const Center(
                          child: Text(
                        'Error while getting data',
                        style: TextStyle(color: Colors.white),
                      ));
                    }

                    final releasePastYear = state.pastYearMovieList.map(
                      (e) {
                        return '$imageAppendUrl${e.posterPath}';
                      },
                    ).toList();

                    final trending = state.trendingMovieList.map(
                      (e) {
                        return '$imageAppendUrl${e.posterPath}';
                      },
                    ).toList();

                    final tenseDrama = state.tenseDramasMovieList.map(
                      (e) {
                        return '$imageAppendUrl${e.posterPath}';
                      },
                    ).toList();

                    final southIndian = state.southIndianMovieList.map(
                      (e) {
                        return '$imageAppendUrl${e.posterPath}';
                      },
                    ).toList();

                    final top10TvShows = state.trendingTvList.map(
                      (e) {
                        return '$imageAppendUrl${e.posterPath}';
                      },
                    ).toList();
                    return ListView(
                      //padding: EdgeInsets.symmetric(horizontal: 10),
                      children: [
                        const BackgroundCard(),
                        kHeight10,
                        MainTitleCard(
                          title: 'Released in Past Year',
                          posterList: releasePastYear,
                        ),
                        kHeight,
                        MainTitleCard(
                          title: 'Trending Now',
                          posterList: trending,
                        ),
                        kHeight,
                        NumberTitleCard(
                          postersList: top10TvShows,
                        ),
                        kHeight,
                        MainTitleCard(
                          title: 'Tense Dramas',
                          posterList: tenseDrama,
                        ),
                        kHeight,
                        MainTitleCard(
                          title: 'South Indian Cinemas',
                          posterList: southIndian,
                        ),
                      ],
                    );
                  },
                ),
                scrollNotifier.value == true
                    ? Container(
                        width: double.infinity,
                        height: 90,
                        color: Colors.black.withOpacity(.5),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Image.network(
                                  "https://images.ctfassets.net/4cd45et68cgf/Rx83JoRDMkYNlMC9MKzcB/2b14d5a59fc3937afd3f03191e19502d/Netflix-Symbol.png",
                                  width: 60,
                                  height: 50,
                                ),
                                const Spacer(),
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
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  'TV Shows',
                                  style: kHomeTitleText,
                                ),
                                Text(
                                  "Movies",
                                  style: kHomeTitleText,
                                ),
                                Text(
                                  "Categories",
                                  style: kHomeTitleText,
                                )
                              ],
                            )
                          ],
                        ),
                      )
                    : kHeight
              ],
            ),
          );
        },
      ),
    );
  }
}
