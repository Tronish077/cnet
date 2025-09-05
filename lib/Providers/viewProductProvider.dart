import 'package:cnet/FunctionClasses/ListingClass.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod/riverpod.dart';


class ViewProductNotifier extends StateNotifier<List<Listing>>{
  ViewProductNotifier() : super([]);

  void addToview(Listing item){
    state = [item];
  }

  Listing viewProduct(){
    return state[0];
  }

  void clearView(){
    state = [];
  }

}

final viewProductProvider = StateNotifierProvider<ViewProductNotifier,List<Listing>>(
    (ref) => ViewProductNotifier()
);
