import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socialmedia/features/comment/widget/comment_card.dart';
import 'package:socialmedia/services/firestore_methods.dart';
import 'package:socialmedia/utils/colors.dart';

import '../../../model/user.dart';
import '../../../provider/user_provider.dart';

class CommentsScreen extends StatefulWidget {
  final snap;
  const CommentsScreen({super.key, required this.snap});

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  final TextEditingController commentController = TextEditingController();

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBgColor,
        // leading: IconButton(
        //   icon: const Icon(Icons.arrow_back_ios),
        //   onPressed: clearimage,
        // ),
        title: const Text("Comments"),
        centerTitle: false,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("posts")
            .doc(widget.snap["postId"])
            .collection("comments")
            .orderBy("datePublished", descending: true)
            .snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) =>
                CommentCard(snap: snapshot.data!.docs[index].data()),
          );
        },
      ),
      bottomNavigationBar: SafeArea(
          child: Container(
        height: kToolbarHeight,
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        padding: EdgeInsets.only(
          left: 16,
          right: 8,
          bottom: 16,
        ),
        child: Row(children: [
          CircleAvatar(
            radius: 18,
            backgroundImage: NetworkImage(
              user.photoUrl,
              // widget.snap["profImage"],
              // "https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Ftse1.mm.bing.net%2Fth%3Fid%3DOIP.s0HFO_6_GcQcp9hl0DpDDAHaHa%26pid%3DApi&f=1&ipt=d1d1b464c753ff32734202cf97958d2be8a54e44eb0f69a4c636e1c10ad48b91&ipo=images",
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 16, right: 8.0),
              child: TextField(
                controller: commentController,
                decoration: InputDecoration(
                  hintText: "Comment as ${user.username}",
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () async {
              await FireStoreMethods().postComment(
                widget.snap["postId"],
                commentController.text,
                user.uid,
                user.username,
                user.photoUrl,
              );
              setState(() {
                commentController.clear();
              });
            },
            child: Container(
              padding: EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 8,
              ),
              child: Icon(
                Icons.send,
                color: Colors.grey,
              ),
            ),
          )
        ]),
      )),
    );
  }
}
