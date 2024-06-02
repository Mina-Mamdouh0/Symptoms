import 'package:cloud_firestore/cloud_firestore.dart';

class SignUpModel{
  String? name;
  String? email;
  String? phone;
  String? uId;
  String? image;
  Timestamp? createdAt;
  String? type;



  SignUpModel({ this.name, this.email, this.phone, this.uId,this.image,this.createdAt,this.type });

  factory SignUpModel.formJson(json,){
    return SignUpModel(
      name: json['Name'],
      email:json['Email'],
      phone: json['Phone'],
      uId: json['Id'],
      type: json['Type'],
      createdAt: json['CreatedAt'],
      image: json['Image'],
    );
  }

  Map<String,dynamic> toMap(){
    return {
      'Name': name,
      'Email':email,
      'Phone': phone,
      'Id': uId,
      'Type': type,
      'CreatedAt': createdAt,
      'Image': image,
    };
  }
}