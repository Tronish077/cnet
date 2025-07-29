import 'package:cached_network_image/cached_network_image.dart';
import 'package:cnet/FunctionClasses/ListingClass.dart';
import 'package:cnet/Providers/ListingProvider.dart';
import 'package:cnet/Providers/LoaderProvider.dart';
import 'package:cnet/Providers/SavedProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../Auth/Auth.dart';

class HomeTab extends ConsumerStatefulWidget {
  const HomeTab({super.key});

  @override
  ConsumerState<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends ConsumerState<HomeTab> {
  final _auth = MyAuth();

  // Dummy category + listing data
  final List<String> categories = ['All', 'Services', 'Furniture', 'Electronics', 'Womenswear', 'Menswear'];
  String selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.watch(ListingProvider.notifier).getListings(); // fetch once
    });
  }



  @override
  Widget build(BuildContext context) {

    final allProducts = ref.watch(ListingProvider);
    final allSaves = ref.watch(savesProvider);
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Campusnet.",
          style: TextStyle(fontFamily: 'Molle', fontSize: 25),
        ),
        actions: [
          IconButton(
            onPressed: () => _auth.logoutAll(context),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),


      body:
      Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Headline
            const Text(
              "Today's Look",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const Text("Browse any products of your choice",
                style: TextStyle(fontWeight: FontWeight.w300)),

            const SizedBox(height: 16),

            // Search box
            GestureDetector(
              onTap: () {
                // TODO: Navigate to search page
              },
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade200,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.search_rounded, size: 28),
                    SizedBox(width: 16),
                    Text("Search Products", style: TextStyle(fontSize: 16)),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            Text("Categories", style: TextStyle(
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
                    child: ChoiceChip(
                      selectedColor: Colors.blue.shade100,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20), // 👈 change this radius
                      ),
                      label: Text(cat,style:TextStyle(
                          fontSize: 12
                      ),),
                      selected: selectedCategory == cat,
                      onSelected: (_) {
                        setState(() {
                          selectedCategory = cat;
                        });
                      },
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 16),

            // Listings
            allProducts.isNotEmpty ?
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.symmetric( vertical: 10),
                itemCount: allProducts.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // 👈 Two items per row
                  crossAxisSpacing: 2,
                  mainAxisSpacing: 2,
                  childAspectRatio: 3 / 4, // 👈 Adjust height/width ratio
                ),
                itemBuilder: (context, index) {
                  final listing = allProducts[index];

                  return Card(listing,allSaves);
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
    );


  }

  Widget Card(Listing item,provider) {
    return Stack(

        children:[
          Container(
            width: 170,
            padding: EdgeInsets.only(right: 6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
                  child: CachedNetworkImage(
                    imageUrl:item.imageUrls[0],
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      height: 180,
                      width: double.infinity,
                      color: Colors.grey.shade200,
                      child: const Center(
                        child: CircularProgressIndicator(color: Colors.blue),
                      ),
                    ),
                    errorWidget: (context, url, error) =>
                    const Icon(Icons.image_not_supported),
                  ),
                ),

                // Info
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text(
                        item.title,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),

                      const SizedBox(height: 4),

                      // Price
                      Text(
                        "₹${item.price}",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.blueAccent),
                      ),

                      const SizedBox(height: 4),

                      // // Location
                      // Row(
                      //   children: [
                      //     const Icon(Icons.location_on, size: 12, color: Colors.grey),
                      //     const SizedBox(width: 4),
                      //     Expanded(
                      //       child: Text(
                      //         location,
                      //         style: const TextStyle(fontSize: 12, color: Colors.grey),
                      //         overflow: TextOverflow.ellipsis,
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      //
                      // const SizedBox(height: 4),
                      //
                      // // Owner + Time
                      // Row(
                      //   children: [
                      //     const Icon(Icons.person, size: 12, color: Colors.grey),
                      //     const SizedBox(width: 4),
                      //     Text(
                      //       ownerName,
                      //       style: const TextStyle(fontSize: 11, color: Colors.grey),
                      //     ),
                      //   ],
                      // )
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 8,
            right: 24,
            child: Material(
              elevation: 3,
              shape: const CircleBorder(),
              color: Colors.white,
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: () {
                  if (provider.contains(item)) {
                    ref.read(savesProvider.notifier).removeSaved(item);
                  } else {
                    ref.read(savesProvider.notifier).addToSaved(item);
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(4), // Controls icon padding inside circle
                  child: Icon(
                    provider.contains(item)
                        ? Icons.bookmark_add
                        : Icons.bookmark_add_outlined,
                    size: 22,
                    color: provider.contains(item) ? Colors.orange : Colors.black,
                  ),
                ),
              ),
            ),
          ),

        ]
    );
  }
}
