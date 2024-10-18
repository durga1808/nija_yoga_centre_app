class LoginModel {
  final List<Message>? message;

  LoginModel({this.message});

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(
      message: (json['message'] as List)
          ?.map((item) => Message.fromJson(item))
          ?.toList(),
    );
  }
}

class Message {
  final int? id; // Ensure this matches the type from your API
  final String? username;
  final String? firstname;
  final String? middlename;
  final String? lastname;
  final String? centername;
  final String? phoneno;
  final String? gender;
  final int? centerid; // Ensure this matches the type from your API

  Message({
    this.id,
    this.username,
    this.firstname,
    this.middlename,
    this.lastname,
    this.centername,
    this.phoneno,
    this.gender,
    this.centerid,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'] as int?, // If this is an int in your API
      username: json['username'] as String?,
      firstname: json['firstname'] as String?,
      middlename: json['middlename'] as String?,
      lastname: json['lastname'] as String?,
      centername: json['centername'] as String?,
      phoneno: json['phoneno'] as String?,
      gender: json['gender'] as String?,
      centerid: json['centerid'] as int?, // If this is an int in your API
    );
  }
}
