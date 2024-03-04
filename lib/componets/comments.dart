import 'package:flutter/material.dart';

class Comment extends StatefulWidget {
  final String text;
  final String user;
  final String time;
  const Comment({super.key, required this.text, required this.user, required this.time});

  @override
  State<Comment> createState() => _CommentState();
}

class _CommentState extends State<Comment> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color:Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(4)
      ),
      margin: EdgeInsets.only(bottom: 5),
      padding: EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.text),
          SizedBox(height: 5,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(widget.user, style: TextStyle(color: Colors.grey),),
              Text(widget.time, style: TextStyle(color: Colors.grey))
            ],
          )
        ],
      ),
    );
  }
}
