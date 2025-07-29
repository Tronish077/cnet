import 'package:cnet/FunctionClasses/ListingClass.dart';
import 'MainBackend.dart';
import 'package:flutter/material.dart';

Future<List<Listing>> getHomeListings() async {
  final Map<String, dynamic> jsonData = await getListings(); //

  final List<dynamic> rawList = jsonData['listings']; // make sure this key is correct!

  final List<Listing> listings = rawList
      .map((item) => Listing.fromJson(item as Map<String, dynamic>))
      .toList();

  return listings;
}

