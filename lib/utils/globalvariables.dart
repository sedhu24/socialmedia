import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:socialmedia/features/addpost/add_post_screen.dart';

import '../features/feeds/screens/feed_screen.dart';
import '../features/profile/profile_screen.dart';
import '../features/search/search_screen.dart';

const webScreenSize = 600;

List<Widget> homeScreenItems = [
  // feed
  const FeedScreen(),

  // search
  const SearchScreen(),

  // addpost
  const AddPostScrreen(),

  // fav

  // account
  ProfileScreen(
    uid: FirebaseAuth.instance.currentUser!.uid,
  ),
];
