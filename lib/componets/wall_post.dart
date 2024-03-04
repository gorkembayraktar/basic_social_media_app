import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:minimal_social_media_app/componets/like_button.dart';
import 'package:minimal_social_media_app/string_constants.dart';

class WallPost extends StatefulWidget {
  final String message;
  final String user;
  final String postId;
  final List<String> likes;

  const WallPost({super.key,
    required this.message,
    required this.user,
    required this.postId,
    required this.likes
  });

  @override
  State<WallPost> createState() => _WallPostState();
}

class _WallPostState extends State<WallPost> {

  final currentUser = FirebaseAuth.instance.currentUser!;
  bool isLiked = false;

  @override
  void initState() {
    super.initState();
    isLiked = widget.likes.contains(currentUser.email);
  }

  void ToggleLike(){
    setState(() {
      isLiked = !isLiked;
    });
    DocumentReference postRef = FirebaseFirestore.instance.collection(
      STRINGS.CollectionPostsName
    ).doc(widget.postId);

    if(isLiked){
      postRef.update({
        'Likes': FieldValue.arrayUnion([currentUser.email])
      });
    }else{
      postRef.update({
        'Likes': FieldValue.arrayRemove([currentUser.email])
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8)
      ),
      margin: EdgeInsets.only(top:25, left: 25,right: 25),
      padding: EdgeInsets.all(25),
      child: Row(
        children: [
          Column(
            children: [
              LikeButton(isLiked: isLiked, onTap: ToggleLike),
              SizedBox(height: 5,),
              Text(widget.likes.length.toString())
            ],
          ),
          const SizedBox(width: 10,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.user, style: TextStyle(color: Colors.grey[500]),),
              SizedBox(height: 10,),
              Text(widget.message)
            ],
          ),
          const SizedBox(width: 50,),
        ],
      ),
    );
  }
}
