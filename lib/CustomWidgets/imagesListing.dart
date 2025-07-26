// import 'package:flutter/material.dart';
// import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';

// class MultipleImages extends StatefulWidget {
//   final List<String> imageUrls;

//   const MultipleImages({super.key, required this.imageUrls});

//   @override
//   State<MultipleImages> createState() => _MultipleImagesState();
// }

// class _MultipleImagesState extends State<MultipleImages> {
//   int currentPage = 1;

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         ImageSlideshow(
//             width: double.infinity,
//             height: 400,
//             initialPage: 0,
//             indicatorColor: widget.imageUrls.length > 1 ? Colors.white : Colors.transparent,
//             indicatorBottomPadding: 10,
//             onPageChanged: (int index) {
//               setState(() {
//                 currentPage = index + 1; // for 1-based index
//               });
//             },
//             indicatorBackgroundColor:
//             widget.imageUrls.length > 1 ? Colors.grey : Colors.transparent,
//             children: widget.imageUrls
//                 .map(
//                   (img) => ClipRRect(
//                     borderRadius: BorderRadius.circular(2),
//                     child: Image.network(
//                       img,
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//             )
//                 .toList(), 
//         ),
//         if (widget.imageUrls.length > 1)
//           Positioned(
//             right: 8,
//             top: 8,
//             child: Container(
//               padding: EdgeInsets.symmetric(vertical: 4, horizontal: 12),
//               decoration: BoxDecoration(
//                   color: Colors.black, borderRadius: BorderRadius.circular(15)),
//               child: Text(
//                 "$currentPage / ${widget.imageUrls.length}",
//                 style: TextStyle(fontSize: 13, color: Colors.white),
//               ),
//             ),
//           )
//       ],
//     );
//   }
// }
