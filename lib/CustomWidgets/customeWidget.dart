import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
// import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
// import 'package:mvp/CustomWidgets/CommentPanel.dart';
// import 'package:mvp/CustomWidgets/imagesListing.dart';
// import 'package:mvp/FunctionClasses/ListingClass.dart';
// import 'package:readmore/readmore.dart';
// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:video_player/video_player.dart';

class CustomWidgets {

  Future LoaderSpinner(BuildContext context, {String words = "Please Wait.."}) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        useRootNavigator: true,
        builder: (BuildContext context) {
          return Dialog(
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white
              ),
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  LoadingAnimationWidget.fourRotatingDots(
                      color: Theme
                          .of(context)
                          .primaryColor,
                      size: 24)
                  ,
                  SizedBox(height: 4),
                  Text(words)
                ],
              ),
            ),
          );
        });
  }

  Widget notificationIcon(text, context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.notifications_none),
          padding: EdgeInsets.all(8),
          style: IconButton.styleFrom(
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.padded,
          ),
          color: Colors.black,
        ),
        Positioned(
          right: 4,
          top: 2,
          child: Container(
            height: 21,
            width: 21,
            decoration: BoxDecoration(
              color: Theme
                  .of(context)
                  .primaryColor,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget categorieButton(text, bool selected, context) {
    return Container(
      margin: const EdgeInsets.only(right: 4),
      child: TextButton(
        onPressed: () {},
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          backgroundColor: selected
              ? Theme
              .of(context)
              .primaryColor
              : const Color.fromARGB(24, 6, 75, 223),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(120),
            side: selected
                ? BorderSide.none
                : const BorderSide(
              width: 2,
              color: Color.fromARGB(92, 6, 75, 223),
            ),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: selected ? Colors.white : Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget messagesIcon(text, context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.message_outlined),
          padding: EdgeInsets.all(8),
          style: IconButton.styleFrom(
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.padded,
          ),
          color: Colors.black,
        ),
        Positioned(
          right: 4,
          top: 2,
          child: Container(
            height: 21,
            width: 21,
            decoration: BoxDecoration(
              color: Theme
                  .of(context)
                  .primaryColor,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
  }

//   Widget imageListing(scrnWidth, scrnHeight, Listing listing,context) {
//     return Container(
//       decoration: BoxDecoration(
//           color: Colors.white60,
//           border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
//           borderRadius: BorderRadius.circular(0)
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             child:
//             Column(
//               children:[
//               Container(
//                 padding: EdgeInsets.symmetric(horizontal: 13,vertical: 8),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Row(children: [
//                       CircleAvatar(
//                         backgroundImage: NetworkImage(
//                             "https://images.pexels.com/photos/774909/pexels-photo-774909.jpeg?auto=compress&cs=tinysrgb&w=600"),
//                         radius: 20.0,
//                       ),
//                       SizedBox(width: scrnWidth * 0.03),
//                       Text(listing.ownerName, style: TextStyle(
//                           fontWeight: FontWeight.w600,
//                           fontSize: 14
//                       ),),
//                       SizedBox(width: scrnWidth * 0.03),
//                       Icon(Icons.stars_rounded, color: Colors.yellow[900], size: 12,),
//                       Text(" ${listing.ratings} (${listing.ratingsCount})", style: TextStyle(fontSize: 11,fontWeight: FontWeight.w600),),
//                     ],),
//             ],
//                 ),
//                   ReadMoreText(
//                   "${listing.subtitle}",
//                   trimLines: 2,
//                   colorClickableText: Colors.grey[400],
//                   trimMode: TrimMode.Line,
//                   trimCollapsedText: ' See More...',
//                   trimExpandedText: ' \nSee Less...',
//                   style: TextStyle(color: Colors.black87,
//                       fontSize: 15,
//                       fontWeight: FontWeight.w500),
//                   moreStyle: TextStyle(fontSize: 12,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.grey[600]),
//                   lessStyle: TextStyle(fontSize: 12,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.grey[600]),
//                 ),
//                   ]
//                 ),
//               ),
//               SizedBox(height: scrnHeight * 0.01),
//               MultipleImages(imageUrls: listing.imageUrls!),
//               SizedBox(height: scrnHeight * 0.01),
//               //Metrics Row
//                 Container(
//                   padding: EdgeInsets.symmetric(horizontal: 14),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Row(
//                             children: [
//                               OutlinedButton(onPressed: () {},
//                                   style: OutlinedButton.styleFrom(
//                                       backgroundColor: Colors.indigo,
//                                       padding: EdgeInsets.symmetric(
//                                           horizontal: 12, vertical: 6),
//                                       minimumSize: Size(0, 0),
//                                       side: BorderSide(width: 2, color: Colors.indigo)
//                                   ),
//                                   child: Text("Follow + ",
//                                     style: TextStyle(fontSize: 12, color: Colors.white),
//                                   )),
//                               SizedBox(width: scrnWidth * 0.02),
//                               OutlinedButton(onPressed: () {},
//                                   style: OutlinedButton.styleFrom(
//                                       padding: EdgeInsets.symmetric(
//                                           horizontal: 12, vertical: 6),
//                                       minimumSize: Size(0, 0),
//                                       side: BorderSide(width: 1)
//                                   ),
//                                   child: Text("Message",
//                                     style: TextStyle(fontSize: 12, color: Colors.black),
//                                   ))
//                             ],
//                           ),
//                           Row(children: [
//                             //Interaction's box
//                             IconButton(
//                               icon: Icon(Icons.mode_comment_outlined), onPressed: () {
//                               _showCommentSheet(context,listing.id);
//                             },),
//                             Text("${listing.commentCount}", style: TextStyle(fontSize: 12),),
//                             SizedBox(width: scrnWidth * 0.02),
//                             IconButton(icon: Icon(Icons.bookmark_border_rounded), onPressed: () {},),
//                             Text("${listing.shareCount}", style: TextStyle(fontSize: 12),)
//                           ],),
//                         ],
//                       ),
//                       Text(
//                         "3 Days ago",
//                         style: TextStyle(
//                             fontSize: 12,
//                             color: Colors.grey[500]
//                         ),
//                       ),
//                     ],
//                   ),
//                 )
//               ]
//             )
//           ),
//         ],
//       ),
//     );
//   }

//   Widget textListing(scrnWidth, scrnHeight,Listing listing, context){
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 16),
//       decoration: BoxDecoration(
//         color: Colors.white60,
//         borderRadius: BorderRadius.circular(12),
//         border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Row(children: [
//                 CircleAvatar(
//                   backgroundImage: NetworkImage(
//                       "https://images.pexels.com/photos/774909/pexels-photo-774909.jpeg?auto=compress&cs=tinysrgb&w=600"),
//                   radius: 16.0,
//                 ),
//                 SizedBox(width: scrnWidth * 0.03),
//                 Text(listing.ownerName, style: TextStyle(
//                     fontWeight: FontWeight.w600,
//                     fontSize: 14
//                 ),),
//                 SizedBox(width: scrnWidth * 0.03),
//                 Icon(Icons.stars_rounded, color: Colors.yellow[900], size: 12,),
//                 Text("${listing.ratings} (${listing.ratingsCount})",
//                   style: TextStyle(fontSize: 11),),
//               ],),
//               IconButton(onPressed: () {}, icon: Icon(Icons.more_horiz_rounded))
//             ],
//           ),
//           SizedBox(height: scrnHeight * 0.002),
//           ReadMoreText(
//            "${listing.subtitle}",
//             trimLines: 2,
//             colorClickableText: Colors.grey[400],
//             trimMode: TrimMode.Line,
//             trimCollapsedText: ' See More...',
//             trimExpandedText: ' \nSee Less...',
//             style: TextStyle(color: Colors.black87,
//                 fontSize: 15,
//                 fontWeight: FontWeight.w500),
//             moreStyle: TextStyle(fontSize: 12,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.grey[600]),
//             lessStyle: TextStyle(fontSize: 12,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.grey[600]),
//           ),
//           SizedBox(height: scrnHeight * 0.005),
//           //metrics
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Row(
//                 children: [
//                   OutlinedButton(onPressed: () {},
//                       style: OutlinedButton.styleFrom(
//                           backgroundColor: Colors.indigo,
//                           padding: EdgeInsets.symmetric(
//                               horizontal: 12, vertical: 6),
//                           minimumSize: Size(0, 0),
//                           side: BorderSide(width: 2, color: Colors.indigo)
//                       ),
//                       child: Text("Follow + ",
//                         style: TextStyle(fontSize: 12, color: Colors.white),
//                       )),
//                   SizedBox(width: scrnWidth * 0.02),
//                   OutlinedButton(onPressed: () {},
//                       style: OutlinedButton.styleFrom(
//                           padding: EdgeInsets.symmetric(
//                               horizontal: 12, vertical: 6),
//                           minimumSize: Size(0, 0),
//                           side: BorderSide(width: 1)
//                       ),
//                       child: Text("Message",
//                         style: TextStyle(fontSize: 12, color: Colors.black),
//                       ))
//                 ],
//               ),
//               Row(children: [
//                 //Interaction's box
//                 IconButton(
//                   icon: Icon(Icons.mode_comment_outlined), onPressed: () {
//                   _showCommentSheet(context, listing.id);
//                 },),
//                 Text("${listing.commentCount}", style: TextStyle(fontSize: 12),),
//                 SizedBox(width: scrnWidth * 0.02),
//                 IconButton(icon: Icon(Icons.bookmark_border_rounded), onPressed: () {},),
//                 Text("${listing.shareCount}", style: TextStyle(fontSize: 12),)
//               ],),
//             ],
//           ),
//           Text(
//             "3 Days ago",
//             style: TextStyle(
//                 fontSize: 12,
//                 color: Colors.grey[500]
//             ),
//           ),
//         ],
//       ),
//     );
//   }
  
//   Widget topBar(context){
//     return Container(
//       decoration: BoxDecoration(
//           border: Border(bottom:BorderSide(color: Colors.black12))
//       ),
//       padding: EdgeInsets.symmetric(vertical: 8,horizontal: 12),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             "CampusNet.",
//             style: TextStyle(
//                 fontFamily: 'Molle',
//                 color: Colors.black,
//                 fontSize: 24
//             ),
//           ),
//           Row(
//             children: [
//               notificationIcon("0",context),
//               messagesIcon("0",context)
//             ],
//           )
//         ],
//       ),
//     );
//   }

//   Widget featuredTitle() {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//       decoration: BoxDecoration(
//         color: Colors.grey[50], // Light background to separate section
//         border: Border(
//           bottom: BorderSide(color: Colors.black12),
//         ),
//       ),
//       child: Row(
//         children: [
//           Icon(Icons.star_rounded, color: Colors.amber[700]),
//           const SizedBox(width: 8),
//           Text(
//             "Featured Listings",
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.w600,
//               letterSpacing: 0.3,
//               color: Colors.black87,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

// }


// void _showCommentSheet(BuildContext context, String postId){
//   showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20))
//       ),
//       builder:(context){
//         return DraggableScrollableSheet(
//             initialChildSize: 0.75, // Start from 75% screen height
//             minChildSize: 0.4,     // Minimum height on drag down
//             maxChildSize: 0.85,    // Maximum height when pulled up
//             expand: false,
//             builder: (_,controller) => Padding(
//               padding:  EdgeInsets.only(
//                 bottom: MediaQuery.of(context).viewInsets.bottom
//               ),
//               child: CommentPanel(postId: postId, controller: controller),
//             )
//         );
//       });
// }