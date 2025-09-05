import '../BackendFuncs/MainBackend.dart';
import 'package:riverpod/riverpod.dart';

class FollowersNotifier extends StateNotifier<int>{
  FollowersNotifier() : super(0);

  Future getFollowerCount() async{
      final int followersCount = await getFollowers();
      return state = followersCount;
  }

  void clearFollowers(){
    state=0;
  }

}

final followersProvider = StateNotifierProvider<FollowersNotifier, int>(
      (ref) => FollowersNotifier(),
);