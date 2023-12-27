part of 'feed_page_bloc.dart';

abstract class FeedPageEvent extends Equatable {
  const FeedPageEvent();

  @override
  List<Object?> get props => [];
}

class FeedPageInit extends FeedPageEvent {}
