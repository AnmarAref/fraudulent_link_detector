part of 'admin_cubit.dart';

// AdminState is the base class for all admin-related states.
abstract class AdminState extends Equatable {
  const AdminState();

  @override
  List<Object> get props => [];
}

// Initial state when no action has been taken.
class AdminInitial extends AdminState {}

// State emitted when an admin-related operation is in progress.
class AdminLoading extends AdminState {}

// State emitted when an admin-related operation is successful.
class AdminSuccess extends AdminState {
  final String message;

  const AdminSuccess({required this.message});

  @override
  List<Object> get props => [message];
}

// State emitted when an admin-related operation fails.
class AdminFailure extends AdminState {
  final String error;

  const AdminFailure({required this.error});

  @override
  List<Object> get props => [error];
}

// State emitted when admin requests are successfully loaded.
class AdminRequestsLoaded extends AdminState {
  final List<ApprovalRequestModel> requests;

  const AdminRequestsLoaded({required this.requests});

  @override
  List<Object> get props => [requests];
}
