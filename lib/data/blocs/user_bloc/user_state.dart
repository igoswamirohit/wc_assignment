part of 'user_bloc.dart';

@immutable
abstract class UserState {}

class UserInitial extends UserState {}

// User Data Updation States
class UserEditProgress extends UserState {}

class UserEditSuccess extends UserState {}

class UserEditFailure extends UserState {
  UserEditFailure(String errorMessage);
}

// User Data Deletion States
class UserDeleteProgress extends UserState {}

class UserDeleteSuccess extends UserState {}

class UserDeleteFailure extends UserState {
  UserDeleteFailure(String errorMessage);
}

// User Data Creation States
class UserCreationProgress extends UserState {}

class UserCreationSuccess extends UserState {
  UserCreationSuccess(this.response);

  final DocumentReference<Object?> response;
}

class UserCreationFailure extends UserState {
  UserCreationFailure(this.errorMessage);

  final String errorMessage;
}

// User Image Upload States
class UserImageUploadProgress extends UserState {}

class UserImageUploadSuccess extends UserState {
  UserImageUploadSuccess(this.imageUrl);

  final String imageUrl;
}

class UserImageUploadFailure extends UserState {
  UserImageUploadFailure(this.errorMessage);

  final String errorMessage;
}
