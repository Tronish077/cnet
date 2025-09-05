import 'package:cnet/Providers/FollowProvider.dart';
import 'package:cnet/Providers/TabProvider.dart';
import 'package:cnet/Providers/myListingsProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../Auth/Auth.dart';
import '../../CustomWidgets/customeWidget.dart';

class profileTab extends ConsumerStatefulWidget {
  const profileTab({super.key});

  @override
  ConsumerState<profileTab> createState() => _profileTabState();
}

class _profileTabState extends ConsumerState<profileTab> {
  final _auth = MyAuth();
  final custom = CustomWidgets();
  final FocusNode _dummyFocusNode = FocusNode();
  User? fbUser ;

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      final user = FirebaseAuth.instance.currentUser;
      if (!mounted) return; // ✅ safe here
      setState(() {
        fbUser = user;
        // update state safely
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    //Followers
    final followers = ref.watch(followersProvider);
    final myListings = ref.watch(myListingsProvider);
    FocusScope.of(context).requestFocus(_dummyFocusNode);

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("My Profile",style: TextStyle(
          fontWeight: FontWeight.w500
        )),
        actions: [
          IconButton(
            onPressed: () => _auth.logoutAll(context,ref),
            icon: Icon(Icons.logout_rounded,color: Theme.of(context).primaryColor,),
            style: IconButton.styleFrom(
                backgroundColor: Colors.blue.shade50
            )
        ),
          SizedBox(width: 8),
        ],
      ),
      body:
      Column(
        children: [
          //Top - part
          Container(
            decoration: BoxDecoration(
              color: Colors.white
            ),
            padding: EdgeInsets.only(bottom: 10),
            child:
              Column(
                children: [
                  Divider(color: Colors.grey.shade300),
                  SizedBox(height: 12),
                //User Card 💳
                  Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  width: double.infinity,
                  child: Row(
                  children: [
                    fbUser?.photoURL != null
                        ?
                    CircleAvatar(
                      backgroundImage: NetworkImage("${fbUser?.photoURL}"),
                      radius: 40,
                    )
                        :
                    CircleAvatar(
                      backgroundImage: AssetImage("assets/Default_pfp.jpg"),
                      radius: 40,
                    )
                    ,
                    SizedBox(width: 16),
                    Expanded(  // 👈 makes text take remaining space
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${fbUser?.displayName}",
                            style: TextStyle(
                              fontSize: 20,
                              color: Color.fromARGB(255, 61, 42, 184),
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis, // 👈 add dots if too long
                            maxLines: 1, // 👈 keep in one line
                            softWrap: false,
                          ),
                          Text(
                            "Seller",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade500,
                              fontWeight: FontWeight.w500,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                            ),
                  ),
                  //
                  SizedBox(height: 12),
                //Info of User 🪭
                  Divider(color: Colors.grey.shade200,),
                  Container(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          Text("$followers", style: TextStyle(
                            color: Color.fromARGB(255, 61, 42, 184),
                              fontWeight: FontWeight.bold,
                            fontSize: 19
                          )),
                          Text("Followers",style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade500,
                            fontWeight: FontWeight.w500,
                          )),
                        ],
                      ),
                      Container( // 👈 manual vertical divider
                        height: 30, // adjust to match text height
                        width: 1,
                        color: Colors.grey.shade400,
                        margin: EdgeInsets.symmetric(horizontal: 16),
                      ),
                      Column(
                        children: [
                          Text("${myListings.length}", style: TextStyle(
                              fontWeight: FontWeight.bold,
                            color:Color.fromARGB(255, 61, 42, 184),
                            fontSize: 19
                          )),
                          Text("Overall Listings",style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade500,
                            fontWeight: FontWeight.w500,
                          )),
                        ],
                      ),
                    ],
                  ),
                            ),
                  Divider(color: Colors.grey.shade200),
                  //
                  TextButton.icon(
                    style: TextButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 61, 42, 234),
                      foregroundColor: Colors.white,
                    ),
                      onPressed: (){
                          ref.watch(tabProvider.notifier).changeTab(2);
                      },
                    icon: Icon(FontAwesomeIcons.plus),
                    label: Text("Create New Listing"),),
                ],
              )
          ),
          SizedBox(height: 8),
          //Listings Part
          Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 8),
                color: Colors.white,
                child: Column(
                  children: [
                  Text(
                  "Your Listings",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  )),
                  Divider(color: Colors.grey.shade200,),
                  Expanded(
                    child:Container(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child:
                    myListings.isEmpty ?
                    Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.inbox, size: 64, color: Colors.grey.shade400),
                          const SizedBox(height: 12),
                          Text(
                            "No available Listings",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Go to the Create tab and post your listing.",
                            style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
                          ),
                        ],
                      ),
                    )
                        :
                    ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                      itemCount: myListings.length,
                      itemBuilder: (context, index) {
                        final listing = myListings[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12), // spacing between cards
                          child: custom.PfpItemCard(listing, ref, context),
                        );
                      },
                    )
                      ,
                    ),
                  ),
                  ],
                ),
              )
          )
        ],
      ),
    );
  }
}
