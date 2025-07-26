import 'package:cnet/Providers/LoaderProvider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:developer' as developer;
import '../CustomWidgets/customeWidget.dart';
// import 'package:mvp/socket/socketConfig.dart';
import '../Auth/Auth.dart';

class LoginPage extends ConsumerStatefulWidget{
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final formKey = GlobalKey<FormState>();
  final _auth = MyAuth();
  final customWidget = CustomWidgets();
  // final _socket = SocketService();
  final _firebase = FirebaseAuth.instance;
  bool isChecked = false;

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final isLoading = ref.watch(loadingProvider);
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body:
      SafeArea(
        child:SizedBox(
          height: screenHeight,
          child: Stack(
            children: [
              Container(
                height: screenHeight * 0.3,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/loginbg.png'),
                        fit: BoxFit.cover
                    )
                ),
              ),
              Positioned(
                top: screenHeight * 0.25,
                bottom: 0,
                right: 0,
                left: 0,
                child: Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:BorderRadius.only(
                        topRight:Radius.circular(32),
                        topLeft:Radius.circular(32)
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Login",
                            style: TextStyle(
                                fontSize:26,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor),
                          ),
                          SizedBox(height: 40),
                          //Email
                          Container(
                            padding: EdgeInsets.all(8),
                            child: Column(
                              children: [
                                TextFormField(
                                  decoration: InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.grey.shade400),
                                        borderRadius: BorderRadius.circular(18),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.black),
                                        borderRadius: BorderRadius.circular(18),
                                      ),
                                      label: Text("Email ID",
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600),),
                                      floatingLabelBehavior: FloatingLabelBehavior.always,
                                      hintText:"Enter Email ID",
                                      hintStyle: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey
                                      )
                                  ),
                                  validator: (value){
                                    if(value!.trim().isEmpty){
                                      return "Email is required";
                                    }
                                    return null;
                                  },
                                  controller: email,
                                  keyboardType: TextInputType.emailAddress,
                                )
                              ],
                            ),
                          ),
                          SizedBox(height: 15),
                          //Password
                          Container(
                            padding: EdgeInsets.all(8),
                            child: Column(
                              children: [
                                TextFormField(
                                  decoration: InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.grey.shade400),
                                        borderRadius: BorderRadius.circular(18),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.black),
                                        borderRadius: BorderRadius.circular(18),
                                      ),
                                      label: Text("Password",
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600),),
                                      floatingLabelBehavior: FloatingLabelBehavior.always,
                                      hintText:"Enter Password",
                                      hintStyle: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey
                                      )
                                  ),
                                  validator: (value){
                                    if(value!.trim().isEmpty){
                                      return "Password is required";
                                    }else if(value.length < 8){
                                      return "Password mut be least 8 characters";
                                    }
                                    return null;
                                  },
                                  controller: password,
                                  obscureText: !isChecked,
                                )
                              ],
                            ),
                          ),
                          //Show Password
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Checkbox(value: isChecked,
                                onChanged:(bool? value){
                                  setState(() {
                                    isChecked = value!;
                                  });
                                },
                                activeColor: Colors.blue[700],
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4)
                                ),
                              ),
                              Text("Show Password")
                            ],),
                          SizedBox(height: 5,),
                          //SignIn Button
                          SizedBox(
                            width:double.infinity,
                            height: 50,
                            child: TextButton(
                                onPressed: () async {
                                  if (formKey.currentState!.validate()) {
                                    try {
                                      if (!mounted) return;
                                      ref.read(loadingProvider.notifier).startLoading(context);

                                      final user = await _auth.normalLogin(email.text, password.text, context);

                                      if (!mounted) return;
                                      if (user != null) {
                                        // stop loading first
                                        ref.read(loadingProvider.notifier).stopLoading(context);
                                        // then navigate
                                        Navigator.of(context).pushReplacementNamed('/Home');
                                      }
                                    } catch (e, stackTrace) {
                                      developer.log("Login error: $stackTrace");
                                      ref.read(loadingProvider.notifier).stopLoading(context);
                                    }
                                  }
                                }
                                ,
                                style: TextButton.styleFrom(
                                  backgroundColor: Theme.of(context).primaryColor,
                                ),
                                child: Text(
                                  "Sign in",style: TextStyle(
                                    color: Colors.white
                                ),)),
                          ),
                          SizedBox(height: 25),
                          SizedBox(
                            width: double.infinity,
                            child: Row(
                              children: [
                                Expanded(child: Divider()),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "OR",
                                    style: TextStyle(
                                        color: Colors.grey
                                    ),
                                  ),
                                ),
                                Expanded(child: Divider())
                              ],
                            ),
                          ),
                          SizedBox(height:20),
                          //Sign With Google
                          SizedBox(
                            width:double.infinity,
                            height: 50,
                            child: TextButton(onPressed: () async {
                              try {
                                if (!mounted) return;
                                ref.watch(loadingProvider.notifier).startLoading(context);
                                final UserCredential user = await _auth.googleAuth(context);
                                if (!mounted) return;
                                final email = user.user?.email;
                                if (email != null && email.isNotEmpty) {
                                  Navigator.pushNamedAndRemoveUntil(context, '/Home', (route) => false);
                                } else {
                                  ref.watch(loadingProvider.notifier).stopLoading(context);
                                  developer.log("❌ Email is null or empty");
                                }
                              }catch(e,stackTrace){
                                ref.watch(loadingProvider.notifier).stopLoading(context);
                                developer.log("🍃${stackTrace}");
                              }
                            },
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.grey[200],
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset('assets/googleicn.png',scale: 2,),
                                    SizedBox(width: 5),
                                    Text(
                                      "Continue With Google",style: TextStyle(
                                        color: Colors.black
                                    ),),
                                  ],
                                )),
                          ),
                          SizedBox(height: 35),
                          //To Login If Account
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Don't have an account?",
                                style: TextStyle(
                                    color: Colors.grey[600]
                                ),
                              ),
                              GestureDetector(
                                onTap: (){
                                  Navigator.pushNamedAndRemoveUntil(context, '/Register', (route) => false);
                                },
                                child: Text(
                                  " Create One",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Theme.of(context).primaryColor
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


