import 'package:flutter_bloc/flutter_bloc.dart';

class NavigationCubit extends Cubit<int> {
  // Initial state is 0 (Home Tab)
  NavigationCubit() : super(0);

  // We have 5 items in the bottom bar (0, 1, 2, 3, 4)
  final int maxIndex = 4;

  void changeIndex(int index) {
    // strict check to prevent crashes if an invalid index is passed
    if (index < 0 || index > maxIndex) return;

    emit(index);
  }
}