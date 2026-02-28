import 'package:bloc_test/bloc_test.dart';
import 'package:docdoc/core/services/secure_storage_service.dart';
import 'package:docdoc/features/home/data/repository/home_repository.dart';
import 'package:docdoc/features/home/logic/home_bloc.dart';
import 'package:docdoc/features/home/logic/home_event.dart';
import 'package:docdoc/features/home/logic/home_state.dart';
import 'package:docdoc/models/home_response_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'home_bloc_test.mocks.dart';

@GenerateMocks([HomeRepository, SecureStorageService])
void main() {
  late MockHomeRepository mockHomeRepository;
  late MockSecureStorageService mockSecureStorageService;
  late HomeBloc homeBloc;

  setUp(() {
    mockHomeRepository = MockHomeRepository();
    mockSecureStorageService = MockSecureStorageService();
    homeBloc = HomeBloc(
      mockHomeRepository,
      storageService: mockSecureStorageService,
    );
  });

  tearDown(() {
    homeBloc.close();
  });

  group('HomeBloc', () {
    test('initial state is HomeInitial', () {
      expect(homeBloc.state, isA<HomeInitial>());
    });

    blocTest<HomeBloc, HomeState>(
      'emits [HomeLoading, HomeSuccess] when FetchHomeDataEvent is added and fetch is successful',
      build: () {
        when(mockSecureStorageService.getUserName())
            .thenAnswer((_) async => 'Test User');

        final mockData = HomeDataResponse(
          message: 'Success',
          data: [],
          status: true,
          code: 200,
        );
        when(mockHomeRepository.getHomeData())
            .thenAnswer((_) async => mockData);

        return homeBloc;
      },
      act: (bloc) => bloc.add(const FetchHomeDataEvent()),
      expect: () => [
        isA<HomeLoading>(),
        isA<HomeSuccess>()
            .having((s) => s.userName, 'userName', 'Test User')
            .having((s) => s.homeData, 'homeData', isEmpty),
      ],
    );

    blocTest<HomeBloc, HomeState>(
      'emits [HomeLoading, HomeSuccess] with default user when getUserName returns null',
      build: () {
        when(mockSecureStorageService.getUserName())
            .thenAnswer((_) async => null);

        final mockData = HomeDataResponse(
          message: 'Success',
          data: [],
          status: true,
          code: 200,
        );
        when(mockHomeRepository.getHomeData())
            .thenAnswer((_) async => mockData);

        return homeBloc;
      },
      act: (bloc) => bloc.add(const FetchHomeDataEvent()),
      expect: () => [
        isA<HomeLoading>(),
        isA<HomeSuccess>()
            .having((s) => s.userName, 'userName', 'User')
            .having((s) => s.homeData, 'homeData', isEmpty),
      ],
    );

    blocTest<HomeBloc, HomeState>(
      'emits [HomeLoading, HomeError] when FetchHomeDataEvent is added and fetch returns false status',
      build: () {
        when(mockSecureStorageService.getUserName())
            .thenAnswer((_) async => 'Test User');

        final mockData = HomeDataResponse(
          message: 'Error message',
          data: [],
          status: false,
          code: 400,
        );
        when(mockHomeRepository.getHomeData())
            .thenAnswer((_) async => mockData);

        return homeBloc;
      },
      act: (bloc) => bloc.add(const FetchHomeDataEvent()),
      expect: () => [
        isA<HomeLoading>(),
        isA<HomeError>().having((e) => e.error, 'error', 'Error message'),
      ],
    );

    blocTest<HomeBloc, HomeState>(
      'emits [HomeLoading, HomeError] when FetchHomeDataEvent is added and fetch throws exception',
      build: () {
        when(mockSecureStorageService.getUserName())
            .thenAnswer((_) async => 'Test User');

        when(mockHomeRepository.getHomeData())
            .thenThrow(Exception('Network Error'));

        return homeBloc;
      },
      act: (bloc) => bloc.add(const FetchHomeDataEvent()),
      expect: () => [
        isA<HomeLoading>(),
        isA<HomeError>().having((e) => e.error, 'error', 'Exception: Network Error'),
      ],
    );
  });
}
