class User {
  final String id;
  final String displayName;
  final String email;
  final String avatarUrl;
  final String authToken;

  User({
    required this.id,
    required this.displayName,
    required this.email,
    required this.avatarUrl,
    required this.authToken,
  });

  factory User.fromJson(Map<String, dynamic> json, String token) {
    return User(
      id: json['id'] ?? '',
      displayName: json['displayName'] ?? '',
      email: json['email'] ?? '',
      avatarUrl: json['avatarUrl'] ?? '',
      authToken: token,
    );
  }
}
