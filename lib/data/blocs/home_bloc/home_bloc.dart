// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../repositories/user_repository.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc(UserRepository repository) : super(HomeInitial()) {
    on<UserListRequested>((event, emit) async {
      try {
        emit(UserFetchProgress());
        final stream = repository.fetchUsers();
        emit(UserFetchSuccess(stream));
      } on Exception catch (e) {
        emit(UserFetchFailure(e.toString()));
      }
    });
  }
}
