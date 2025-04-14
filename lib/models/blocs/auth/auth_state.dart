part of 'auth_cubit.dart';

// AuthState is the base class for all authentication-related states.
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

// Initial state when no action has been taken.
class AuthInitial extends AuthState {}

// State emitted when an authentication-related operation is in progress.
class AuthLoading extends AuthState {}

// State emitted when an authentication-related operation is successful.
class AuthSuccess extends AuthState {
  final String role;

  const AuthSuccess({required this.role});

  @override
  List<Object> get props => [role];
}

// State emitted when a signup operation is successful.
class SignupSuccess extends AuthState {}

// State emitted when an authentication-related operation fails.
class AuthFailure extends AuthState {
  final String error;

  const AuthFailure({required this.error});

  @override
  List<Object> get props => [error];
}
// part of 'auth_cubit.dart';

// // AuthState is the base class for all authentication-related states.
// abstract class AuthState extends Equatable {
//   const AuthState();

//   @override
//   List<Object> get props => [];
// }

// // Initial state when no action has been taken.
// class AuthInitial extends AuthState {}

// // State emitted when an authentication-related operation is in progress.
// class AuthLoading extends AuthState {}

// // State emitted when an authentication-related operation is successful.
// class AuthSuccess extends AuthState {
//   final String role;
//   final bool navigateToProxyInstructions;

//   const AuthSuccess({
//     required this.role,
//     this.navigateToProxyInstructions = false,
//   });

//   @override
//   List<Object> get props => [role, navigateToProxyInstructions];
// }

// // State emitted when a signup operation is successful.
// class SignupSuccess extends AuthState {}

// // State emitted when an authentication-related operation fails.
// class AuthFailure extends AuthState {
//   final String error;

//   const AuthFailure({required this.error});

//   @override
//   List<Object> get props => [error];
// }
