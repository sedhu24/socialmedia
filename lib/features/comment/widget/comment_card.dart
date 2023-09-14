import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:socialmedia/provider/user_provider.dart';

import '../../../model/user.dart';
import '../../../services/firestore_methods.dart';
import '../../feeds/widgets/like_animation.dart';

class CommentCard extends StatefulWidget {
  final snap;

  const CommentCard({super.key, required this.snap});

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  bool isLikeAnimating = false;
  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 18,
        horizontal: 16,
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage:
                CachedNetworkImageProvider(widget.snap["profilePic"]),
            radius: 18,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(
                left: 16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: widget.snap["name"],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: "  ${widget.snap["text"]}",
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      DateFormat.yMMMd().format(
                        widget.snap["datePublished"].toDate(),
                      ),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            child: LikeAnimation(
              isAnimation: widget.snap["likes"].contains(user.uid),
              smallLike: true,
              child: IconButton(
                onPressed: () async {
                  await FireStoreMethods().likecomment(
                    // widget.snap["postId"],
                    widget.snap["postId"],
                    widget.snap["commentId"],
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
          )
        ],
      ),
    );
  }
}
