
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatBotModel{
  bool ? isOwner;
  String ? msg;

  ChatBotModel({this.msg, this.isOwner});

  factory ChatBotModel.jsonData(data){
    return ChatBotModel(
      msg: data['msg'],
      isOwner: data['isOwner'],
    );
  }

  Map<String,dynamic> toMap(){
    return {
      'msg': msg,
      'isOwner':isOwner,
    };
  }

}


class HistoryModel{
  bool ? isOwner;
  String ? msg;
  Timestamp? createdAt;
  String? uid;

  HistoryModel({this.msg, this.isOwner,this.createdAt,this.uid});

  factory HistoryModel.jsonData(data){
    return HistoryModel(
      msg: data['msg'],
      isOwner: data['isOwner'],
      createdAt: data['createdAt'],
      uid: data['uid'],
    );
  }

  Map<String,dynamic> toMap(){
    return {
      'msg': msg,
      'isOwner':isOwner,
      'createdAt':createdAt,
      'uid':uid,
    };
  }

}