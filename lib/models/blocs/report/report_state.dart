part of 'report_cubit.dart';

// ReportState is the base class for all report-related states.
abstract class ReportState extends Equatable {
  const ReportState();

  @override
  List<Object> get props => [];
}

// Initial state when no action has been taken.
class ReportInitial extends ReportState {}

// State emitted when a report-related operation is in progress.
class ReportLoading extends ReportState {}

// State emitted when a report-related operation is successful.
class ReportSuccess extends ReportState {}

// State emitted when a report-related operation fails.
class ReportFailure extends ReportState {
  final String error;

  const ReportFailure({required this.error});

  @override
  List<Object> get props => [error];
}

// State emitted when reports are successfully loaded.
class ReportsLoaded extends ReportState {
  final List<dynamic> reports;

  const ReportsLoaded({required this.reports});

  @override
  List<Object> get props => [reports];
}
