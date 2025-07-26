import 'package:cnet/screens/Register.dart';
import 'package:cnet/screens/login.dart';
import 'package:toastification/toastification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(ToastificationWrapper(
      child:ProviderScope(
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
            theme: ThemeData(
              fontFamily: 'Liter',
              primaryColor:const Color.fromARGB(255, 61, 42, 234),
            ),
          routes:{
            '/':(context)=>LoginPage(),  
            '/Register':(context)=>RegisterPage()
          },
        ),
      )
  )
  );
}

