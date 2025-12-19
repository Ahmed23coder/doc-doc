import 'package:flutter_bloc/flutter_bloc.dart';

class NavigationCubit extends Cubit<int> {

  NavigationCubit() : super(0);


  final int maxIndex = 4;

  void changeIndex(int index) {

    if (index < 0 || index > maxIndex) return;

    emit(index);
  }
}