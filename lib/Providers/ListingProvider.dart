import 'package:cnet/FunctionClasses/ListingClass.dart';
import '../BackendFuncs/ListingHandling.dart';
import 'package:riverpod/riverpod.dart';

class ListingNotifier extends StateNotifier<List<Listing>> {
  ListingNotifier() : super([]);

  Future<void> getListings() async {
    try {
      final List<Listing> allListings = await getHomeListings();
      state = allListings;
    }catch(e){
     return;
    }
  }
}

final ListingProvider = StateNotifierProvider<ListingNotifier, List<Listing>>(
      (ref) => ListingNotifier(),
);
