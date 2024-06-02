import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:symptoms/bloc/app_cubit.dart';
import 'package:symptoms/screen/splash_screen.dart';
import 'firebase_options.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );


  runApp(MultiBlocProvider(
    providers: [
      BlocProvider (create: (BuildContext context) => AppCubit(),),
    ],
    child: const MyApp(),));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Symptoms',
      debugShowCheckedModeBanner: false,
      home: SpalshScreen(),
    );
  }
}
