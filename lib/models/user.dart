class User {
  final String uid;
  final String? displayName;
  final String email;
  final DateTime? createdAt;

  User({
    required this.uid,
    this.displayName,
    required this.email,
    this.createdAt,
  });

  factory User.fromMap(Map<String, dynamic> data) {
    return User(
      uid: data['uid'],
      displayName: data['displayName'],
      email: data['email'],
      createdAt: data['createdAt'] != null
          ? DateTime.parse(data['createdAt'])
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'displayName': displayName,
      'email': email,
      'createdAt': createdAt?.toIso8601String(),
    };
  }
}
