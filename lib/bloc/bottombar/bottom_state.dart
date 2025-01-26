part of 'bottom_cubit.dart';

class BottomBarState extends Equatable {
  final int selectedIndex;

  const BottomBarState(this.selectedIndex);

  @override
  List<Object?> get props => [selectedIndex];
}
