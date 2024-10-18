class MyScroreModel {
  bool? status;
  List<Message>? message;

  MyScroreModel({this.status, this.message});

  MyScroreModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['message'] != null) {
      message = <Message>[];
      json['message'].forEach((v) {
        message!.add(Message.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (message != null) {
      data['message'] = message!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Message {
  int? occurance;
  String? coursename;
  String? currentdate;
  String? remarks;

  Message({this.occurance, this.coursename, this.currentdate,this.remarks});

  Message.fromJson(Map<String, dynamic> json) {
    occurance = json['occurance'];
    coursename = json['coursename'];
    currentdate = json['Currentdate'];
    remarks = json['remarks'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['occurance'] = occurance;
    data['coursename'] = coursename;
    data['Currentdate'] = currentdate;
    data['remarks'] = remarks;
    return data;
  }
}
