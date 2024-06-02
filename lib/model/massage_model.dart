
class MessageModel{
  String ? message;
  String ? image;
  String ? id;

  MessageModel({this.message, this.id,this.image});
  factory MessageModel.jsonDate(date){
    return MessageModel(
        message: date['message'],
        image: date['image'],
        id: date['id']);
  }
}