part of 'user_bloc.dart';

@immutable
abstract class UserEvent {}

class UserCreationRequested extends UserEvent {
  UserCreationRequested(this.userModel);

  final UserModel userModel;
}

class UserUpdationRequested extends UserEvent {
  UserUpdationRequested(this.userData);

  final UserModel userData;
}

class UserDeletionRequested extends UserEvent {
  UserDeletionRequested(this.userId);

  final String userId;
}

class UserImageUploadRequested extends UserEvent {
  UserImageUploadRequested(this.id, this.path);

  final String path;
  final String id;
}
