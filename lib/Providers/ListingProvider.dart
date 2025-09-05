import 'dart:math';

import 'package:cnet/FunctionClasses/ListingClass.dart';
import 'package:flutter/foundation.dart';
import '../BackendFuncs/ListingHandling.dart';
import 'package:riverpod/riverpod.dart';

class ListingNotifier extends StateNotifier<List<Listing>> {
  ListingNotifier() : super([]);

  Future<void> getListings({bool shuffle = false}) async {
    try {
      final List<Listing> allListings = await getHomeListings();
      if(shuffle){
        allListings.shuffle(Random());
      }
      state = allListings;
    }catch(e){
     return;
    }
  }
}

final ListingProvider = StateNotifierProvider<ListingNotifier, List<Listing>>(
      (ref) => ListingNotifier(),
);
