import 'package:cnet/CustomWidgets/customeWidget.dart';
import 'package:cnet/Providers/ListingProvider.dart';
import 'package:cnet/Providers/LoaderProvider.dart';
import 'package:intl/intl.dart';
import 'package:cnet/Providers/SavedProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../Auth/Auth.dart';
import '../../Providers/FollowProvider.dart';

class HomeTab extends ConsumerStatefulWidget {
  const HomeTab({super.key});

  @override
  ConsumerState<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends ConsumerState<HomeTab> {
  final _auth = MyAuth();
  final custom = CustomWidgets();

  // Dummy category + listing data
  final List<String> categories = ['All','Electronics','Furniture','Clothes','Shoes', 'Wearables','Accessories'];
  String selectedCategory = 'All';
  final formatter = NumberFormat.decimalPattern('en_IN');
  

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.watch(ListingProvider.notifier).getListings();// fetch once
      ref.watch(followersProvider.notifier).clearFollowers();
      ref.watch(followersProvider.notifier).getFollowerCount();// clear followers
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).unfocus();  // ✅ safe here
    });
  }



  @override
  Widget build(BuildContext context) {

    final allProducts = ref.watch(ListingProvider);
    final allSaves = ref.watch(savesProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.white,
        title: const Text(
          "Campusnet.",
          style: TextStyle(fontFamily: 'Molle', fontSize: 25),
        ),
      ),


      body:
      RefreshIndicator(
        backgroundColor: Colors.white,
        color: Colors.blueAccent,
        onRefresh: () async{
          await ref.watch(ListingProvider.notifier).getListings(shuffle: true);
          },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Headline
              const Text(
                "Today's Look",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 4),
              const Text("Browse any products of your choice",
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                    fontSize: 16
                  )),
              const SizedBox(height: 12),

              Text("Filters", style: TextStyle(
                  fontWeight: FontWeight.w600
              ),),
              const SizedBox(height: 10),
              // Category chips
              SizedBox(
                height: 40,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final cat = categories[index];
                    return Padding(
                      padding: const EdgeInsets.only(right: 6),
                        child : Theme(
                          data: Theme.of(context).copyWith(
                            chipTheme: Theme.of(context).chipTheme.copyWith(
                              checkmarkColor: Colors.white, // 👈 Set check icon color here
                            ),
                          ),
                          child: ChoiceChip(
                            selectedColor: Theme.of(context).primaryColor,
                            backgroundColor: Colors.grey.shade200,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            label: Text(
                              cat,
                              style: TextStyle(
                                fontSize: 12,
                                color: selectedCategory == cat ? Colors.white : Colors.black,
                              ),
                            ),
                            selected: selectedCategory == cat,
                            onSelected: (_) {
                              setState(() {
                                selectedCategory = cat;
                              });
                            },
                          ),
                        )
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              Divider(color: Colors.grey.shade100,),

              // Listings
              allProducts.isNotEmpty ?
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.symmetric( vertical: 10),
                  itemCount: allProducts.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // 👈 Two items per row
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 0,
                    childAspectRatio: 3/4, // 👈 Adjust height/width ratio
                  ),
                  itemBuilder: (context, index) {
                    final listing = allProducts[index];

                    return custom.MainCard(listing,ref,context);
                  },
                ),
              ):
                  Expanded(child:
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,

                      children: [
                        Icon(Icons.error,size: 40,),
                        SizedBox(height: 8),
                        Text("Something went wrong"),
                        SizedBox(height: 8),
                        FilledButton.icon(onPressed: ()async{
                          ref.watch(loadingProvider.notifier).startLoading(context);
                          await ref.read(ListingProvider.notifier).getListings();
                          ref.watch(loadingProvider.notifier).stopLoading(context);
                        },
                            style: IconButton.styleFrom(
                              backgroundColor: Colors.transparent
                            ),
                            icon: Icon(Icons.loop_rounded,color: Colors.blue),
                            label: Text("Retry",style:TextStyle(
                                color: Colors.blue
                            ),
                            ),
                        )
                      ],
                    ),
                  ))
            ],
          ),
        ),
      ),
    );


  }


}
