import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:socialmedia/common/utills.dart';
import 'package:socialmedia/features/login/login_screen.dart';
import 'package:socialmedia/features/profile/widgets/follow_button.dart';
import 'package:socialmedia/services/auth_methods.dart';
import 'package:socialmedia/services/firestore_methods.dart';
import 'package:socialmedia/utils/colors.dart';

import '../../common/loader.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;
  const ProfileScreen({super.key, required this.uid});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var userData = {};
  var postlength = 0;
  int followers = 0;
  int following = 0;
  bool isFollowing = false;
  bool isLoading = false;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    getDataforUser();
  }

  void getDataforUser() async {
    setState(() {
      isLoading = true;
    });
    try {
      var usersnap = await FirebaseFirestore.instance
          .collection("users")
          .doc(widget.uid)
          .get();

      // post length
      var postsnap = await FirebaseFirestore.instance
          .collection("posts")
          .where(
            "uid",
            isEqualTo: FirebaseAuth.instance.currentUser!.uid,
          )
          .get();
      followers = usersnap.data()!["followers"].length;
      following = usersnap.data()!["following"].length;
      userData = usersnap.data()!;
      postlength = postsnap.docs.length;
      isFollowing = usersnap
          .data()!["followers"]
          .contains(FirebaseAuth.instance.currentUser!.uid);
      setState(() {});
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    setState(() {
      isLoading = false;
    });
  }

  // void followunfollow() async {
  //   await FireStoreMethods()
  //       .followingUserId(firebaseAuth.currentUser!.uid, userData["uid"]);
  // }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: Loader(),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBgColor,
              title: Text(
                userData["username"],
              ),
              centerTitle: false,
            ),
            body: ListView(children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.grey,
                          backgroundImage: CachedNetworkImageProvider(
                            userData["photoUrl"],
                          ),
                          radius: 40,
                        ),
                        Expanded(
                          flex: 1,
                          child: Column(
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  buildStateColumn(postlength, "Post"),
                                  buildStateColumn(followers, "Followers"),
                                  buildStateColumn(following, "Following"),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  firebaseAuth.currentUser!.uid == widget.uid
                                      ? FollowButtom(
                                          text: "Edit Profile",
                                          backgroundcolor: mobileBgColor,
                                          textColor: primaryColor,
                                          borderColor: Colors.grey,
                                          function: () async {},
                                        )
                                      : isFollowing
                                          ? FollowButtom(
                                              backgroundcolor: Colors.white,
                                              borderColor: Colors.grey,
                                              text: "Unfollow",
                                              textColor: Colors.black,
                                              function: () async {
                                                await FireStoreMethods()
                                                    .followingUserId(
                                                  FirebaseAuth.instance
                                                      .currentUser!.uid,
                                                  userData['uid'],
                                                );

                                                setState(() {
                                                  isFollowing = false;
                                                  followers--;
                                                });
                                              },
                                            )
                                          : FollowButtom(
                                              function: () async {
                                                await FireStoreMethods()
                                                    .followingUserId(
                                                  FirebaseAuth.instance
                                                      .currentUser!.uid,
                                                  userData['uid'],
                                                );

                                                setState(() {
                                                  isFollowing = true;
                                                  followers++;
                                                });
                                              },
                                              backgroundcolor: Colors.blue,
                                              borderColor: Colors.blue,
                                              text: "Follow",
                                              textColor: Colors.white),
                                ],
                              ),
                              firebaseAuth.currentUser!.uid == widget.uid
                                  ? FollowButtom(
                                      text: "Sign Out",
                                      backgroundcolor: mobileBgColor,
                                      textColor: primaryColor,
                                      borderColor: Colors.grey,
                                      function: () async {
                                        await AuthMethod().signOut();
                                        Navigator.of(context)
                                            .pushReplacement(MaterialPageRoute(
                                          builder: (context) =>
                                              const LoginScreen(),
                                        ));
                                      },
                                    )
                                  : const SizedBox.shrink()
                            ],
                          ),
                        ),
                      ],
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(
                        top: 15,
                      ),
                      child: Text(
                        userData["username"],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(
                        top: 3,
                      ),
                      child: Text(
                        userData["bio"],
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(),
              FutureBuilder(
                  future: FirebaseFirestore.instance
                      .collection("posts")
                      .where("uid", isEqualTo: widget.uid)
                      .get(),
                  builder: ((context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Loader();
                    } else if ((snapshot.data! as dynamic).docs.length == 0) {
                      return Center(
                        child: Container(
                          alignment: Alignment.center,
                          child: const Text(
                            "No Posts",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      );
                    } else {
                      return GridView.builder(
                        shrinkWrap: true,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 5,
                                mainAxisSpacing: 1.5,
                                childAspectRatio: 1),
                        itemCount: (snapshot.data! as dynamic).docs.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot docsnappost =
                              (snapshot.data! as dynamic).docs[index];

                          return Container(
                            child: CachedNetworkImage(
                              imageUrl: docsnappost["postUrl"],
                              fit: BoxFit.scaleDown,
                            ),
                          );
                        },
                      );
                    }
                  }))
            ]),
          );
  }

  Column buildStateColumn(int num, String label) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          num.toString(),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 4),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: Colors.grey,
            ),
          ),
        )
      ],
    );
  }
}
