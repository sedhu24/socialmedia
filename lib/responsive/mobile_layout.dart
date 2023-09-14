import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socialmedia/provider/user_provider.dart';
import 'package:socialmedia/utils/colors.dart';
import 'package:socialmedia/utils/globalvariables.dart';
import '../model/user.dart' as model;

class MobilescreenLayout extends StatefulWidget {
  const MobilescreenLayout({super.key});

  @override
  State<MobilescreenLayout> createState() => _MobilescreenLayoutState();
}

class _MobilescreenLayoutState extends State<MobilescreenLayout> {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  String userName = "";

  @override
  void initState() {
    super.initState();
    pageController = PageController();
    // getUserName();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  // void getUserName() async {
  //   DocumentSnapshot snapshot = await firebaseFirestore
  //       .collection('users')
  //       .doc(firebaseAuth.currentUser!.uid)
  //       .get();

  //   debugPrint(snapshot.data().toString());

  //   setState(() {
  //     userName = (snapshot.data() as Map<String, dynamic>)["username"];
  //   });
  // }

  int _page = 0;
  double bottombarwith = 42;
  double bottombarborderwith = 5;
  late PageController pageController;

  void nacvigationTaped(int page) {
    pageController.jumpToPage(page);
    setState(() {
      _page = page;
    });
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    // model.User user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: pageController,
        onPageChanged: onPageChanged,
        children: homeScreenItems,
      ),

      // no animation bar == cupertinotab
      bottomNavigationBar: CupertinoTabBar(
        backgroundColor: mobileBgColor,
        currentIndex: _page,
        // landscapeLayout: BottomNavigationBarLandscapeLayout.linear,
        onTap: nacvigationTaped,
        iconSize: 28,

        items: [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                color: _page == 0 ? primaryColor : secondaryColor,
              ),
              label: "",
              backgroundColor: mobileBgColor),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.search,
                color: _page == 1 ? primaryColor : secondaryColor,
              ),
              label: "",
              backgroundColor: mobileBgColor),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.add_circle,
                color: _page == 2 ? primaryColor : secondaryColor,
              ),
              label: "",
              backgroundColor: mobileBgColor),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.favorite,
                color: _page == 3 ? primaryColor : secondaryColor,
              ),
              label: "",
              backgroundColor: mobileBgColor),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
                color: _page == 4 ? primaryColor : secondaryColor,
              ),
              label: "",
              backgroundColor: mobileBgColor),
        ],
      ),
    );
  }
}
