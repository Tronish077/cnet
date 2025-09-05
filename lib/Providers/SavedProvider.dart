import 'dart:core';
import 'dart:math';
import 'package:cnet/BackendFuncs/MainBackend.dart';
import 'package:cnet/FunctionClasses/ListingClass.dart';
import 'package:cnet/Providers/LoaderProvider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod/riverpod.dart';

class SavedNotifier extends StateNotifier<List<Listing>>{
  SavedNotifier() : super([]);

  void addToSaved(Listing item) {
    final alreadyExists = state.any((e) => e.id == item.id);
    if (!alreadyExists) {
      state = [ item,...state];
    }
  }

  void removeSaved(Listing item){
    state = state.where((prod) => prod != item).toList();
  }

  void resetAll(){
    state = [];
  }

  Future<void> myListings(WidgetRef ref,context,{bool shuffle = false}) async {
    try {
      final List<Listing> allListings = await getSavedListings();
      // Keep only the new listings (i.e., not in current state)
      final newOnes = allListings.where((ele) => !state.contains(ele)).toList();

      // Add new items to the front of the state
      state = [...newOnes, ...state];
    } catch (e) {
      return;
    }
  }
}


final savesProvider = StateNotifierProvider<SavedNotifier, List<Listing>>(
      (ref) => SavedNotifier(),
);