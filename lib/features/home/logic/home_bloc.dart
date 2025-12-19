import 'package:docdoc/features/home/data/repository/home_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:docdoc/features/home/logic/home_state.dart';
import 'package:docdoc/features/home/logic/home_event.dart';
import 'package:docdoc/core/services/secure_storage_service.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepository _homeRepository;
  final SecureStorageService _storageService = SecureStorageService();

  HomeBloc(this._homeRepository) : super( HomeInitial()) {
    on<FetchHomeDataEvent>(_onFetchHomeData);
  }

  Future<void> _onFetchHomeData(
      FetchHomeDataEvent event,
      Emitter<HomeState> emit,
      ) async {
    emit(HomeLoading());
    try {
      final userName = await _storageService.getUserName() ?? "User";

      final response = await _homeRepository.getHomeData();

      if (response.status == true) {
        emit(HomeSuccess(
          homeData: response.data,
          userName: userName,
        ));
      } else {
        emit(HomeError(response.message));
      }

    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }
}