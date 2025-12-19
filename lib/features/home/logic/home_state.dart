import 'package:docdoc/models/home_response_model.dart';
import 'package:equatable/equatable.dart';

abstract class HomeState extends Equatable {
  const HomeState();
  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeSuccess extends HomeState {
  final List<SpecializationData> homeData;
  final String userName;

  const HomeSuccess({required this.homeData, required this.userName});

  @override
  List<Object?> get props => [homeData];
}

class HomeError extends HomeState {
  final String error;

  const HomeError(this.error);

  @override
  List<Object?> get props => [error];
}
