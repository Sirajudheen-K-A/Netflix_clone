import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:netflix/domain/core/failures/main_failure.dart';
import 'package:netflix/domain/hot_and_new_resp/hot_and_new_service.dart';
import 'package:netflix/domain/hot_and_new_resp/model/hot_and_new_resp.dart';

part 'hot_and_new_event.dart';
part 'hot_and_new_state.dart';
part 'hot_and_new_bloc.freezed.dart';

@injectable
class HotAndNewBloc extends Bloc<HotAndNewEvent, HotAndNewState> {
  final HotAndNewService _hotAndNewService;
  HotAndNewBloc(this._hotAndNewService) : super(HotAndNewState.initial()) {
    on<LoadDataInComingSoon>((event, emit) async {
      emit(
        const HotAndNewState(
            comingSoonList: [],
            everyOnesWatchingList: [],
            isLoading: true,
            hasError: false),
      );

      final _result = await _hotAndNewService.getHotAndNewMovieData();
      final newState = _result.fold(
        (MainFailure failure) {
          return const HotAndNewState(
            comingSoonList: [],
            everyOnesWatchingList: [],
            isLoading: false,
            hasError: true,
          );
        },
        (HotAndNewResp resp) {
          return HotAndNewState(
            comingSoonList: resp.results!,
            everyOnesWatchingList: state.everyOnesWatchingList,
            isLoading: false,
            hasError: false,
          );
        },
      );
      emit(newState);
    });

    on<LoadDataInEveryonesWatching>((event, emit) async {
      emit(
        const HotAndNewState(
            comingSoonList: [],
            everyOnesWatchingList: [],
            isLoading: true,
            hasError: false),
      );

      final _result = await _hotAndNewService.getHotAndNewTvData();
      final newState = _result.fold(
        (MainFailure failure) {
          return const HotAndNewState(
            comingSoonList: [],
            everyOnesWatchingList: [],
            isLoading: false,
            hasError: true,
          );
        },
        (HotAndNewResp resp) {
          return HotAndNewState(
            comingSoonList: state.comingSoonList,
            everyOnesWatchingList: resp.results!,
            isLoading: false,
            hasError: false,
          );
        },
      );
      emit(newState);
    });
  }
}
