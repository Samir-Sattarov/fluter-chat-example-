class UserEntity {
  final String? uid;
  String? name;
  String? surname;
  final String? email;
  String? image;

  UserEntity({
    required this.uid,
    required this.name,
    required this.surname,
    required this.email,
    required this.image,
  });

  String get fullName => '$name $surname';
  factory UserEntity.fromJson(Map<String, dynamic> json) {
    return UserEntity(
      uid: json['uid'],
      name: json['name'],
      email: json['email'],
      image: json['image'],
      surname: json['surname'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "uid": uid,
      "name": name,
      "surname": surname,
      "email": email,
      "image": image,
    };
  }
}
