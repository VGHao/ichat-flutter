// ignore_for_file: public_member_api_docs, sort_constructors_first
class UserModel {
  final String uid;
  final String name;
  final String profilePic;
  final bool isOnline;
  final String phoneNumber;
  final String? notifyToken;
  final List<String> groupId;

  UserModel({
    required this.uid,
    required this.name,
    required this.profilePic,
    required this.isOnline,
    required this.phoneNumber,
    required this.notifyToken,
    required this.groupId,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'name': name,
      'profilePic': profilePic,
      'isOnline': isOnline,
      'phoneNumber': phoneNumber,
      'notifyToken': notifyToken,
      'groupId': groupId,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      profilePic: map['profilePic'] ?? '',
      isOnline: map['isOnline'] ?? false,
      phoneNumber: map['phoneNumber'] ?? '',
      notifyToken: map['notifyToken'] ?? '',
      groupId: List<String>.from(map['groupId']),
    );
  }
}
