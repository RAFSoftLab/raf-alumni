import 'dart:async';

import 'package:alumni_network/api/alumni_network_service.dart';
import 'package:alumni_network/models/post.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'feed_page_event.dart';
part 'feed_page_state.dart';

class FeedPageBloc extends Bloc<FeedPageEvent, FeedPageState> {
  FeedPageBloc({required this.service}) : super(FeedPageLoading()) {
    on<FeedPageInit>((event, emit) async {
      emit(FeedPageLoading());
      try {
        final posts = await service.getPosts();
        emit(FeedPageLoaded(posts: posts));
      } catch (e) {
        print(e);
      }
    });
  }

  final AlumniNetworkService service;
}
