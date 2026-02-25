// lib/features/profile/presentation/widget/profile_model_widget.dart

class ProfileModel {
  final String name;
  final String memberSince;
  final String? imagePath;
  final bool lorryTrucksEnabled;
  final bool jcbExcavatorsEnabled;
  final bool carTataAceEnabled;

  ProfileModel({
    required this.name,
    required this.memberSince,
    this.imagePath,
    this.lorryTrucksEnabled = true,
    this.jcbExcavatorsEnabled = false,
    this.carTataAceEnabled = true,
  });

  ProfileModel copyWith({
    String? name,
    String? memberSince,
    String? imagePath,
    bool? lorryTrucksEnabled,
    bool? jcbExcavatorsEnabled,
    bool? carTataAceEnabled,
  }) {
    return ProfileModel(
      name: name ?? this.name,
      memberSince: memberSince ?? this.memberSince,
      imagePath: imagePath ?? this.imagePath,
      lorryTrucksEnabled: lorryTrucksEnabled ?? this.lorryTrucksEnabled,
      jcbExcavatorsEnabled: jcbExcavatorsEnabled ?? this.jcbExcavatorsEnabled,
      carTataAceEnabled: carTataAceEnabled ?? this.carTataAceEnabled,
    );
  }
}
