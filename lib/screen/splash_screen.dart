
import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:symptoms/bloc/app_cubit.dart';
import 'package:symptoms/bloc/app_state.dart';
import 'package:symptoms/screen/auth/loginscreen.dart';
import 'package:symptoms/screen/chat_bot_screen.dart';

class SpalshScreen extends StatefulWidget {
  const SpalshScreen({Key? key}) : super(key: key);

  @override
  State<SpalshScreen> createState() => _SpalshScreenState();
}

class _SpalshScreenState extends State<SpalshScreen> {

  @override
  void initState() {
    Timer(const Duration(seconds: 3),
            () async{
          if(FirebaseAuth.instance.currentUser?.uid!=null){
            BlocProvider.of<AppCubit>(context).getDateUser();
          }else{
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context){
              return LoginScreen();
            }));
          }
        }
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppCubit,AppState>(
        listener: (context,state){
          if(state is SuccessGetUserState){
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context){
              return ChatBotScreen();
            }));
          };
        },
    child: Scaffold(
      body: Center(
        child: Image.asset('assets/images/logo.jpg',fit: BoxFit.fill,
        width: double.infinity,height: double.infinity),
      ),
    ),);
  }
}
