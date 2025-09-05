import 'package:cnet/FunctionClasses/ListingClass.dart';
import 'package:flutter/foundation.dart';
import 'MainBackend.dart';

Future<List<Listing>> getHomeListings() async {
  final Map<String, dynamic> jsonData = await getListings(); //

  final List<dynamic> rawList = jsonData['listings']; // make sure this key is correct!

  final List<Listing> listings = rawList
      .map((item) => Listing.fromJson(item as Map<String, dynamic>))
      .toList();

  return listings;
}

Future<List<Listing>> getProfileListings() async {
  final Map<String, dynamic> jsonData = await getMyListings();
  final List<dynamic> rawList = jsonData['myListings']; // make sure this key is correct!

  final List<Listing> listings = rawList
      .map((item) => Listing.fromJson(item as Map<String, dynamic>))
      .toList();

  return listings;
}

