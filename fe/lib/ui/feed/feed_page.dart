import 'package:alumni_network/api/alumni_network_service.dart';
import 'package:alumni_network/api/initializer.dart';
import 'package:alumni_network/ui/feed/bloc/feed_page_bloc.dart';
import 'package:alumni_network/ui/students/student_profile/bloc/student_profile_bloc.dart';
import 'package:alumni_network/ui/students/student_profile/student_profile_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class FeedPage extends StatelessWidget {
  const FeedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Alumni Mreža'),
      ),
      body: BlocBuilder<FeedPageBloc, FeedPageState>(
        builder: (context, state) {
          if (state is FeedPageLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is FeedPageLoaded)
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
              child: ListView.builder(
                itemCount: state.posts.length,
                itemBuilder: (context, index) {
                  final post = state.posts[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(post.title, style: Theme.of(context).textTheme.headline6),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: const Divider(indent: 128, endIndent: 128,),
                                ),
                                Text(post.text),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: const Divider(),
                                ),
                                InkWell(
                                  onTap: () => Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => BlocProvider<StudentProfileBloc>(
                                        create: (context) => StudentProfileBloc(
                                          alumniUserId: post.user.id,
                                          service: getService<AlumniNetworkService>(),
                                        )..add(StudentProfileInit(alumniUser: post.user)),
                                        child: const StudentProfilePage(),
                                      ),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        backgroundImage: post.user.profileImageUrl != null
                                            ? CachedNetworkImageProvider(post.user.profileImageUrl!)
                                            : null,
                                        child: post.user.profileImageUrl == null ? Icon(Icons.person) : null,
                                      ),
                                      const SizedBox(width: 16),
                                      Flexible(
                                        child: Text(
                                          'Postavio ${post.user.fullName} datuma ${DateFormat.yMMMd('sr').format(post.createdAt)}',
                                          style: TextStyle(fontSize: 14),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: const Divider(),
                                ),
                                Text('Komentari:', style: Theme.of(context).textTheme.subtitle1),
                                Padding(
                                  padding: EdgeInsets.only(left: 0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      ...post.comments.map((comment) => Container(
                                        child: ListTile(
                                          onTap: () => Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) => BlocProvider<StudentProfileBloc>(
                                                create: (context) => StudentProfileBloc(
                                                  alumniUserId: comment.user.id,
                                                  service: getService<AlumniNetworkService>(),
                                                )..add(StudentProfileInit(alumniUser: comment.user)),
                                                child: const StudentProfilePage(),
                                              ),
                                            ),
                                          ),
                                          contentPadding: EdgeInsets.zero,
                                          title: Text(comment.text),
                                          subtitle: Text('Postavio ${comment.user.fullName} datuma ${DateFormat.yMMMd('sr').format(comment.createdAt)}'),
                                          leading: CircleAvatar(
                                            backgroundImage: comment.user.profileImageUrl != null
                                                ? CachedNetworkImageProvider(comment.user.profileImageUrl!)
                                                : null,
                                            child: comment.user.profileImageUrl == null ? Icon(Icons.person) : null,
                                          ),
                                        ),
                                      )),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );

          return const Center(
            child: Text('Error'),
          );
        },
      ),
    );
  }
}
