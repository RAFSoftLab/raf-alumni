part of 'feed_page_bloc.dart';

abstract class FeedPageState extends Equatable {
  const FeedPageState();

  @override
  List<Object?> get props => [];
}

class FeedPageLoading extends FeedPageState {}

class FeedPageLoaded extends FeedPageState {
  const FeedPageLoaded({
    required this.posts,
  });

  final List<Post> posts;

  @override
  List<Object?> get props => [posts];
}
