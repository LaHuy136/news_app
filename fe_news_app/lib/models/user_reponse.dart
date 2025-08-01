// ignore_for_file: avoid_print

class UserResponse {
  final int id;
  final String username;
  final String email;

  UserResponse({required this.id, required this.email, required this.username});

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(
      id: json['id'] ?? 0,
      username: json['username'] ?? '',
      email: json['email'] ?? '',
    );
  }
}
