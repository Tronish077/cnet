import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:toastification/toastification.dart';
import '../FunctionClasses/ListingClass.dart';
import '../FunctionClasses/imageUpload.dart';
import 'package:nanoid/nanoid.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as developer;

//This is the main EndPoint Url
final String mainUrl = "https://ba61eeeec104.ngrok-free.app";

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
      'price':price.replaceAll(",", "")
    };

    final response = await http.post(
        endPointUri,
        headers: {
          'Content-Type': 'application/json'
        },
        body: jsonEncode(postData)
    );

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

Future getMyListings()async{
  final endPointUri = Uri.parse('${mainUrl.trim()}/myListings');

  try {
    final response = await http.post(
      endPointUri,
      body: json.encode({"uid":FirebaseAuth.instance.currentUser!.uid}),
      headers: {
        'Content-Type': 'application/json',
        'ngrok-skip-browser-warning':'true'
      },
    );
    
    return jsonDecode(response.body);

  }catch(e){
    print("GetMyListings ❌: $e");
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

Future deleteListingFunc(String listingId) async{
  final endPointUrl = Uri.parse("${mainUrl.trim()}/deleteListing");

  try{
    final toSendJson = {
      'id': listingId
    };

    final requestBody = await http.delete(
      endPointUrl,
      headers: {
        'Content-Type': 'application/json',
    },body: jsonEncode(toSendJson)
  );

    return requestBody.statusCode;

  }catch(e,stack){
    if (kDebugMode) {
      print("Delete listing ❌: $e \n$stack");
    }
  }
}

Future getSavedListings()async{
  final endPointUrl = Uri.parse("${mainUrl.trim()}/mySaves");

  try{
    
    final response = await http.post(
      endPointUrl,
      headers: {
        'Content-type':'application/json'
      },
        body: jsonEncode({'ownerId':FirebaseAuth.instance.currentUser!.uid})
      );

      final decoded = jsonDecode(response.body);
      final  data = decoded['myListings'] as List;

      final List<Listing> lastList = data.map((e) => Listing.fromJson(e)).toList();

      return lastList;

  }catch(e, stackTrace) {
    print('mySaves❌:${e}');
    print('➡️:$stackTrace');
    return [];
  }
  
  }

Future getBannerLink(Listing item) async{
  final String itemId = item.id;
  final Uri myUrl = Uri.parse("$mainUrl/product?id=$itemId");
  final response = await  http.get(myUrl);

  print(response.body);
}

Future<void> openWhatsApp({
  required String phone, // e.g., "918141138512"
  required String message,
}) async
{
  final encodedMessage = Uri.encodeComponent(message);
  final url = Uri.parse("https://wa.me/$phone?text=$encodedMessage");

  if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
    throw Exception('Could not launch WhatsApp');
  }
}

Future followUser(Listing item) async{
  final Uri url = Uri.parse('$mainUrl/Follow');
  final uid = FirebaseAuth.instance.currentUser?.uid;
  final ownerObjRef = item.ownerObjRef;

  final toSendJson = {
    'uid': uid,
    'ownerObjRef': ownerObjRef
  };

  final response = await http.post(
    url,
    headers:{'Content-type':'application/json'},
    body: jsonEncode(toSendJson)
  );

  if (kDebugMode) {
    print("🔔 Response: ${response.statusCode}");
  }

}

Future getFollowers()async{

  final Uri url = Uri.parse("$mainUrl/getFollowers");
  final uid = FirebaseAuth.instance.currentUser?.uid;

  final toSendJson = {
    'uid': uid,
  };

  try {
    final response = await http.post(
        url,
        headers: {'Content-type': 'application/json'},
        body: jsonEncode(toSendJson)
    );

    if (kDebugMode) {
      print("🔔 Response: ${response.body}");
    }

    return jsonDecode(response.body)['count'];
  }catch(e,stack){
    return "Followers: ❌ $e $stack";
  }
}
