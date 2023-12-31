part of 'search_bloc.dart';

@freezed
class SearchState with _$SearchState {
  const factory SearchState({
    required List<SearchResultData> searchResultList,
    required List<Downloads> idealList,
    required bool isLoadiing,
    required bool isError,
  }) = _SearchState;

  factory SearchState.initial() => const SearchState(
        searchResultList: [],
        idealList: [],
        isLoadiing: false,
        isError: false,
      );
}
