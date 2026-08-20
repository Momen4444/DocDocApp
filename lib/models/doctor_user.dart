// Mapping user to doctor to view it from API to UI

class DoctorUser {
  final int id;
  final String name;
  final String email;
  final int age;
  final String mobileNumber;
  final String? profileImagePath;
  final String role;

  const DoctorUser({
    required this.id,
    required this.name,
    required this.email,
    required this.age,
    required this.mobileNumber,
    this.profileImagePath,
    required this.role,
  });

  factory DoctorUser.fromJson(Map<String, dynamic> j) => DoctorUser(
        id: j['id'] ?? 0,
        name: j['name'] ?? '',
        email: j['email'] ?? '',
        age: j['age'] ?? 0,
        mobileNumber: j['mobileNumber'] ?? '',
        profileImagePath: j['profileImagePath'],
        role: j['role'] ?? 'User',
      );
}
