part of 'link_cubit.dart';

// LinkState is the base class for all link-related states.
abstract class LinkState extends Equatable {
  const LinkState();

  @override
  List<Object> get props => [];
}

// Initial state when no action has been taken.
class LinkInitial extends LinkState {}

// State emitted when a link-related operation is in progress.
class LinkLoading extends LinkState {}

// State emitted when a link check operation is successful.
class LinkSuccess extends LinkState {
  final String url;
  final String category;
  final int trueVotes;
  final int wrongVotes;
  final String submissionDate;

  const LinkSuccess({
    required this.url,
    required this.category,
    required this.trueVotes,
    required this.wrongVotes,
    required this.submissionDate,
  });

  @override
  List<Object> get props =>
      [url, category, trueVotes, wrongVotes, submissionDate];
}

// State emitted when a link-related operation fails.
class LinkFailure extends LinkState {
  final String error;

  const LinkFailure({required this.error});

  @override
  List<Object> get props => [error];
}

// State emitted when a link is successfully added.
class LinkSuccessadd extends LinkState {
  final String url;
  final String category;

  const LinkSuccessadd({required this.url, required this.category});

  @override
  List<Object> get props => [url, category];
}

// State emitted when a link is not found.
class LinkNotFound extends LinkState {
  final String url;

  const LinkNotFound({required this.url});

  @override
  List<Object> get props => [url];
}
