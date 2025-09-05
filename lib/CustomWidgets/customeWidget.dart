import 'package:cached_network_image/cached_network_image.dart';
import 'package:cnet/FunctionClasses/ListingClass.dart';
import 'package:cnet/Providers/viewProductProvider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../BackendFuncs/MainBackend.dart';
import '../Providers/SavedProvider.dart';
import '../Providers/myListingsProvider.dart';

class CustomWidgets {

  final formatter = NumberFormat.decimalPattern('en_IN');

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

  Future<void> awaitSpinner(BuildContext context) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      useRootNavigator: true,
      builder: (BuildContext context) {
        return Dialog(
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.only(top:5),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                LoadingAnimationWidget.twistingDots(
                  size: 24, // Compact size
                  leftDotColor: Theme.of(context).primaryColor,
                  rightDotColor: Colors.blueAccent,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget MainCard(Listing item,WidgetRef ref,context) {
    return GestureDetector(
      onTap: (){
        ref.watch(viewProductProvider.notifier).addToview(item);
        Navigator.of(context).pushNamed('/productView');
      },
      child: Stack(

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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "₹ ${formatter.format(int.parse(item.price))}",
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600, color: Colors.blueAccent),
                            ),
                            Container(
                              padding:EdgeInsets.symmetric(horizontal: 2),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(2),
                                // color: Colors.orange.shade300
                              ),
                              child: Text("(${item.condition})",style:
                                TextStyle(
                                  overflow: TextOverflow.ellipsis,
                                  fontWeight: FontWeight.w400
                                ),),
                            )
                          ],
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
                  child: Padding(
                    padding: const EdgeInsets.all(4), // Controls icon padding inside circle
                    child: Icon(
                      ref.read(savesProvider).contains(item)
                          ? Icons.bookmark_add
                          : Icons.bookmark_add_outlined,
                      size: 22,
                      color: ref.read(savesProvider).contains(item) ? Colors.orange : Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          ]
      ),
    );
  }

  Widget PfpItemCard(Listing item,WidgetRef ref,context) {
    return GestureDetector(
      onTap: (){
        ref.watch(viewProductProvider.notifier).addToview(item);
        Navigator.of(context).pushNamed('/productView');
      },
      child: Stack(
          children:[
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
                // boxShadow: [
                //   BoxShadow(
                //     color: Colors.grey.withOpacity(0.2),
                //     blurRadius: 4,
                //     offset: const Offset(0, 2),
                //   ),
                // ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image
                  ClipRRect(
                    borderRadius:BorderRadius.circular(2),
                    child: CachedNetworkImage(
                      imageUrl: item.imageUrls[0],
                      height: 100,
                      width: 100,
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
                  SizedBox(width: 8),
                  // Info
                  Expanded(
                    child: Padding(
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
                          Row(
                            children: [
                              Text("₹ ${formatter.format(int.parse(item.price))}",
                                style: TextStyle(fontWeight: FontWeight.w600, color: Colors.blueAccent),),
                              SizedBox(width: 8,),
                              Text("${item.imageUrls.length} image(s)",
                                style: TextStyle(fontWeight: FontWeight.w600, color: Colors.blue.shade700),)
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                height: 35,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: TextButton.icon(
                                  onPressed: (){
                                    showDialogBox(context,ref,item);
                                  },
                                  label: Text("Delete From Store",style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.w600,
                                  ),),
                                  icon: Icon(Icons.delete_outline,
                                    color: Colors.red, )
                                ),
                              ),
                              IconButton(
                                onPressed: (){},
                                style: IconButton.styleFrom(
                                  backgroundColor:Colors.blue.shade50
                                ),
                                color: Color.fromARGB(255, 61, 42, 234),
                                icon: Icon(FontAwesomeIcons.share),
                              )
                            ],
                          )
                          // Price
                        ],
                      ),
                    ),
                  ),

                ],
              ),
            ),
          ]
      ),
    );
  }

  Widget textBoxCustom(TextEditingController controller, String labelTxt,String errorText,IconData icn,{dynamic maxLines = 1} ){
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        prefixIcon: Icon(icn,size: 18,color: Color.fromARGB(180, 61, 42, 234),),
        labelText: labelTxt,
        labelStyle: TextStyle(fontWeight: FontWeight.w500,color: Colors.grey),
        // Normal border
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Color.fromARGB(80, 61, 42, 234), width: 1.5),
        ),
        // Focused border (when typing)
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Color.fromARGB(180, 61, 42, 234), width: 2),
        ),
        // Error border
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.red, width: 1.5),
        ),
        // Focused + error border
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.red, width: 2),
        ),
      ),
      validator: (value) => value!.isEmpty ? errorText : null,
    );
  }

  Widget SavesCard(Listing item,WidgetRef ref, context) {
    return GestureDetector(
      onTap: (){
        ref.watch(viewProductProvider.notifier).addToview(item);
        Navigator.of(context).pushNamed('/productView');
      },
      child: Stack(

          children:[
            Container(
              width: 180,
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
                      height: 160,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        height: 160,
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
                  onTap: () async{
                    if (ref.read(savesProvider).contains(item)) {
                      try {
                        final responseCode = await deleteSavedListing(item);

                        if (responseCode == 200) {
                          ref.read(savesProvider.notifier).removeSaved(item);
                          showCustomSnackBar(context, Icons.remove_circle_outline_rounded, "Removed from saved listings");
                        }
                        else {
                          showCustomSnackBar(context, Icons.error_outline, "An error occurred, Please retry");
                        }
                      }catch(e){
                        showCustomSnackBar(context, Icons.error_outline, "An error occurred, Please retry");
                      }
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(4), // Controls icon padding inside circle
                    child: Icon(Icons.cancel_outlined,
                      size: 26,
                      color: ref.read(savesProvider).contains(item) ? Colors.red : Colors.black,
                    ),
                  ),
                ),
              ),
            ),

          ]
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

  void showCustomSnackBar(BuildContext context, IconData icon, String message, {Color? color}) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Colors.grey[900],
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 6,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      content: Row(
        children: [
          Icon(icon, color: color ?? Colors.white),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    ));
  }

  Future showDialogBox(BuildContext context,WidgetRef ref,Listing item){
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          titlePadding: EdgeInsets.zero,
          contentPadding: EdgeInsets.zero,
          backgroundColor: Colors.white,
          title: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline_rounded, color: Colors.blue),
                SizedBox(width: 8),
                Text(
                  "Information",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.blue.shade900,
                  ),
                ),
              ],
            ),
          ),
          content: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Are you sure you want to delete this listing?",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    //Cancel Button
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(
                        "Cancel",
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ),
                    SizedBox(width: 8),
                    //Delete Button
                    TextButton(
                      style:TextButton.styleFrom(
                        foregroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        ref.watch(myListingsProvider.notifier).deleteListing(item);
                        Navigator.of(context).pop();
                      },
                      child: Text("Delete"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );

  }

}
