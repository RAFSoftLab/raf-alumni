import 'package:alumni_network/api/alumni_network_service.dart';
import 'package:alumni_network/api/initializer.dart';
import 'package:alumni_network/ui/companies/bloc/companies_page_bloc.dart';
import 'package:alumni_network/ui/companies/details/bloc/company_details_bloc.dart';
import 'package:alumni_network/ui/companies/details/company_details_page.dart';
import 'package:alumni_network/ui/students/student_profile/student_profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CompaniesPage extends StatelessWidget {
  const CompaniesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Alumni Mreža'),
      ),
      body: BlocBuilder<CompaniesPageBloc, CompaniesPageState>(
        builder: (context, state) {
          if (state is CompaniesPageLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is CompaniesPageLoaded)
            return ListView.builder(
              itemCount: state.companies.length,
              itemBuilder: (context, index) {
                final company = state.companies[index];
                return InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => BlocProvider<CompanyDetailsBloc>(
                          create: (context) => CompanyDetailsBloc(
                            company: company,
                            service: getService<AlumniNetworkService>(),
                          )..add(CompanyDetailsInit()),
                          child: CompanyDetailsPage(company: company),
                        ),
                      ),
                    );
                  },
                  child: ListTile(
                    leading: CircleAvatar(child: Icon(Icons.business)),
                    title: Text(company.name),
                  ),
                );
              },
            );

          return const Center(
            child: Text('Error'),
          );
        },
      ),
    );
  }
}
