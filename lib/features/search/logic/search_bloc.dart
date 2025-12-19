import 'package:bloc/bloc.dart';
import 'package:docdoc/features/search/data/repository/search_repository.dart';
import 'package:docdoc/features/search/logic/search_event.dart';
import 'package:docdoc/features/search/logic/search_state.dart';

class SearchBloc extends Bloc <SearchEvent, SearchState>{
  final SearchRepository _searchRepository;

SearchBloc (this._searchRepository) : super (SearchInitial()){
  on <FetchSearchEvent>(_onFetchSearch);
}

Future<void> _onFetchSearch(
    FetchSearchEvent event,
    Emitter<SearchState> emit,
    )async {
  emit (SearchLoading());

  try{
    final response = await _searchRepository.getSearchData(query: event.query,
        filters: event.filters,);

    emit (SearchSuccess(doctors: response.data));
  }catch (e){
    emit(SearchError(e.toString()));
  }
}


}