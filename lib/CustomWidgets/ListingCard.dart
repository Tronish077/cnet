import 'package:cnet/FunctionClasses/ListingClass.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'heartBadge.dart';


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
                imageUrl:"https://via.placeholder.com/600x400",
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
          top:8,
          right:24 ,
          child: Material(
            elevation: 3, // 👈 Add your desired elevation here
            shape: const CircleBorder(), // 👈 Match the circle shape
            color: Colors.white, // 👈 Background color of the circle
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: () {},
              child: SizedBox(
                width: 28,
                height: 28,
                child: Icon(Icons.bookmark_add_outlined, size: 18),
              ),
            ),
          ),
        )
    ]
    );
  }
