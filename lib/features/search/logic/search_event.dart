import 'package:docdoc/models/doctor_filter_model.dart';
import 'package:equatable/equatable.dart';


abstract class SearchEvent extends Equatable{
  const SearchEvent();
  @override
  List<Object?> get props => [];
}

class FetchSearchEvent extends SearchEvent{
  final String query;
  final DoctorFilterModel filters;
  const FetchSearchEvent({required this.query,
    required this.filters,});
  @override
  List<Object?> get props => [query,filters];
}