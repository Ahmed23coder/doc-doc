import 'package:docdoc/models/doctor_model.dart';
import 'package:equatable/equatable.dart';


abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object?> get props => [];
}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchSuccess extends SearchState {
  final List<DoctorModel> doctors;

  const SearchSuccess({required this.doctors});
  @override
  List<Object?> get props => [doctors];
}

class SearchError extends SearchState {
  final String error;

  const SearchError(this.error);

  @override
  List<Object?> get props => [error];
}
