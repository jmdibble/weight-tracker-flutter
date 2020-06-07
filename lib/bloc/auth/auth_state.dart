import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:weighttrackertwo/models/user_model.dart';

abstract class AuthState extends Equatable {}

class AuthInitialState extends AuthState {
  @override
  List<Object> get props => [];
}

class AuthorisedState extends AuthState {
  User user;
  AuthorisedState({this.user});

  @override
  List<Object> get props => [];
}

class UnauthorisedState extends AuthState {
  String message;
  UnauthorisedState({this.message});

  @override
  List<Object> get props => [];
}

class AuthLoadingState extends AuthState {
  @override
  List<Object> get props => [];
}

//class AuthFailState extends AuthState {
//  String message;
//  AuthFailState(this.message);
//
//  @override
//  List<Object> get props => [];
//}

//class ResetPasswordState extends AuthState {
//  @override
//  List<Object> get props => [];
//}
