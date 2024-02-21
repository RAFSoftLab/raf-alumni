import 'package:alumni_network/api/alumni_network_service.dart';
import 'package:alumni_network/api/initializer.dart';
import 'package:alumni_network/auth/authentication_bloc.dart';
import 'package:alumni_network/models/enums/user_role.dart';
import 'package:alumni_network/ui/calendar/bloc/calendar_page_bloc.dart';
import 'package:alumni_network/ui/calendar/calendar_page.dart';
import 'package:alumni_network/ui/companies/bloc/companies_page_bloc.dart';
import 'package:alumni_network/ui/companies/companies_page.dart';
import 'package:alumni_network/ui/feed/bloc/feed_page_bloc.dart';
import 'package:alumni_network/ui/feed/feed_page.dart';
import 'package:alumni_network/ui/login/bloc/login_page_bloc.dart';
import 'package:alumni_network/ui/login/login_page.dart';
import 'package:alumni_network/ui/schedule/bloc/schedule_bloc.dart';
import 'package:alumni_network/ui/schedule/schedule_page.dart';
import 'package:alumni_network/ui/students/bloc/students_page_bloc.dart';
import 'package:alumni_network/ui/students/students_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    var userRole = UserRole.unknown;
    final authState = context.read<AuthenticationBloc>().state;
    if (authState is AuthenticationAuthenticated) {
      userRole = authState.user.role;
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('RAF Mreža'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthenticationBloc>().add(AuthenticationUserUnauthenticated());
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => BlocProvider<LoginPageBloc>(
                            create: (context) => LoginPageBloc(
                              authenticationBloc: context.read<AuthenticationBloc>(),
                              service: getService<AlumniNetworkService>(),
                            ),
                            child: LoginPage(),
                          )));
            },
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: Colors.amber,
        selectedIndex: currentPageIndex,
        destinations: <Widget>[
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
          if (userRole == UserRole.student)
            NavigationDestination(
              icon: Icon(Icons.calendar_month),
              label: 'Kalendar',
            ),
          if (userRole == UserRole.student)
            NavigationDestination(
              icon: Icon(Icons.list),
              label: 'Raspored',
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

        /// Calendar page
        if (userRole == UserRole.student)
          BlocProvider<CalendarPageBloc>(
            create: (context) => CalendarPageBloc(
              service: getService<AlumniNetworkService>(),
            )..add(CalendarPageInit()),
            child: const CalendarPage(),
          ),

        /// Schedule page
        if (userRole == UserRole.student)
          BlocProvider<ScheduleBloc>(
            create: (context) => ScheduleBloc(
              service: getService<AlumniNetworkService>(),
            )..add(ScheduleViewStudentSchedule()),
            child: const SchedulePage(),
          ),
      ][currentPageIndex],
    );
  }
}
