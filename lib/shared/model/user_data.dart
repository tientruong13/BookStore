

class UserData {
  String? dislayName;
  String? avatar;
  String? token;

  UserData({this.dislayName, this.avatar, this.token});

  factory UserData.formJson(Map<String, dynamic> map) {
    return UserData(dislayName: map['displayName'],
    avatar: map['avatar'],token: map['token']
    );
  }

}