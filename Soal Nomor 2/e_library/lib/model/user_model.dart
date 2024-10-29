class User {
  final int? id;
  final String name;
  final String email;
  final String password;
  String? photoUrl; 

  User({
    this.id,
    required this.name,
    required this.email,
    required this.password,
    this.photoUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'photo_url': photoUrl,
    };
  }

  static User fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      password: map['password'],
      photoUrl: map['photo_url'],
    );
  }

  User copyWith({String? newPhotoUrl}) {
    return User(
      id: id,
      name: name,
      email: email,
      password: password,
      photoUrl: newPhotoUrl ?? photoUrl,
    );
  }
}
