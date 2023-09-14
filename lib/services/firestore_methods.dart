import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:socialmedia/model/comments.dart';
import 'package:socialmedia/model/post.dart';
import 'package:socialmedia/services/storage_methods.dart';
import 'package:uuid/uuid.dart';

class FireStoreMethods {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  //upload post

  Future<String> uploadPost(
    Uint8List file,
    String description,
    String uid,
    String username,
    String profImage,
  ) async {
    String res = "Error Occurred";

    try {
      String photoUrl =
          await StorageMethods().uploadImageToStorage("posts", file, true);

      String postId = const Uuid().v1();

      Post post = Post(
        description: description,
        uid: uid,
        username: username,
        postId: postId,
        datePublished: DateTime.now(),
        postUrl: photoUrl,
        profImage: profImage,
        likes: [],
      );

      firestore.collection('posts').doc(postId).set(
            post.toJson(),
          );
      res = "success";
    } catch (e) {
      res = e.toString();
    }

    return res;
  }

  // Like add/delete

  Future<void> likePost(String postId, String uid, List likes) async {
    try {
      if (likes.contains(uid)) {
        await firestore.collection("posts").doc(postId).update({
          "likes": FieldValue.arrayRemove([uid]),
        });
      } else {
        await firestore.collection("posts").doc(postId).update({
          "likes": FieldValue.arrayUnion([uid]),
        });
      }
    } catch (e) {
      debugPrint(
        e.toString(),
      );
    }
  }

  // like comment
  Future<void> likecomment(
    String postId,
    String commentId,
    String uid,
    List likes,
  ) async {
    try {
      debugPrint(uid);
      if (likes.contains(uid)) {
        debugPrint(uid);

        debugPrint("check comment");

        await firestore
            .collection("posts")
            .doc(postId)
            .collection("comments")
            .doc(commentId)
            .update({
          "likes": FieldValue.arrayRemove([uid]),
        });
      } else {
        await firestore
            .collection("posts")
            .doc(postId)
            .collection("comments")
            .doc(commentId)
            .update({
          "likes": FieldValue.arrayUnion([uid]),
        });
      }
    } catch (e) {
      debugPrint(
        e.toString(),
      );
    }
  }

  // comment post
  Future<void> postComment(String postId, String text, String uid, String name,
      String profilePic) async {
    // String res = "Error Occurred";
    try {
      if (text.isNotEmpty) {
        String commentId = const Uuid().v1();

        CommentModel comment = CommentModel(
          name: name,
          postId: postId,
          uid: uid,
          likes: [],
          text: text,
          commentId: commentId,
          profilePic: profilePic,
          datePublished: DateTime.now(),
        );
        await firestore
            .collection("posts")
            .doc(postId)
            .collection("comments")
            .doc(commentId)
            .set(
              comment.toJson(),
            );
      } else {
        print("Text is empty");
      }
    } catch (e) {
      print(e);
    }
  }

  // delete Post

  Future<void> deletePost(String postId) async {
    try {
      await firestore.collection("posts").doc(postId).delete();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> followingUserId(
    String uid,
    String followId,
  ) async {
    try {
      DocumentSnapshot snap =
          await firestore.collection("users").doc(uid).get();

      List following = (snap.data()! as dynamic)["following"];

// make it work like the like function
      if (following.contains(followId)) {
        await firestore.collection("users").doc(followId).update({
          "followers": FieldValue.arrayRemove([uid])
        });

        await firestore.collection("users").doc(uid).update({
          "following": FieldValue.arrayRemove([followId])
        });
      } else {
        await firestore.collection("users").doc(followId).update({
          "followers": FieldValue.arrayUnion([uid])
        });

        await firestore.collection("users").doc(uid).update({
          "following": FieldValue.arrayUnion([followId])
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> favoritespostId(
    String uid,
    String postId,
  ) async {
    try {
      DocumentSnapshot snap =
          await firestore.collection("users").doc(uid).get();

      List following = (snap.data()! as dynamic)["favorites"];

// make it work like the like function
      if (following.contains(postId)) {
        await firestore.collection("users").doc(uid).update({
          "favorites": FieldValue.arrayRemove([postId])
        });
      } else {
        await firestore.collection("users").doc(uid).update({
          "favorites": FieldValue.arrayUnion([postId])
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
