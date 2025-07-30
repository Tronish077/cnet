import 'package:cached_network_image/cached_network_image.dart';
import 'package:cnet/BackendFuncs/MainBackend.dart';
import 'package:cnet/FunctionClasses/ListingClass.dart';
import 'package:cnet/Providers/ListingProvider.dart';
import 'package:cnet/Providers/LoaderProvider.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
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
  final formatter = NumberFormat.decimalPattern('en_IN');
  

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
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.white,
        title: const Text(
          "Campusnet.",
          style: TextStyle(fontFamily: 'Molle', fontSize: 25),
        ),
        actions: [
          IconButton(
            onPressed:(){},
            style: IconButton.styleFrom(
                backgroundColor: Colors.blue.shade50
            ),
            icon: Icon(Icons.search_rounded,color:Theme.of(context).primaryColor,),
          ),
          IconButton(
            onPressed: () => _auth.logoutAll(context),
            icon: Icon(Icons.notifications_none,color: Theme.of(context).primaryColor,),
              style: IconButton.styleFrom(
                  backgroundColor: Colors.blue.shade50
              )
          ),
        ],
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

              const SizedBox(height: 16),

              // Search box
              // GestureDetector(
              //   onTap: () {
              //     // TODO: Navigate to search page
              //   },
              //   child: Container(
              //     padding: const EdgeInsets.all(12),
              //     decoration: BoxDecoration(
              //       color: Colors.blue.shade200,
              //       borderRadius: BorderRadius.circular(10),
              //     ),
              //     child: const Row(
              //       children: [
              //         Icon(Icons.search_rounded, size: 28),
              //         SizedBox(width: 16),
              //         Text("Search Products", style: TextStyle(fontSize: 16)),
              //       ],
              //     ),
              //   ),
              // ),

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
      ),
    );


  }

  Widget Card(Listing item,provider) {
    return Stack(

        children:[
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
                  child: CachedNetworkImage(
                    imageUrl: item.imageUrls[0],
                    height: 170,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      height: 170,
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
                    mainAxisSize: MainAxisSize.min, // Prevents overflow
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text(
                        item.title,
                        style: const TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 15),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),

                      // Price
                      Text(
                        "₹ ${formatter.format(int.parse(item.price))}",
                        style: const TextStyle(
                            fontWeight: FontWeight.w600, color: Colors.blueAccent),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: Material(
              elevation: 3,
              shape: const CircleBorder(),
              color: Colors.white,
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: () async {
                  try {
                    final notifier = ref.read(savesProvider.notifier);
                    final currentSaved = ref.read(savesProvider);

                    final statusCode = await saveListing(item);
                    bool isSaved = currentSaved.contains(item);
                    String message = "";
                    IconData icon = Icons.info_outline;

                    if (statusCode == 201) {
                      notifier.addToSaved(item);
                      message = "Added to Saved Listings";
                      icon = Icons.check_circle_outline;
                    }
                    else if (statusCode == 409 && !isSaved) {
                      notifier.addToSaved(item);
                      message = "Already in Saved items";
                      icon = Icons.info_outline;
                    }
                    else if (statusCode == 409 && isSaved) {
                      final removeStatus = await deleteSavedListing(item);
                      if (removeStatus == 200) {
                        notifier.removeSaved(item);
                        message = "Removed from Saved Listings";
                        icon = Icons.remove_circle_outline;
                      } else {
                        message = "An error occurred. Please retry.";
                        icon = Icons.error_outline;
                      }
                    }

                    // Show snackbar
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        showCloseIcon: true,
                        backgroundColor: Colors.grey[900],
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 6,
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        content: Row(
                          children: [
                            Icon(icon, color: Colors.white),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                message,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  } catch (e, stack) {
                    // Fallback error snackbar
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        backgroundColor: Colors.black87,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        elevation: 6,
                        content: Row(
                          children: [
                            Icon(Icons.error_outline, color: Colors.white),
                            SizedBox(width: 12),
                            Text(
                              "An unexpected error occurred.",
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    );

                    if (kDebugMode) print("Save Error: $e\n$stack");
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
