import 'dart:convert';

class RegisterResponseModel {
  RegisterResponseModel({
    required this.message,
    required this.data,
  });
  late final String message;
  late final UserData? data;

  RegisterResponseModel.fromJson(Map<String, dynamic> json){
    message = json['message'];
    data = json['data'] != null ? UserData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['message'] = message;
    _data['data'] = data!.toJson();
    return _data;
  }
}

class UserData {
  UserData({
    required this.name,
    required this.email,
    required this.date,
    required this.id,
  });
  late final String name;
  late final String email;
  late final String date;
  late final String id;

  UserData.fromJson(Map<String, dynamic> json){
    name = json['name'];
    email = json['email'];
    date = json['date'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['name'] = name;
    _data['email'] = email;
    _data['date'] = date;
    _data['id'] = id;
    return _data;
  }
}
