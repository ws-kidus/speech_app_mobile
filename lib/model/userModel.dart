

class UserModel{
  final int id;
  final String name;
  final String email;
  final String? phone;
  final String? photoUrl;
  final String? backgroundUrl;
  final DateTime createdAt;

//<editor-fold desc="Data Methods">
  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.photoUrl,
    this.backgroundUrl,
    required this.createdAt,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          email == other.email &&
          phone == other.phone &&
          photoUrl == other.photoUrl &&
          backgroundUrl == other.backgroundUrl &&
          createdAt == other.createdAt);

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      email.hashCode ^
      phone.hashCode ^
      photoUrl.hashCode ^
      backgroundUrl.hashCode ^
      createdAt.hashCode;

  @override
  String toString() {
    return 'UserModel{' +
        ' id: $id,' +
        ' name: $name,' +
        ' email: $email,' +
        ' phone: $phone,' +
        ' photoUrl: $photoUrl,' +
        ' backgroundUrl: $backgroundUrl,' +
        ' createdAt: $createdAt,' +
        '}';
  }

  UserModel copyWith({
    int? id,
    String? name,
    String? email,
    String? phone,
    String? photoUrl,
    String? backgroundUrl,
    DateTime? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      photoUrl: photoUrl ?? this.photoUrl,
      backgroundUrl: backgroundUrl ?? this.backgroundUrl,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'name': this.name,
      'email': this.email,
      'phone': this.phone,
      'photoUrl': this.photoUrl,
      'backgroundUrl': this.backgroundUrl,
      'createdAt': this.createdAt,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      name: map['name'],
      email: map['email'] ,
      phone: map['phone'] ,
      photoUrl: map['photoUrl'] ,
      backgroundUrl: map['backgroundUrl'] ,
      createdAt: DateTime.parse(map['createdAt']),
    );
  }

//</editor-fold>
}