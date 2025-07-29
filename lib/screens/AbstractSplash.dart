import 'package:cnet/Providers/ListingProvider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../BackendFuncs/ListingHandling.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class Splash extends ConsumerStatefulWidget {
  const Splash({super.key});

  @override
  ConsumerState<Splash> createState() => _SplashState();
}

class _SplashState extends ConsumerState<Splash> {

  final FirebaseAuth _firebase = FirebaseAuth.instance;

  @override
  void initState(){
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async{
    await ref.read(ListingProvider.notifier).getListings();
    await Future.delayed(const Duration(milliseconds: 1000));

    if(!mounted) return;
    checkUser();
  }

  void checkUser(){
    if(_firebase.currentUser != null){
      Navigator.of(context).pushReplacementNamed('/Home');
    }else{
      Navigator.of(context).pushReplacementNamed('/Register');
    }
  }



  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body:
        Container(
          height: screenHeight,
          width: screenWidth,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/loginbg.png'),
              fit: BoxFit.cover
            )
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                    "CampusNet.",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 40,
                    fontFamily: 'Molle',
                  ),
                ),
                SizedBox(height:6),
                LoadingAnimationWidget.fourRotatingDots(
                  color: Colors.white,
                   size: 30)
              ]
            ),
            ),
        )
    );
  }
}
