class UserModel {
  bool status;
  List<User> message;

  UserModel({required this.status, required this.message});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      status: json['status'] ?? false,
      message: (json['message'] as List<dynamic>?)
              ?.map((item) => User.fromJson(item))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message.map((item) => item.toJson()).toList(),
    };
  }
}

class User {
  int? id;
  String? username;
  int? userpassword;
  String? firstname;
  String? middlename;
  String? lastname;
  int? issuperuser;
  int? centerid;
  String? centername;
  String? title;
  String? gender;
  String? dob;
  String? maritalstatus;
  String? mailid;
  String? phoneno;
  String? emergencycontactperson;
  String? emergencycontactno;
  int? status;

  User(
      {this.id,
      this.username,
      this.userpassword,
      this.firstname,
      this.middlename,
      this.lastname,
      this.issuperuser,
      this.centerid,
      this.centername,
      this.title,
      this.gender,
      this.dob,
      this.maritalstatus,
      this.mailid,
      this.phoneno,
      this.emergencycontactperson,
      this.emergencycontactno,
      this.status, required String mobile});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    userpassword = json['userpassword'];
    firstname = json['firstname'];
    middlename = json['middlename'];
    lastname = json['lastname'];
    issuperuser = json['issuperuser'];
    centerid = json['centerid'];
    centername = json['centername'];
    title = json['title'];
    gender = json['gender'];
    dob = json['dob'];
    maritalstatus = json['maritalstatus'];
    mailid = json['mailid'];
    phoneno = json['phoneno'];
    emergencycontactperson = json['emergencycontactperson'];
    emergencycontactno = json['emergencycontactno'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['username'] = this.username;
    data['userpassword'] = this.userpassword;
    data['firstname'] = this.firstname;
    data['middlename'] = this.middlename;
    data['lastname'] = this.lastname;
    data['issuperuser'] = this.issuperuser;
    data['centerid'] = this.centerid;
    data['centername'] = this.centername;
    data['title'] = this.title;
    data['gender'] = this.gender;
    data['dob'] = this.dob;
    data['maritalstatus'] = this.maritalstatus;
    data['mailid'] = this.mailid;
    data['phoneno'] = this.phoneno;
    data['emergencycontactperson'] = this.emergencycontactperson;
    data['emergencycontactno'] = this.emergencycontactno;
    data['status'] = this.status;
    return data;
  }
}