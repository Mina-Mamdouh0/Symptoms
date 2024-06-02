
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:symptoms/bloc/app_cubit.dart';
import 'package:symptoms/bloc/app_state.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {

  @override
  void initState() {
    BlocProvider.of<AppCubit>(context).getHistory();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppState>(
        builder: (context,state){
          var cubit = AppCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text('History',style: TextStyle(
                  color: Colors.white,
                  fontSize: 18
              )),
              elevation: 0.0,
            ),
            body:  (state is LoadingGetHistoryState)?
            Center(child: CircularProgressIndicator(),)
                :ListView.builder(
              padding: EdgeInsets.zero,
                itemCount: cubit.historyList.length,
                itemBuilder: (context,index){
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 10),
                    child: Row(
                      mainAxisAlignment:(cubit.historyList[index].isOwner??false)?MainAxisAlignment.start: MainAxisAlignment.end,
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
                                        (cubit.historyList[index].isOwner??false)?
                                        cubit.signUpModel?.image??'':'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT5hooOO2muUron0zHd9jP2o4_dw2yWpyQQt7w2QF1faw&s'),
                                    radius: 20,
                                  ),
                                  const SizedBox(width: 10,),
                                  Expanded(
                                    child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 5),
                                        decoration: BoxDecoration(
                                            color: (cubit.historyList[index].isOwner??false)?Colors.white:Colors.blueAccent,
                                            borderRadius:
                                            BorderRadius.circular(8)
                                        ),
                                        child: Text(cubit.historyList[index].msg??'',
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: (cubit.historyList[index].isOwner??false)?Colors.black:Colors.white),)
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }),
          );
        },
        listener: (context,state){});
  }
}
