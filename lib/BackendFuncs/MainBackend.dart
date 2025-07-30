import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:toastification/toastification.dart';
import '../FunctionClasses/ListingClass.dart';
import '../FunctionClasses/imageUpload.dart';
import 'package:nanoid/nanoid.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as developer;

//This is the main EndPoint Url

final String mainUrl = "https://d268c76a0ba7.ngrok-free.app";

Future uploadListing(
    List<XFile> imageUrls,title,contact,
    tags,status,location,condition,price,
    description,category)
async{
  final id = customAlphabet("0123456789abcdefghijklmnopqrstuvwxyz",8);

  try {
  final userId = FirebaseAuth.instance.currentUser!.uid;
  final uploadedList = imageUrls.isNotEmpty ? await uploadImagesToBackend(imageUrls, id,mainUrl) : null;
  final secureUrls = imageUrls.isNotEmpty ? jsonDecode(uploadedList)['uploadedResults'] : null;


    final endPointUri = Uri.parse('${mainUrl.trim()}/post');

    final postData = {
      'id':id,
      'title':title,
      'description':description,
      'ownerId': userId,
      'category': category,
      'imageUrls':secureUrls,
      'contact':contact,
      'name':FirebaseAuth.instance.currentUser!.displayName,
      'ownerProfileImage':FirebaseAuth.instance.currentUser!.photoURL,
      'tags':tags,
      'status':status,
      'location':location,
      'condition':condition,
      'price':price
    };

    final response = await http.post(
        endPointUri,
        headers: {
          'Content-Type': 'application/json'
        },
        body: jsonEncode(postData)
    );

    print(response.body);
  }catch(e){
    print("ImageListing  Err🔴: $e");
  }

}

Future getListings()async{
  final endPointUri = Uri.parse('${mainUrl.trim()}/getListings');

  try {
    final response = await http.post(
        endPointUri,
        headers: {
          'Content-Type': 'application/json',
          'ngrok-skip-browser-warning':'true'
        },
        // body: jsonEncode({
        //   'Page': page,
        //   'PageSize': pageSize,
        //   'sort':sort
        // })
    );

    return jsonDecode(response.body);
  }catch(e){
    print("GetListing ❌: $e");
  }

}

Future saveListing(Listing listing)async{
  final endPointUrl = Uri.parse("${mainUrl.trim()}/saveListing");
  final uid = FirebaseAuth.instance.currentUser!.uid;

  try {
    final toSendJson = {
      'postId': listing.id,
      'uid': uid
    };

    final requestBody = await http.post(
        endPointUrl,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(toSendJson)
    );


    switch(requestBody.statusCode){
      case 400:
        return 400;
      case 401:
        return 401;
      case 409:
        return 409;
      case 201:
        return 201;
    }
  }catch(e){
    developer.log("Save Listing ❌: $e");
  }

}

Future deleteSavedListing(Listing listing)async{
  //Sends a delete request
  final endPointUrl = Uri.parse("${mainUrl.trim()}/saveListing");
  final uid = FirebaseAuth.instance.currentUser!.uid;

  try {
    final toSendJson = {
      'postId': listing.id,
      'uid': uid
    };

    final requestBody = await http.delete(
        endPointUrl,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(toSendJson)
    );

    print(requestBody.statusCode);

    switch(requestBody.statusCode){
      case 500:
        return 500;
      case 200:
        return 200;
    }
  }catch(e){
    developer.log("Delete Listing ❌: $e");
  }

}

Future getProfilePosts(ownerID)async{
  final endPointUrl = Uri.parse("${mainUrl.trim()}/profilePosts");

  try{
    
    final response = await http.post(
      endPointUrl,
      headers: {
        'Content-type':'application/json'
      },
        body: jsonEncode({'ownerId':ownerID})
      );

      final decoded = jsonDecode(response.body);
      final  data = decoded['allposts'] as List;

      final List<Listing> lastList = data.map((e) => Listing.fromJson(e)).toList();

      print(lastList.runtimeType);
      return lastList;

  }catch(e) {
    print('ProfilePosts❌:$e');
    return [];
  }
  
  }