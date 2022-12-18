part of 'home_bloc.dart';

@immutable
abstract class HomeState {}

class HomeInitial extends HomeState {}

class UserFetchProgress extends HomeState {}

class UserFetchSuccess extends HomeState {
  final Stream<QuerySnapshot<Map<String, dynamic>>> usersStream;
  UserFetchSuccess(this.usersStream);
}

class UserFetchFailure extends HomeState {
  final String errorMessage;
  UserFetchFailure(this.errorMessage);
}
