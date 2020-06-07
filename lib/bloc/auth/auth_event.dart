import 'package:equatable/equatable.dart';
import 'dart:io';

abstract class AuthEvent extends Equatable {}

class InitialAuthEvent extends AuthEvent {
  @override
  List<Object> get props => [];
}

class SigninEvent extends AuthEvent {
  SigninEvent({this.email, this.password});
  final String email;
  final String password;

  List<Object> get props => throw UnimplementedError();
}

class SignupEvent extends AuthEvent {
  SignupEvent({this.email, this.password, this.firstName, this.lastName});
  final String email;
  final String password;
  final String firstName;
  final String lastName;

  List<Object> get props => throw UnimplementedError();
}

class SignoutEvent extends AuthEvent {
  @override
  List<Object> get props => throw UnimplementedError();
}

class ResetPasswordEvent extends AuthEvent {
  ResetPasswordEvent({this.email});
  String email;

  @override
  List<Object> get props => throw UnimplementedError();
}

class ChangeEmailEvent extends AuthEvent {
  ChangeEmailEvent({this.newEmail, this.password});
  final String newEmail;
  final String password;

  @override
  List<Object> get props => throw UnimplementedError();
}

class ChangePasswordEvent extends AuthEvent {
  ChangePasswordEvent({this.password, this.newPassword});
  final String password;
  final String newPassword;

  @override
  List<Object> get props => throw UnimplementedError();
}

class ChangeDetailsEvent extends AuthEvent {
  ChangeDetailsEvent({this.firstName, this.lastName});
  final String firstName;
  final String lastName;

  @override
  List<Object> get props => throw UnimplementedError();
}

class UploadDisplayPictureEvent extends AuthEvent {
  UploadDisplayPictureEvent({this.localFile});

  final File localFile;

  @override
  List<Object> get props => throw UnimplementedError();
}
