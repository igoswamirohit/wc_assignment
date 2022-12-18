// ignore: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wc_assignment/data/models/user_model.dart';
import 'package:wc_assignment/repositories/user_repository.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc(UserRepository repository) : super(UserInitial()) {
    on<UserCreationRequested>((event, emit) async {
      try {
        emit(UserCreationProgress());
        final jsonData = event.userModel.toJson()
          ..remove('id')
          ..addAll({'createdAt': Timestamp.now()});
        final response = await repository.createUser(jsonData);
        emit(UserCreationSuccess(response));
      } on Exception catch (e) {
        emit(UserCreationFailure(e.toString()));
      }
    });

    on<UserUpdationRequested>((event, emit) async {
      try {
        emit(UserEditProgress());
        if (event.userData.id != null) {
          final jsonData = event.userData.toJson()
            ..remove('id')
            ..addAll({'updatedAt': Timestamp.now()});
          await repository.editUser(event.userData.id!, jsonData);
          emit(UserEditSuccess());
        } else {
          emit(UserEditFailure('Something went wrong!'));
        }
      } on Exception catch (e) {
        emit(UserEditFailure(e.toString()));
      }
    });

    on<UserDeletionRequested>((event, emit) async {
      try {
        emit(UserEditProgress());
        await repository.deleteUser(event.userId);
        emit(UserEditSuccess());
      } on Exception catch (e) {
        emit(UserEditFailure(e.toString()));
      }
    });

    on<UserImageUploadRequested>((event, emit) async {
      try {
        emit(UserImageUploadProgress());
        final imageUrl = await repository.uploadImage(event.path);
        repository.editUser(event.id, {'photo': imageUrl});
        emit(UserImageUploadSuccess(imageUrl));
      } on Exception catch (e) {
        emit(UserImageUploadFailure(e.toString()));
      }
    });
  }
}
