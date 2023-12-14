import 'package:alumni_network/api/alumni_network_service.dart';
import 'package:equatable/equatable.dart';

class AlumniUser extends Equatable {
  AlumniUser({
    required this.id,
    required this.fullName,
    required this.biography,
    required this.profileImageUrl,
    required this.socialId1,
  });

  final int id;

  final String fullName;
  final String biography;

  final String? profileImageUrl;
  final String? socialId1;

  factory AlumniUser.fromMap(Map<String, dynamic> map) {
    return AlumniUser(
      id: map['id'] as int,
      fullName: map['full_name'] as String,
      biography: map['biography'] as String,
      profileImageUrl: map['profile_picture'] != null ? AlumniNetworkService.baseUrl + map['profile_picture'] : null,
      socialId1: map['social_id_1'] as String?,
    );
  }

  @override
  List<Object?> get props => [id];
}
