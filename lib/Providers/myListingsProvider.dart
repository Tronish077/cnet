import 'dart:math';
import 'package:cnet/BackendFuncs/ListingHandling.dart';
import 'package:cnet/FunctionClasses/ListingClass.dart';
import 'package:riverpod/riverpod.dart';
import '../BackendFuncs/MainBackend.dart';

class myListingsNotifier extends StateNotifier<List<Listing>>{
    myListingsNotifier():super([]);

    Future<void> getListings({bool shuffle = true}) async {
      try {
        final List<Listing> allListings = await getProfileListings();
        if(shuffle){
          allListings;
        }

        state = allListings;

      }catch(e){
        return;
      }
    }

    Future deleteListing(Listing item) async {
      try {
        final statusCode = await deleteListingFunc(item.id);
        if (statusCode == 200) {
          print(statusCode);
          state = state.where((itm) => itm.id != item.id).toList();
        }else{
          print(statusCode);
        }
      }catch(e){
        return;
    }
}
}

final myListingsProvider = StateNotifierProvider<myListingsNotifier, List<Listing>>(
    (ref) => myListingsNotifier(),
);