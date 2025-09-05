import 'package:cached_network_image/cached_network_image.dart';
import 'package:cnet/BackendFuncs/MainBackend.dart';
import 'package:cnet/FunctionClasses/ListingClass.dart';
import '../../CustomWidgets/customeWidget.dart';
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
  final custom =  CustomWidgets();

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
          ?
      Center(
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
                  return custom.SavesCard(listing,ref,context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

}
