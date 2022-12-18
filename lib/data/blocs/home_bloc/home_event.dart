part of 'home_bloc.dart';

@immutable
abstract class HomeEvent {}

class UserListRequested extends HomeEvent with EquatableMixin {
  @override
  List<Object> get props => [];
}