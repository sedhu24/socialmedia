import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:socialmedia/common/loader.dart';
import 'package:socialmedia/features/feeds/widgets/post_card.dart';
import 'package:socialmedia/utils/colors.dart';
import 'package:socialmedia/utils/globalvariables.dart';

import '../../../model/user.dart';
import '../../../provider/user_provider.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    // final User user = Provider.of<UserProvider>(context).getUser;
    // final User user = Provider.of<UserProvider>(context).getUser;

    return Scaffold(
      backgroundColor: width > webScreenSize ? webBgColor : mobileBgColor,
      appBar: width > webScreenSize
          ? null
          : AppBar(
              backgroundColor: mobileBgColor,
              centerTitle: false,
              title: SvgPicture.asset(
                "assets/ic_instagram.svg",
                colorFilter: const ColorFilter.mode(
                  primaryColor,
                  BlendMode.srcIn,
                ),
                height: 32,
              ),
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: const FaIcon(
                    FontAwesomeIcons.facebookMessenger,
                  ),
                ),
              ],
            ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("posts").snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) => Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: width > webScreenSize ? width * 0.3 : 0,
                        vertical: width > webScreenSize ? 15 : 0,
                      ),
                      child: PostCard(
                        snap: snapshot.data!.docs[index].data(),
                      ),
                    ));
          }
        },
      ),
    );
  }
}
