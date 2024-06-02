
import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:symptoms/bloc/app_state.dart';
import 'package:symptoms/model/chat_bot_model.dart';
import 'package:symptoms/model/profile_model.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

class AppCubit extends Cubit<AppState>{
  AppCubit() : super(InitialState());

  static AppCubit get(context)=>BlocProvider.of(context);

  bool obscureText=true;
  void visiblePassword(){
    obscureText=!obscureText;
    emit(VisiblePasswordState());
  }

  void userLogin({required String email, required String password,}){
    emit(LoadingLoginState());
    FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password).
    then((value){
      emit(SuccessLoginState());
      getDateUser();
    }).
    onError((error,_){
      emit(ErrorLoginState());
    });
  }


  File? image;
  String ? url;

  void changeImage({required File img,}){
    image=img;
    emit(ChangeImage());
  }

  void signUp({required String email, required String password, required String name, required String phone,required String type})async{
    emit(LoadingSignUpState());
    final ref= FirebaseStorage.instance.ref().child('Images').
    child(FirebaseAuth.instance.currentUser?.uid??'').
    child('$name$email.jpg');
    await ref.putFile(image!).then((p0)async {
      url =await ref.getDownloadURL();
      FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password).then((value){
          SignUpModel model=SignUpModel(name: name, email: email, phone: phone, uId: value.user?.uid,
            image: url,
            createdAt: Timestamp.now(),
            type: type
        );
        FirebaseFirestore.instance.collection('Users').doc(value.user?.uid).set(
            model.toMap()
        ).then((value){
          emit(SuccessSignUpState());
          getDateUser();
        }).onError((error,_){
          emit(ErrorSignUpState());
        });
      }).onError((error,_){
        emit(ErrorSignUpState());
      });
  });
  }


  SignUpModel? signUpModel;
  void getDateUser(){
    emit(LoadingGetUserState());
    signUpModel=null;
    if(FirebaseAuth.instance.currentUser!=null){
      FirebaseFirestore.instance.collection('Users').doc(FirebaseAuth.instance.currentUser?.uid).
      get().
      then((value){
        signUpModel=SignUpModel.formJson(value.data()!);
        emit(SuccessGetUserState());
      }).onError((error,_){
        emit(ErrorGetUserState());
      });
    }
  }

  void logout(){
    FirebaseAuth.instance.signOut().whenComplete((){
      emit(LogoutState());
    });
  }

  final String baseUrl= 'http://tourismapp.somee.com';

  Map<String , String > header={
    'Accept':'application/json',
    'Content-Type':'application/json',
  };


  List<ChatBotModel> listChatBot=[];
  void addChat(String msg){
    listChatBot.add(ChatBotModel(
        isOwner: true,
        msg: msg
    ));
    emit(ChangeImage());
  }

  void clearChat(){
    listChatBot=[];
    emit(ChangeImage());
  }

  void addHistory({required String msg ,required bool isOwner}){
    HistoryModel chatBotModel=HistoryModel(
      msg: msg,
      isOwner: isOwner,
      uid: FirebaseAuth.instance.currentUser?.uid,
      createdAt: Timestamp.now()
    );
    String uuid =Uuid().v4();
    FirebaseFirestore.instance.collection('History')
    .doc(uuid)
    .set(chatBotModel.toMap())
    .then((value){
      emit(SuccessAddHistoryState());
    }).onError((error, stackTrace){
      emit(ErrorAddHistoryState());
    });
  }

  List<HistoryModel> historyList=[];
  void getHistory(){
    emit(LoadingGetHistoryState());
    historyList=[];
    FirebaseFirestore.instance.collection('History')
    .orderBy('createdAt',descending: false)
        .get()
        .then((value){
          value.docs.forEach((element) {
            HistoryModel h= HistoryModel.jsonData(element);
            if(h.uid == FirebaseAuth.instance.currentUser?.uid){
              historyList.add(HistoryModel.jsonData(element));
            }
          });
      emit(SuccessGetHistoryState());
    }).onError((error, stackTrace){
      emit(ErrorGetHistoryState());
    });
  }


  void chatBot({required String msg ,})async{
    emit(LoadingChatBotState());
    print(msg);
    addHistory(isOwner: true,msg:msg );
    try{
      http.Response response = await http.post(Uri.parse('$baseUrl/api/ChatBot'),
          body: json.encode({
            'promptStr': msg,
          }),headers:header );
      String data = jsonDecode(response.body);
      print(data);
      if(response.statusCode==200){
        listChatBot.add(ChatBotModel(
            isOwner: false,
            msg: data
        ));
        emit(SuccessChatBotState());
        addHistory(isOwner: false,msg:data );
      }
    }catch(e){
      print(e.toString());
      emit(ErrorChatBotState());
    }
  }

}
