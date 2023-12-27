import 'package:alumni_network/api/alumni_network_service.dart';
import 'package:alumni_network/api/initializer.dart';
import 'package:alumni_network/ui/companies/bloc/companies_page_bloc.dart';
import 'package:alumni_network/ui/companies/companies_page.dart';
import 'package:alumni_network/ui/feed/bloc/feed_page_bloc.dart';
import 'package:alumni_network/ui/feed/feed_page.dart';
import 'package:alumni_network/ui/students/bloc/students_page_bloc.dart';
import 'package:alumni_network/ui/students/students_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NavigationExample extends StatefulWidget {
  const NavigationExample({super.key});

  @override
  State<NavigationExample> createState() => _NavigationExampleState();
}

class _NavigationExampleState extends State<NavigationExample> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: Colors.amber,
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            icon: Badge(
              label: Text('2'),
              child: Icon(Icons.feed),
            ),
            label: 'Objave',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.people),
            icon: Icon(Icons.people_alt_outlined),
            label: 'Studenti',
          ),
          NavigationDestination(
            icon: Icon(Icons.business),
            label: 'Kompanije',
          ),
        ],
      ),
      body: <Widget>[
        /// Feed page
        BlocProvider<FeedPageBloc>(
          create: (context) => FeedPageBloc(
            service: getService<AlumniNetworkService>(),
          )..add(FeedPageInit()),
          child: const FeedPage(),
        ),

        /// Students page
        BlocProvider<StudentsPageBloc>(
          create: (context) => StudentsPageBloc(
            service: getService<AlumniNetworkService>(),
          )..add(StudentsPageInit()),
          child: const StudentsPage(),
        ),

        /// Companies page
        BlocProvider<CompaniesPageBloc>(
          create: (context) => CompaniesPageBloc(
            service: getService<AlumniNetworkService>(),
          )..add(CompaniesPageInit()),
          child: const CompaniesPage(),
        ),
      ][currentPageIndex],
    );
  }
}