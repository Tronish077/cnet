import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:developer' as developer;
import '../CustomWidgets/customeWidget.dart';
// import 'package:mvp/socket/socketConfig.dart';
import '../Auth/Auth.dart';
import '../Providers/LoaderProvider.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final formKey = GlobalKey<FormState>();
  final _auth = MyAuth();
  final customWidget = CustomWidgets();


  TextEditingController email = TextEditingController();
  TextEditingController fullName = TextEditingController();
  TextEditingController password = TextEditingController();
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

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
                              "Get Started",
                          style: TextStyle(
                              fontSize:26,
                          fontWeight: FontWeight.w900,
                          color: Theme.of(context).primaryColor),
                          ),
                          SizedBox(height: 15),
                          //Full Name
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
                                    label: Text("Full Name",
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600),),
                                    floatingLabelBehavior: FloatingLabelBehavior.always,
                                    hintText:"Enter Full Name",
                                    hintStyle: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey
                                    )
                                  ),
                                  validator: (value){
                                    if(value!.isEmpty){
                                      return "Please Fill this field";
                                    }
                                    return null;
                                  },
                                  controller: fullName,
                                  keyboardType: TextInputType.text,
                                )
                              ],
                            ),
                          ),
                          SizedBox(height: 15),
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
                                    if(value!.isEmpty){
                                      return "Please Fill this field";
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
                                    if(value!.isEmpty){
                                      return "Please Fill this field";
                                    }else if(value.length < 8){
                                      return "Password must Contain least 8 characters";
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
                          //SignUp Button
                          SizedBox(
                            width:double.infinity,
                            height: 50,
                            child: TextButton(onPressed: ()async{
                              if(formKey.currentState!.validate()){
                                try{
                                  ref.watch(loadingProvider.notifier).startLoading(context);
                                  final UserCredential user = await _auth.normalRegister(email.text, password.text,fullName.text,context);
                                  if(user.user!.email!.isNotEmpty){
                                    developer.log("$user");
                                    Navigator.pushNamedAndRemoveUntil(
                                        context, '/HomePage', (route) => false);
                                  }
                                }
                                    catch(e){
                                  developer.log("$e");
                                    }finally{
                                  ref.watch(loadingProvider.notifier).stopLoading(context);
                                }
                              }
                            },
                                style: TextButton.styleFrom(
                                  backgroundColor: Theme.of(context).primaryColor,
                                ),
                                child: Text(
                                  "Sign up",style: TextStyle(
                                  color: Colors.white
                                ),)),
                          ),
                          SizedBox(height: 15),
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
                          //Sign With Google
                          SizedBox(
                            width:double.infinity,
                            height: 50,
                            child: TextButton(onPressed: ()async{
                              try {
                                ref.watch(loadingProvider.notifier).startLoading(context);
                                final UserCredential user = await _auth.googleAuth(context);
                                if(user.user!.email!.isNotEmpty){
                                  developer.log("$user");
                                  Navigator.pushNamedAndRemoveUntil(
                                      context, '/HomePage', (route) => false);
                                }
                              }catch(e){
                                developer.log("GoogleReg:❌$e");
                              }finally{
                                ref.watch(loadingProvider.notifier).stopLoading(context);
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
                          SizedBox(height: 25),
                          //To Login If Account
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Already have an account?",
                                style: TextStyle(
                                  color: Colors.grey[600]
                                ),
                              ),
                              GestureDetector(
                                onTap: (){
                                  Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
                                },
                                child: Text(
                                    " Sign in",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Theme.of(context).primaryColor
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: 20)
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

