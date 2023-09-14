import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:socialmedia/utils/globalvariables.dart';

import '../utils/colors.dart';

class WebscreenLayout extends StatefulWidget {
  const WebscreenLayout({super.key});

  @override
  State<WebscreenLayout> createState() => _WebscreenLayoutState();
}

class _WebscreenLayoutState extends State<WebscreenLayout> {
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
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: webBgColor,
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
              onPressed: () => nacvigationTaped(0),
              icon: Icon(
                Icons.home,
                color: _page == 0 ? primaryColor : secondaryColor,
              ),
            ),
            IconButton(
              onPressed: () => nacvigationTaped(1),
              icon: Icon(
                color: _page == 1 ? primaryColor : secondaryColor,
                Icons.search,
              ),
            ),
            IconButton(
              onPressed: () => nacvigationTaped(2),
              icon: Icon(
                Icons.add_a_photo,
                color: _page == 2 ? primaryColor : secondaryColor,
              ),
            ),
            IconButton(
              onPressed: () => nacvigationTaped(3),
              icon: Icon(
                Icons.favorite,
                color: _page == 3 ? primaryColor : secondaryColor,
              ),
            ),
            IconButton(
              onPressed: () => nacvigationTaped(4),
              icon: Icon(
                Icons.person,
                color: _page == 4 ? primaryColor : secondaryColor,
              ),
            ),
          ],
        ),
        body: PageView(
          physics: const NeverScrollableScrollPhysics(),
          onPageChanged: onPageChanged,
          controller: pageController,
          children: homeScreenItems,
        ));
  }
}
