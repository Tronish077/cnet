import 'package:cached_network_image/cached_network_image.dart';
import 'package:cnet/Providers/viewProductProvider.dart';
import 'package:cnet/screens/NestedParts/FullmageView.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../BackendFuncs/MainBackend.dart';
import '../../FunctionClasses/ListingClass.dart';
import '../../Providers/SavedProvider.dart';

class Productview extends ConsumerStatefulWidget {
  const Productview({super.key});

  @override
  ConsumerState<Productview> createState() => _ProductviewState();
}

class _ProductviewState extends ConsumerState<Productview> {

  late int _current = 0;
  final formatter = NumberFormat.decimalPattern('en_IN');

  @override
  void initState(){
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).unfocus();  // ✅ safe here
    });
  }

  @override
  Widget build(BuildContext context) {
    final Listing item = ref.read(viewProductProvider.notifier).viewProduct();

    return Scaffold(
      appBar: AppBar(
        title: Text("Details",style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600
        ),),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: double.infinity,
                height: 360,
                child:
                item.imageUrls.length > 1 ?
                Stack(
                  children:[
                    CarouselSlider(
                    items: item.imageUrls.map((url) {
                      return Builder(
                        builder: (BuildContext context) {
                          return GestureDetector(
                            onTap: (){
                              Navigator.push(
                                context,
                                  MaterialPageRoute(
                                      builder: (context) => FullImageView(
                                          imageUrls: item.imageUrls,
                                          initialIndex: _current)
                                  )
                              );
                            },
                            child: CachedNetworkImage(
                              imageUrl: url,
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                          );
                        },
                      );
                    }).toList(),
                    options: CarouselOptions(
                      height: 360,
                      viewportFraction: 1.0,
                      enlargeCenterPage: false,
                      onPageChanged: (index, reason) {
                        setState(() {
                          _current = index;
                        });
                      },
                    ),
                  ),
                    Positioned(
                      bottom: 10,
                      right: 0,
                      left: 0,
                      child: Center( // ✅ This centers the container horizontally
                        child: Container(
                          padding: EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min, // ✅ Keeps dots tight
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: item.imageUrls.asMap().entries.map((entry) {
                              return Container(
                                width: 6.0,
                                height: 6.0,
                                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: _current == entry.key
                                      ? Colors.white
                                      : Colors.grey[600],
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    )
                  ]
                )
                :
                GestureDetector(
                  onTap: (){
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => FullImageView(
                                imageUrls: item.imageUrls,
                                initialIndex: _current)
                        )
                    );
                  },
                  child: CachedNetworkImage(
                    imageUrl: item.imageUrls[0],
                    fit: BoxFit.cover,
                    width: double.infinity,
                    errorWidget: (context, url, error) =>
                    const Icon(Icons.image_not_supported),
                  ),
                )
              ),
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //Save Icon && name
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width:300,
                            child: Text(item.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                            ),),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Color.fromARGB(32, 63, 45, 224)
                            ),
                            child: IconButton(
                              onPressed: () async {
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
                                    } else{
                                      message = "An error occurred please retry.";
                                      icon = Icons.error_outline;
                                    }
                                  }
                                  else if(statusCode == 401) {
                                    message = "Please Login Again and retry.";
                                    icon = Icons.error_outline;
                                  }
                                  else{
                                    message = message = "An error occurred. Please retry.";
                                  }

                                  // Show snackbar
                                  ScaffoldMessenger.of(context).clearSnackBars();
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
                              icon: Padding(
                                padding: const EdgeInsets.all(4), // Controls icon padding inside circle
                                child: Icon(
                                  ref.watch(savesProvider).contains(item)
                                      ? Icons.bookmark_added
                                      : Icons.bookmark_add_outlined,
                                  color: ref.watch(savesProvider).contains(item) ? Theme.of(context).primaryColor : Color.fromARGB(255, 61, 42, 234),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 6),
                      //Price Details
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          //Price
                          Text(
                            "₹ ${formatter.format(int.parse(item.price))}",
                            style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Colors.blueAccent,
                              fontSize: 18
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height:4),
                      //Location
                      Container(
                        padding: EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: Colors.red.shade50
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                                Icons.location_pin,
                              color: Colors.red,
                              size: 16,
                            ),
                            SizedBox(width: 6,),
                            Text(item.location,style: TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.w500
                            ),)
                          ],
                        ),
                      ),
                      //Contact button
                      SizedBox(height: 16),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Theme.of(context).primaryColor
                        ),
                        child: TextButton(
                            onPressed: (){
                          openWhatsApp(
                              phone: item.ownerContact,
                              message:
                              "🔔 Product Inquiry:\n\n"
                                  "🏷️ *Product:* ${item.title}"
                                  "\n💰 *Price:* ₹ ${formatter.format(int.parse(item.price))}\n\n"
                                  "🖼️ *Image Link:* $mainUrl/product?id=${item.id}\n\n"
                                  "Hello, I'm interested in this product. "
                                  "Please let me know if it's still available."
                          );
                        },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Contact Seller",
                                  style:TextStyle(color: Colors.white) ,),
                                SizedBox(width:8),
                                Icon(
                                   FontAwesomeIcons.whatsapp
                                ,color: Colors.white)
                              ],
                            )
                        ),
                      ),
                      SizedBox(height:16),
                      Text("Sellers Details",style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w600

                      ),),
                      SizedBox(height: 4),
                      //User banner
                      Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          //Profile Image
                          Row(
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.all(Radius.circular(30)),
                                child: item.ownerProfileImage.isNotEmpty ?
                                CachedNetworkImage(
                                    width: 40,
                                    height: 40,
                                    imageUrl: item.ownerProfileImage
                                )
                                    :
                                Image.asset(
                                    width: 40,
                                    height: 40,
                                    'assets/Default_pfp.jpg'
                                )
                                ,
                              ),
                              SizedBox(width: 12,),
                              //Name and PD owner
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(item.ownerName,style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600
                                      )),
                                      SizedBox(width: 4),
                                      Icon(Icons.verified,size: 15,color: Colors.blue,)
                                    ],
                                  ),
                                  Text("Product Owner",style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400
                                  ))
                                ],
                              ),

                            ],
                          ),
                          //Follow Button
                          OutlinedButton(onPressed:(){
                            followUser(item);
                          },
                              style:OutlinedButton.styleFrom(
                                  side: const BorderSide(
                                    color: Color.fromARGB(79, 61, 42, 234), // Border color
                                    width: 1,           // Border thickness
                                  ),
                                backgroundColor:Color.fromARGB(23, 61, 42, 234),
                              ),
                              child: Text("Follow",style: TextStyle(
                                  color: Theme.of(context).primaryColor
                              ),))
                        ],
                      ),
                      Divider(),
                      //User Banner
                      //Description
                      SizedBox(height:16),
                      Text("Product Description",style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w600

                      ),),
                      SizedBox(height: 2),
                      Text(item.description),
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }

}
