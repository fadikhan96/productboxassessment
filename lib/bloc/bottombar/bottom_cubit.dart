import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'bottom_state.dart';

class BottomNavCubit extends Cubit<int> {
  BottomNavCubit() : super(0);

  void changeTab(int index) {
    emit(index);
  }
}
