import 'package:cached_network_image/cached_network_image.dart';
import 'package:cnet/BackendFuncs/MainBackend.dart';
import 'package:cnet/FunctionClasses/ListingClass.dart';
import 'package:cnet/Providers/ListingProvider.dart';
import 'package:intl/intl.dart';
import 'package:cnet/Providers/SavedProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Savestab extends ConsumerStatefulWidget {
  const Savestab({super.key});

  @override
  ConsumerState<Savestab> createState() => _SavestabState();
}

class _SavestabState extends ConsumerState<Savestab> {
  final formatter = NumberFormat.decimalPattern('en_IN');

  @override
  Widget build(BuildContext context) {
    final allSaves = ref.watch(savesProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar:AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      title: Row(
        children: [
          Icon(Icons.book, color: Theme.of(context).primaryColor),
          SizedBox(width: 8),
          Text(
            "Saved Listings",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.black),
          ),
        ],
      ),
    ),

      body: allSaves.isEmpty
          ? Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.bookmark_add_outlined, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 12),
            Text(
              "No saved items yet",
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "Tap the bookmark icon to save listings.",
              style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
            ),
          ],
        ),
      )
          : Padding(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Saved Listings (${allSaves.length})",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.only(bottom: 12),
                itemCount: allSaves.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 0,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.7,
                ),
                itemBuilder: (context, index) {
                  final listing = allSaves[index];
                  return SavesCard(listing, allSaves);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget SavesCard(Listing item,provider) {
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
                        "₹ ${formatter.format(int.parse(item.price))}",
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
            right: 28,
            child: Material(
              elevation: 3,
              shape: const CircleBorder(),
              color: Colors.white,
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: () async{
                  if (provider.contains(item)) {
                    await deleteSavedListing(item);
                    ref.read(savesProvider.notifier).removeSaved(item);
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(4), // Controls icon padding inside circle
                  child: Icon(Icons.cancel_outlined,
                    size: 22,
                    color: provider.contains(item) ? Colors.red : Colors.black,
                  ),
                ),
              ),
            ),
          ),

        ]
    );
  }

}
