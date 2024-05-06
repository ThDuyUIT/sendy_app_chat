import 'package:json_annotation/json_annotation.dart';
import 'package:objectbox/objectbox.dart';
part 'user_model.g.dart';

@JsonSerializable()
//@Entity()
class User {

  late String idUser;
  late String uid;
  late String name;
  late String email;
  String? password;
  int? gender;
  //DateTime? birthday;
  String? urlAvatar;
  bool? activeStatus;

  User.init({
    // this.id = 1,
    this.idUser = '',
    this.uid = '',
    this.name = '',
    this.email = '',
    // this.gender = -1,
    // this.urlAvatar = '',
    // this.activeStatus = false
  });

  User(
      { required this.idUser,
      required this.uid,
      required this.name,
      required this.email,
      this.gender,
      //this.birthday,
      this.urlAvatar,
      this.activeStatus,
      this.password});
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);

  @override
  String toString() {
    return 'User{uid: $uid, name: $name, email: $email, gender: $gender, urlAvatar: $urlAvatar, activeStatus: $activeStatus}';
  }
}
