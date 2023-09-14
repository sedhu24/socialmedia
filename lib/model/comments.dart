import 'package:cloud_firestore/cloud_firestore.dart';

class CommentModel {
  final String name;
  final String text;
  final likes;
  final String uid;
  final String postId;
  final String profilePic;
  final String commentId;
  final DateTime datePublished;

  const CommentModel({
    required this.name,
    required this.uid,
    required this.postId,
    required this.text,
    required this.likes,
    required this.commentId,
    required this.profilePic,
    required this.datePublished,
  });

  static CommentModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    // "profilePic": profilePic,
    //         "name": name,
    //         "uuid": uid,
    //         "text": text,
    //         "commentId": commentId,
    //         "datePublished": DateTime.now(),

    return CommentModel(
      name: snapshot["name"],
      uid: snapshot["uid"],
      postId: snapshot["postId"],
      likes: snapshot["likes"],
      profilePic: snapshot["profilePic"],
      datePublished: snapshot["datePublished"],
      text: snapshot["text"],
      commentId: snapshot['commentId'],
    );
  }

  Map<String, dynamic> toJson() => {
        "profilePic": profilePic,
        "name": name,
        "uid": uid,
        "postId": postId,
        "likes": likes,
        "text": text,
        "commentId": commentId,
        "datePublished": datePublished,
        // "description": description,
        // "uid": uid,
        // "likes": likes,
        // "username": username,
        // "postId": postId,
        // "datePublished": datePublished,
        // 'postUrl': postUrl,
        // 'profImage': profImage
      };
}
