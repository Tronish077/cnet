import 'package:flutter/material.dart';
import '../Auth/Auth.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final _auth = MyAuth();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed:(){
            _auth.logoutAll(context);
          } , icon: Icon(Icons.logout)
          )
        ],
      ),
      body: Column(
        children: [
        ],
      ),
    );
  }
}
