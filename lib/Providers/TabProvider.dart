import 'package:riverpod/riverpod.dart';

class TabNotifier extends StateNotifier<int>{
    TabNotifier() : super(0);

    int changeTab(int index){
      state = index;
      return state;
    }

}


final tabProvider = StateNotifierProvider<TabNotifier, int>(
      (ref) => TabNotifier(),
);