
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:symptoms/bloc/app_cubit.dart';
import 'package:symptoms/screen/auth/loginscreen.dart';
import 'package:symptoms/screen/chat_screen.dart';
import 'package:symptoms/screen/history_screen.dart';

import '../bloc/app_state.dart';

class ChatBotScreen extends StatefulWidget {
  const ChatBotScreen({Key? key}) : super(key: key);

  @override
  State<ChatBotScreen> createState() => _ChatBotScreenState();
}

class _ChatBotScreenState extends State<ChatBotScreen> {
  TextEditingController msgController = TextEditingController();

  @override
  void initState() {
    BlocProvider.of<AppCubit>(context).clearChat();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppState>(
        builder: (context,state){
          var cubit = AppCubit.get(context);
          return Scaffold(
              appBar: AppBar(
                title: const Text('Chat Bot',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18
                    )),
                centerTitle: true,
                elevation: 0.0,
                actions: [
                  InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context){
                          return ChatScreen();
                        }));
                      },
                      child: Icon(Icons.chat)),
                  SizedBox(width: 10,),

                  InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context){
                          return HistoryScreen();
                        }));
                      },
                      child: Icon(Icons.history)),
                  SizedBox(width: 10,),
                  InkWell(
                      onTap: (){
                        cubit.logout();
                      },
                      child: Icon(Icons.logout)),
                  SizedBox(width: 10,),

                ],
              ),
              body: Column(
                children: [
                  Expanded(child: SingleChildScrollView(
                    child: Column(
                      children: [
                        ...List.generate(cubit.listChatBot.length, (index) =>Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 10),
                          child: Row(
                            mainAxisAlignment:(cubit.listChatBot[index].isOwner??false)?MainAxisAlignment.start: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Flexible(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        CircleAvatar(
                                          backgroundImage: NetworkImage(
                                              (cubit.listChatBot[index].isOwner??false)?
                                              cubit.signUpModel?.image??'':'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT5hooOO2muUron0zHd9jP2o4_dw2yWpyQQt7w2QF1faw&s'),
                                          radius: 20,
                                        ),
                                        const SizedBox(width: 10,),
                                        Expanded(
                                          child: Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 5),
                                              decoration: BoxDecoration(
                                                  color: (cubit.listChatBot[index].isOwner??false)?Colors.white:Colors.blueAccent,
                                                  borderRadius:
                                                  BorderRadius.circular(8)
                                              ),
                                              child: Text(cubit.listChatBot[index].msg??'',
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    color: (cubit.listChatBot[index].isOwner??false)?Colors.black:Colors.white),)
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ))

                      ],
                    ),
                  )),
                  TextFormField(
                    onEditingComplete: (){
                    },
                    textInputAction:TextInputAction.done,
                    keyboardType:TextInputType.text ,
                    controller: msgController,
                    textAlign: TextAlign.start,
                    decoration: InputDecoration(
                      hintText: 'Add Massage',
                      suffixIcon: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          (state is LoadingChatBotState)?
                          const CircularProgressIndicator():InkWell(
                              onTap: ()async{
                                if(msgController.text.isNotEmpty){
                                  cubit.addChat(msgController.text);
                                  cubit.chatBot(msg: msgController.text);
                                }
                                msgController.clear();
                              },
                              child: const Icon(Icons.send,color: Colors.grey,size: 18,)),
                          const SizedBox(width: 5,),
                        ],
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding:const  EdgeInsets.symmetric(vertical: 10,horizontal: 20),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder:InputBorder.none,
                    ),
                  ),
                ],
              )
          );
        },
        listener: (context,state){
          if(state is LogoutState){
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context){
              return LoginScreen();
            }), (route) => false);
          }

        });
  }
}






