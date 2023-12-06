import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:netflix/domain/core/failures/main_failure.dart';
import 'package:netflix/domain/downloads/i_downloads_repo.dart';
import 'package:netflix/domain/downloads/models/downloads.dart';
import 'package:netflix/domain/search/model/search_resp/search_resp.dart';
import 'package:netflix/domain/search/search_service.dart';

part 'search_event.dart';
part 'search_state.dart';
part 'search_bloc.freezed.dart';

@injectable
class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final IDownloadsRepo _downloadsServices;
  final SearchService _searchService;
  SearchBloc(this._downloadsServices, this._searchService)
      : super(SearchState.initial()) {
    on<Initialize>((event, emit) async {
      if (state.idealList.isNotEmpty) {
        emit(SearchState(
          searchResultList: [],
          idealList: state.idealList,
          isLoadiing: false,
          isError: false,
        ));
        return;
      }
      emit(const SearchState(
        searchResultList: [],
        idealList: [],
        isLoadiing: true,
        isError: false,
      ));
      final _result = await _downloadsServices.getDownloadsImage();
      final _state = _result.fold(
        (MainFailure f) {
          return const SearchState(
            searchResultList: [],
            idealList: [],
            isLoadiing: false,
            isError: true,
          );
        },
        (List<Downloads> list) {
          return SearchState(
            searchResultList: [],
            idealList: list,
            isLoadiing: false,
            isError: false,
          );
        },
      );
      emit(_state);
    });

    on<SearchMovie>((event, emit) async {
      //log('Searching for ${event.movieQuery}');
      emit(const SearchState(
        searchResultList: [],
        idealList: [],
        isLoadiing: true,
        isError: false,
      ));
      final _result =
          await _searchService.searchMovies(movieQuery: event.movieQuery);
      final _state = _result.fold(
        (MainFailure f) {
          return const SearchState(
            searchResultList: [],
            idealList: [],
            isLoadiing: false,
            isError: true,
          );
        },
        (SearchResp r) {
          return SearchState(
            searchResultList: r.results,
            idealList: [],
            isLoadiing: false,
            isError: false,
          );
        },
      );
      emit(_state);
    });
  }
}
