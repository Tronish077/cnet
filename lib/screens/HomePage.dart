import 'package:cnet/Providers/FollowProvider.dart';
import 'package:cnet/Providers/SavedProvider.dart';
import 'package:cnet/Providers/myListingsProvider.dart';
import 'package:cnet/screens/Sections/HomeTab.dart';
import 'package:cnet/screens/Sections/CreatePost.dart';
import 'package:cnet/screens/Sections/ProfileTab.dart';
import 'package:cnet/screens/Sections/SearchTab.dart';
import 'package:cnet/screens/Sections/savesTab.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';
import '../../Auth/Auth.dart';
import '../Providers/TabProvider.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  int _selectedIndex = 0;
  final _auth = MyAuth();

  // Dummy category + listing data
  final List<String> categories = ['All', 'Services', 'Furniture', 'Electronics', 'Womenswear', 'Menswear'];
  String selectedCategory = 'All';

  final List<Widget> _pages = [
    HomeTab(),
    Searchtab(),
    PostListingPage(),
    Savestab(),
    profileTab()
  ];


  void _onTabTapped(int index) async{
    setState(() {
      ref.watch(tabProvider.notifier).changeTab(index);
      _selectedIndex = ref.watch(tabProvider);
    });

    // TODO: handle refresh or no on 1st page show
    //
    if (index == 4) { // Home page index
      ref.watch(followersProvider.notifier).getFollowerCount();
      ref.watch(myListingsProvider.notifier).getListings();
      await ref.read(savesProvider.notifier).myListings(ref,context); // ✅ Force refresh
    }else if(index == 3){
      await ref.read(savesProvider.notifier).myListings(ref,context);
    }
  }

  @override
  void initState(){
    super.initState();
    Future.microtask(() async {
      ref.watch(savesProvider.notifier).resetAll();
      if (!mounted) return; // ✅ safe here
      ref.watch(followersProvider.notifier).getFollowerCount();
      ref.watch(tabProvider.notifier).changeTab(0);
      ref.watch(myListingsProvider.notifier).getListings(); //
      ref.watch(savesProvider.notifier).myListings;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _selectedIndex == 0, // Only allow system back pop when on home
      onPopInvoked: (didPop) {
        if (!didPop && _selectedIndex != 0) {
          setState(() {
            ref.watch(tabProvider.notifier).changeTab(0);
            _selectedIndex = 0; // Go to Home tab
          });
        }
      },
      child: Scaffold(
        bottomNavigationBar: SnakeNavigationBar.color(
          selectedItemColor: Theme.of(context).primaryColor,
          snakeViewColor: Theme.of(context).primaryColor,
          backgroundColor: Colors.white,
          unselectedItemColor: Colors.black,
          currentIndex: ref.watch(tabProvider),
          snakeShape: SnakeShape.indicator,
          onTap: _onTabTapped,
          items: const [
            BottomNavigationBarItem(icon: Icon(FontAwesomeIcons.house, size: 20,), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(FontAwesomeIcons.magnifyingGlass, size: 20), label: 'Explore'),
            BottomNavigationBarItem(icon: Icon(FontAwesomeIcons.circlePlus,size: 20), label: 'Post'),
            BottomNavigationBarItem(icon: Icon(FontAwesomeIcons.bookmark,size: 20), label: ''),
            BottomNavigationBarItem(icon: Icon(FontAwesomeIcons.user,size: 20), label: ''),
          ],
        ),
        body: IndexedStack(
          index: ref.watch(tabProvider),
          children: _pages,
        ),
      ),
    );
  }


}
