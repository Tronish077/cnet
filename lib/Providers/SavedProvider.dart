import 'dart:core';

import 'package:cnet/FunctionClasses/ListingClass.dart';
import 'package:riverpod/riverpod.dart';

class SavedNotifier extends StateNotifier<List<Listing>>{
  SavedNotifier() : super([]);

  void addToSaved(Listing item){
    if(state.contains(item)){
      return;
    }else{
      state = [...state,item];
    }
  }

  void removeSaved(Listing item){
    state = state.where((prod) => prod != item).toList();
  }

}


final savesProvider = StateNotifierProvider<SavedNotifier, List<Listing>>(
      (ref) => SavedNotifier(),
);