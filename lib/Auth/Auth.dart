import 'dart:convert';
// import 'package:mvp/socket/socketConfig.dart';
import 'package:cnet/Providers/SavedProvider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:toastification/toastification.dart';
import 'dart:developer' as developer;

import '../Providers/FollowProvider.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn _googleSignIn = GoogleSignIn();
final mainUrl = ' https://ba61eeeec104.ngrok-free.app';

class MyAuth {

  Future googleAuth(context) async {
    try {
      await _googleSignIn.signOut();
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        developer.log("User cancelled Google sign-in.");
        return null;
      }

      final serverTokens = await googleUser.authentication;

      if (serverTokens.idToken == null || serverTokens.accessToken == null) {
        developer.log("Missing Google auth tokens.");
        return null;
      }

      final AuthCredential toFirebaseCredentials = GoogleAuthProvider.credential(
        idToken: serverTokens.idToken,
        accessToken: serverTokens.accessToken,
      );

      final UserCredential clientDetails =
      await _auth.signInWithCredential(toFirebaseCredentials);

      final fullUser = clientDetails.user;

      if (fullUser == null) {
        developer.log("Firebase user is null.");
        return null;
      }

      final toBackendBody = {
        "uid": fullUser.uid,
        "email": fullUser.email,
        "displayName": fullUser.displayName,
        "Provider":"Google",
        "metadata": {
          "creationTime":
          fullUser.metadata.creationTime?.toIso8601String(),
          "lastSignInTime":
          fullUser.metadata.lastSignInTime?.toIso8601String()
        }
      };

      registerToBackend(toBackendBody);
      // SocketService().connect();

      return clientDetails;
    } on FirebaseAuthException catch (e) {
      String message;
      String desc;

      //Switch for error code Firebase
      switch (e.code) {
        case 'email-already-in-use':
          message = 'This email is already registered.';
          desc = "Login instead";
          break;
        case 'invalid-email':
          message = 'The email address is not valid.';
          desc = "Re-enter Your email";
          break;
        case 'weak-password':
          message = 'The password is too weak.';
          desc = 'Try a different Combination';
          break;
        case 'network-request-failed':
          desc = 'retry on-connection';
          message = "Please Check your connection";
        case 'user-disabled':
          message = "This is a Disabled Account";
          desc = "Contact Admin";
          break;
        default:
          message = 'An unexpected error occurred.';
          desc = ' Please try again later.';
      }


      // Show the error using a snackbar, alert dialog, etc.
      toastification.show(
        alignment: Alignment.topCenter,
        title: Text(message,style: TextStyle(color: Colors.black),),
        description: Text(desc,style: TextStyle(color: Colors.black),),
        style: ToastificationStyle.flat,
        backgroundColor: Colors.white,
        autoCloseDuration: Duration(seconds: 3),
        icon: Icon(Icons.info_outline_rounded,color: Colors.red,),
      );
    }
  }

  Future normalRegister(String email, String Password, String FullName, context) async {
    try {
      final userCredentials = await _auth.createUserWithEmailAndPassword(
          email: email.trim(), password: Password.trim());
      final UserCredential firebaseUser = userCredentials;
      await firebaseUser.user!.updateDisplayName(FullName);
      await firebaseUser.user!.reload();

      final freshUser = _auth.currentUser;

      final toBackendBody = {
        "uid":freshUser?.uid,
        "email":freshUser?.email,
        "Provider":"email",
        "displayName":freshUser?.displayName,
        "metadata":{
          "creationTime": freshUser?.metadata.creationTime?.toIso8601String(),
          "lastSignInTime": freshUser?.metadata.lastSignInTime?.toIso8601String()
        }
      };
      registerToBackend(toBackendBody);


      developer.log("normalReg:🛡️${freshUser!.displayName}");

      return firebaseUser;
    } on FirebaseAuthException catch (e) {
      String message;
      String desc;

      //Switch for error code Firebase
    switch (e.code) {
      case 'email-already-in-use':
        message = 'This email is already registered.';
        desc = "Login instead";
        break;
      case 'invalid-email':
        message = 'The email address is not valid.';
        desc = "Re-enter Your email";
        break;
      case 'weak-password':
        message = 'The password is too weak.';
        desc = 'Try a different Combination';
        break;
      case 'network-request-failed':
        desc = 'retry on-connection';
        message = "Please Check your connection";
      default:
        message = 'An unexpected error occurred.';
        desc = ' Please try again later.';
    }


      // Show the error using a snackbar, alert dialog, etc.
      toastification.show(
        alignment: Alignment.topCenter,
        title: Text(message,style: TextStyle(color: Colors.black),),
        description: Text(desc,style: TextStyle(color: Colors.black),),
        style: ToastificationStyle.flat,
        backgroundColor: Colors.white,
        autoCloseDuration: Duration(seconds: 3),
        icon: Icon(Icons.info_outline_rounded,color: Colors.red,),
      );
    }
  }

  Future normalLogin(String email, String Password, BuildContext context) async {
    try {
      final userCredentials = await _auth.signInWithEmailAndPassword(
          email: email.trim(), password: Password.trim());
      final firebaseUser = _auth.currentUser!;

      developer.log("firebaseUser: $firebaseUser");

      if (firebaseUser.email == null) {
        toastification.show(
          alignment: Alignment.topCenter,
          title: Text("Login failed", style: TextStyle(color: Colors.black)),
          style: ToastificationStyle.flat,
          backgroundColor: Colors.white,
          autoCloseDuration: Duration(seconds: 3),
          icon: Icon(Icons.info_outline_rounded, color: Colors.red),
        );
        return null;
      }

      final toBackendBody = {
        "uid": firebaseUser.uid,
        "email": firebaseUser.email,
        "displayName": firebaseUser.displayName,
        "metadata": {
          "creationTime": firebaseUser.metadata.creationTime?.toIso8601String(),
          "lastSignInTime": firebaseUser.metadata.lastSignInTime?.toIso8601String()
        }
      };
      // loginToBackend(toBackendBody);

      return firebaseUser;

    } on FirebaseAuthException catch (e) {
      String message;
      if (kDebugMode) {
        print("🫡❌$e");
      }

      switch (e.code) {
        case 'invalid-credential':
          message = 'Wrong Email or Password';
          break;
        case 'wrong-password':
          message = 'Wrong Email or Password.';
          break;
        case 'invalid-email':
          message = 'The email address is not valid.';
          break;
        case 'user-not-found':
          message = 'No user found with this email.';
          break;
        case 'too-many-requests':
          message = "Too Many request Submitted.\nPlease try again later.";
        case 'user-disabled':
          message = "This is a Disabled Account";
          break;
        case 'network-request-failed':
          message = "Please Check your connection and try again";
          break;
        default:
          developer.log("${e.code} 🤧🔥");
          message = 'An unexpected error occurred.\nPlease try again later.';
      }


      toastification.show(
        alignment: Alignment.topCenter,
        title: Text(message,style: TextStyle(color: Colors.black),),
        style: ToastificationStyle.flat,
        backgroundColor: Colors.white,
        autoCloseDuration: Duration(seconds: 3),
        icon: Icon(Icons.info_outline_rounded,color: Colors.red,),
      );

      return null;

    }


  }

  Future logoutAll(context,WidgetRef ref) async {
    try {
      await _auth.signOut();
      // SocketService().disconnect();
      ref.watch(savesProvider.notifier).resetAll();
      ref.watch(followersProvider.notifier).clearFollowers();
      Navigator.pushNamedAndRemoveUntil(context, '/Login', (route) => false);
    } catch (e) {
      print(e);
    }
  }

}

Future registerToBackend(data)async{
  final Uri serverEndpoint = Uri.parse("$mainUrl/reg");

  try{
    final response = await http.post(
        serverEndpoint,
        headers:{
        'Content-type':'application/json'
        },
        body: jsonEncode(data));

    if (response.statusCode == 201) {
      developer.log("✅ User registered successfully");
    } else if (response.statusCode == 409) {
      developer.log("⚠️ User already exists");
    } else {
      developer.log("❌ Backend error: ${response.statusCode} ${response.body}");
    }

  }catch(e){
    developer.log("RegBackend:$e");
  }

}

void loginToBackend(data)async{

  final Uri serverEndpoint = Uri.parse("https://campusnetserver-production.up.railway.app/login");

  try{
    final response = await http.post(
        serverEndpoint,
        headers:{
          'Content-type':'application/json'
        },
        body: jsonEncode(data));

    if (response.statusCode == 201) {
      developer.log("✅ Added The Entry");
    }else if(response.statusCode == 200) {
      developer.log("🫡✅ Last sign in Update");
    }else
    {
      developer.log("❌ Backend error: ${response.statusCode} ${response.body}");
    }

  }catch(e){
    developer.log("🏄‍♂️$e");
  }

}
