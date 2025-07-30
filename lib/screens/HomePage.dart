import 'package:cnet/Providers/ListingProvider.dart';
import 'package:cnet/screens/Sections/HomeTab.dart';
import 'package:cnet/screens/Sections/CreatePost.dart';
import 'package:cnet/screens/Sections/savesTab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';
import '../../Auth/Auth.dart';

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
    PostListingPage(),
    Savestab()
  ];


  void _onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // TODO: handle refresh or no on 1st page show
    //
    // if (index == 0) { // Home page index
    //   ref.read(ListingProvider.notifier).getListings(); // ✅ Force refresh
    // }
  }


  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _selectedIndex == 0, // Only allow system back pop when on home
      onPopInvoked: (didPop) {
        if (!didPop && _selectedIndex != 0) {
          setState(() {
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
          currentIndex: _selectedIndex,
          snakeShape: SnakeShape.indicator,
          onTap: _onTabTapped,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.search_rounded), label: 'Explore'),
            BottomNavigationBarItem(icon: Icon(Icons.add_circle_outline_rounded), label: 'Post'),
            BottomNavigationBarItem(icon: Icon(Icons.bookmark_border_rounded), label: ''),
            BottomNavigationBarItem(icon: Icon(Icons.person_outline_rounded), label: ''),
          ],
        ),
        body: IndexedStack(
          index: _selectedIndex,
          children: _pages,
        ),
      ),
    );
  }


}
