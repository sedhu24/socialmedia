import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:socialmedia/common/utills.dart';
import 'package:socialmedia/features/comment/screens/comment_screen.dart';
import 'package:socialmedia/features/feeds/widgets/like_animation.dart';
import 'package:socialmedia/provider/user_provider.dart';
import 'package:socialmedia/services/firestore_methods.dart';
import 'package:socialmedia/utils/colors.dart';
import 'package:socialmedia/utils/globalvariables.dart';

import '../../../model/user.dart';

class PostCard extends StatefulWidget {
  final snap;
  final sanpuserId;
  const PostCard({
    super.key,
    required this.snap,
    required this.sanpuserId,
  });

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isLikeAnimating = false;
  int commentlength = 0;
  bool isfav = false;
  var favorites;

  @override
  void initState() {
    super.initState();
    getComments();
    loadfav();
  }

  void loadfav() async {
    try {
      DocumentSnapshot snap = await FirebaseFirestore.instance
          .collection("users")
          .doc(widget.sanpuserId)
          .get();

      List favorites = (snap.data()! as dynamic)["favorites"];

      if (favorites.contains(widget.snap["postId"])) {
        // await FireStoreMethods().favoritespostId(
        //   widget.sanpuserId,
        //   widget.snap["postId"],
        // );
        print("Fav : $favorites");
        setState(() {
          isfav = true;
        });
      } else {
        setState(() {
          isfav = false;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  void getComments() async {
    try {
      QuerySnapshot query = await FirebaseFirestore.instance
          .collection("posts")
          .doc(widget.snap["postId"])
          .collection("comments")
          .get();

      commentlength = query.docs.length;
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    setState(() {});
  }

  deletePost(String postId) async {
    try {
      await FireStoreMethods().deletePost(postId);
    } catch (err) {
      showSnackBar(
        context,
        err.toString(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;
    final width = MediaQuery.of(context).size.width;
    return Container(
      // margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: mobileBgColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        border: Border.all(
          color: width > webScreenSize ? secondaryColor : mobileBgColor,
        ),
      ),
      padding: const EdgeInsets.symmetric(
        vertical: 10,
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              vertical: 4,
              horizontal: 16,
            ).copyWith(
              right: 0,
            ),
            child: Row(
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.grey,
                  backgroundImage: CachedNetworkImageProvider(
                    widget.snap["profImage"],
                    // "https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Ftse1.mm.bing.net%2Fth%3Fid%3DOIP.s0HFO_6_GcQcp9hl0DpDDAHaHa%26pid%3DApi&f=1&ipt=d1d1b464c753ff32734202cf97958d2be8a54e44eb0f69a4c636e1c10ad48b91&ipo=images",
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.snap["username"],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (_) {
                          return Dialog(
                            child: ListView(
                              padding: const EdgeInsets.symmetric(
                                vertical: 16,
                              ),
                              shrinkWrap: true,
                              children: ["Delete"]
                                  .map(
                                    (e) => InkWell(
                                      onTap: () {
                                        deletePost(
                                          widget.snap["postId"],
                                        );
                                        Navigator.of(context).pop();
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 12, horizontal: 16),
                                        child: Text(e),
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                          );
                        });
                  },
                  icon: const Icon(
                    Icons.more_vert,
                  ),
                )
              ],
            ),
          ),

          // post image
          GestureDetector(
            onDoubleTap: () async {
              await FireStoreMethods().likePost(
                widget.snap["postId"],
                user.uid,
                widget.snap["likes"],
              );
              setState(() {
                isLikeAnimating = true;
              });
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.35,
                  width: double.infinity,
                  child:
                      //  Image.network(
                      //   widget.snap["postUrl"],
                      //   fit: BoxFit.scaleDown,

                      //   // "https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Ftse1.mm.bing.net%2Fth%3Fid%3DOIP.s0HFO_6_GcQcp9hl0DpDDAHaHa%26pid%3DApi&f=1&ipt=d1d1b464c753ff32734202cf97958d2be8a54e44eb0f69a4c636e1c10ad48b91&ipo=images",
                      // ),

                      // CachedNetworkImage(
//               imageUrl: image,
//               placeholder: (context, url) => const Center(
//                 child: CircularProgressIndicator(),
//               ),
//               errorWidget: (context, url, error) => const Center(
//                 child: Icon(Icons.error),
//               ),
//             )

//  Image.network(
//                   widget.networkUrl,
//                   fit: BoxFit.fill,
//                   loadingBuilder: (BuildContext context, Widget child,
//                       ImageChunkEvent? loadingProgress) {
//                     if (loadingProgress == null) return child;
//                     return Center(
//                       child: CircularProgressIndicator(
//                         value: loadingProgress.expectedTotalBytes != null
//                             ? loadingProgress.cumulativeBytesLoaded /
//                                 loadingProgress.expectedTotalBytes!
//                             : null,
//                       ));}),

                      CachedNetworkImage(
                    imageUrl: widget.snap["postUrl"],
                    fit: BoxFit.scaleDown,
                    placeholder: (context, url) => const Center(
                      child: CircularProgressIndicator(
                        color: Colors.black,
                        backgroundColor: Colors.white,
                      ),
                    ),
                    errorWidget: (context, url, error) => const Center(
                      child: Icon(Icons.error),
                    ),
                  ),
                ),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: isLikeAnimating ? 1 : 0,
                  child: LikeAnimation(
                    isAnimation: isLikeAnimating,
                    duration: const Duration(
                      milliseconds: 400,
                    ),
                    onEnd: () {
                      setState(() {
                        isLikeAnimating = false;
                      });
                    },
                    child: const Icon(
                      Icons.favorite,
                      color: Colors.white,
                      size: 120,
                    ),
                  ),
                )
              ],
            ),
          ),
          Row(
            children: [
              // like
              LikeAnimation(
                isAnimation: widget.snap["likes"].contains(user.uid),
                smallLike: true,
                child: IconButton(
                  onPressed: () async {
                    await FireStoreMethods().likePost(
                      widget.snap["postId"],
                      user.uid,
                      widget.snap["likes"],
                    );
                  },
                  icon: widget.snap["likes"].contains(user.uid)
                      ? Icon(
                          Icons.favorite,
                          color: Colors.red,
                        )
                      : const Icon(
                          Icons.favorite_border,
                        ),
                ),
              ),
              // comment
              IconButton(
                  onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => CommentsScreen(
                            snap: widget.snap,
                          ),
                        ),
                      ),
                  icon: FaIcon(
                    FontAwesomeIcons.comment,
                  )),
              // send
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.send,
                ),
              ),
              Expanded(
                  child: Align(
                alignment: Alignment.bottomRight,
                child: LikeAnimation(
                  isAnimation: isfav,
                  // isAnimation:
                  //     ,
                  smallLike: true,
                  child: IconButton(
                    onPressed: () async {
                      print("userId :  ${widget.sanpuserId}");
                      print("PostId : ${widget.snap["postId"]}");

                      await FireStoreMethods().favoritespostId(
                        widget.sanpuserId,
                        widget.snap["postId"],
                      );

                      // await  FirebaseFirestore.instance.collection("users").doc(widget.sanpuserId);

                      // await FireStoreMethods().likePost(
                      //   widget.snap["postId"],
                      //   user.uid,
                      //   widget.snap["likes"],
                      // );
                    },
                    icon: isfav
                        ? const Icon(
                            Icons.bookmark,
                            color: Colors.red,
                          )
                        : const Icon(
                            Icons.bookmark_border,
                          ),
                  ),
                ),
                // IconButton(
                //   icon: const Icon(
                //     Icons.bookmark_border,
                //   ),
                //   onPressed: () {},
                // ),
              ))
            ],
          ),

          // Description
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                widget.snap["likes"].length == 0
                    ? const SizedBox.shrink()
                    : DefaultTextStyle(
                        style: Theme.of(context)
                            .textTheme
                            .displayMedium!
                            .copyWith(fontWeight: FontWeight.w800),
                        child: Text(
                          "${widget.snap["likes"].length} Likes",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(
                    top: 8,
                  ),
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(color: primaryColor),
                      children: [
                        TextSpan(
                          text: widget.snap["username"],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: "  ${widget.snap["description"]}",
                        ),
                      ],
                    ),
                  ),
                ),
                commentlength == 0
                    ? const SizedBox.shrink()
                    : InkWell(
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => CommentsScreen(
                              snap: widget.snap,
                            ),
                          ),
                        ),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Text(
                            // todo put Commets in Stream
                            commentlength == 0
                                ? "No comments"
                                : "View all $commentlength Comments",
                            style: const TextStyle(
                              fontSize: 16,
                              color: secondaryColor,
                            ),
                          ),
                        ),
                      ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    DateFormat.yMMMd().format(
                      widget.snap["datePublished"].toDate(),
                    ),
                    style: const TextStyle(
                      fontSize: 16,
                      color: secondaryColor,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
