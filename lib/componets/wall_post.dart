import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:minimal_social_media_app/componets/comments.dart';
import 'package:minimal_social_media_app/componets/comments_button.dart';
import 'package:minimal_social_media_app/componets/like_button.dart';
import 'package:minimal_social_media_app/helper/helper_methods.dart';
import 'package:minimal_social_media_app/string_constants.dart';

class WallPost extends StatefulWidget {
  final String message;
  final String user;
  final String time;
  final String postId;
  final List<String> likes;

  const WallPost(
      {super.key,
      required this.message,
      required this.user,
      required this.time,
      required this.postId,
      required this.likes});

  @override
  State<WallPost> createState() => _WallPostState();
}

class _WallPostState extends State<WallPost> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  bool isLiked = false;
  final commentTextController = TextEditingController();
  int commentCount = 0;

  @override
  void initState() {
    super.initState();
    isLiked = widget.likes.contains(currentUser.email);
  }

  void ToggleLike() {
    setState(() {
      isLiked = !isLiked;
    });
    DocumentReference postRef = FirebaseFirestore.instance
        .collection(STRINGS.CollectionPostsName)
        .doc(widget.postId);

    if (isLiked) {
      postRef.update({
        'Likes': FieldValue.arrayUnion([currentUser.email])
      });
    } else {
      postRef.update({
        'Likes': FieldValue.arrayRemove([currentUser.email])
      });
    }
  }

  void addComment(String commentText) {
    FirebaseFirestore.instance
        .collection(STRINGS.CollectionPostsName)
        .doc(widget.postId)
        .collection(STRINGS.CollectionPostComments)
        .add({
      "CommentText": commentText,
      "CommentBy": currentUser.email,
      "CommentTime": Timestamp.now()
    });
  }

  void showCommentDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Yorum ekle'),
            content: TextField(
              controller: commentTextController,
              decoration: InputDecoration(hintText: 'Yorumunuz..'),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Vazgeç')),
              TextButton(
                  onPressed: (){
                    addComment(commentTextController.text);
                    Navigator.pop(context);
                    commentTextController.clear();
                  },
                  child: Text('Gönder'))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(8)
      ),
      margin: EdgeInsets.only(top: 25, left: 25, right: 25),
      padding: EdgeInsets.all(25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [


          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.message),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.user,
                    style: TextStyle(color: Colors.grey[500]),
                  ),
                  Text(
                    widget.time,
                    style: TextStyle(color: Colors.grey[500]),
                  ),
                ],
              )


            ],
          ),
          const SizedBox(
            width: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  LikeButton(isLiked: isLiked, onTap: ToggleLike),
                  SizedBox(
                    height: 5,
                  ),
                  Text(widget.likes.length.toString())
                ],
              ),
              const SizedBox(width: 10),
              Column(
                children: [
                  CommentButton(onTap: showCommentDialog,),
                  SizedBox(
                    height: 5,
                  ),
                  Text(commentCount.toString())
                ],
              ),

            ],
          ),
          StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection(STRINGS.CollectionPostsName).doc(widget.postId).collection(STRINGS.CollectionPostComments).orderBy("CommentTime",descending: true).snapshots(),
              builder: (context, snapshot){

                if(!snapshot.hasData){
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                commentCount = snapshot.data!.docs.length;


                return ListView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: snapshot.data!.docs.map((doc){
                    final commentData = doc.data() as Map<String, dynamic>;
                    return Comment(
                        text: commentData['CommentText'],
                        user: commentData['CommentBy'],
                        time: formatDate(commentData['CommentTime'])
                    );
                  }).toList(),

                );
              }
          )

        ],
      ),
    );
  }
}
