import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:minimal_social_media_app/componets/drawer.dart';
import 'package:minimal_social_media_app/componets/text_field.dart';
import 'package:minimal_social_media_app/componets/wall_post.dart';
import 'package:minimal_social_media_app/screens/ProfilePage.dart';
import 'package:minimal_social_media_app/string_constants.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final currentUser =  FirebaseAuth.instance.currentUser;
  final textController = TextEditingController();

  void postMessage() async{
      if(textController.text.isNotEmpty){
        await FirebaseFirestore.instance.collection(
            STRINGS.CollectionPostsName
        ).add({
            'UserEmail': currentUser!.email,
            'Message' : textController.text,
            'TimeStamp': Timestamp.now(),
            'Likes': []
        });
        textController.clear();
      }
  }

  void gotoProfilePage(){
    Navigator.pop(context);
    Navigator.push(context,
      MaterialPageRoute(builder: (context) => const ProfilePage())
    );

  }
  void logout(){
      FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      drawer: MyDrawer(
        onProfileTap: gotoProfilePage,
        onSignoutTap: logout,
      ),
      appBar: AppBar(
        centerTitle: true,
        foregroundColor: Colors.white,
        title: Text('ZAK'),
        backgroundColor: Colors.grey[900],
        actions: [
          IconButton(
            onPressed: signOut,
            icon: Icon(Icons.logout)
          )
        ],
      ),
      body: Center(
        child: Column(
          children: [

            Expanded(child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection(STRINGS.CollectionPostsName)
                  .orderBy("TimeStamp", descending: false)
                  .snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {

                if(snapshot.hasData){
                  return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context,index){
                      QueryDocumentSnapshot post = snapshot.data!.docs[index];
                    return WallPost(
                        message: post['Message'],
                        user: post['UserEmail'],
                        postId: post.id,
                        likes: List<String>.from(post['Likes'])
                    );
                  });
                }else if(snapshot.hasError){
                  return Text(snapshot.error.toString());
                }



                return Center(child: Text('Yükleniyor..'),);
              },
            )),

            Padding(
              padding: const EdgeInsets.all(25),
              child: Row(
                children: [
                  Expanded(child: MyTextField(
                    controller: textController,
                    obscureText: false,
                    hintText: 'Bir şeyler yaz...',
                  )),
                  IconButton(onPressed: postMessage, icon: Icon(Icons.arrow_circle_up))
                ],
              ),
            ),

            Text("giriş yapan : ${currentUser!.email!}")
          ],
        ),
      ),
    );
  }

  void signOut() {
    FirebaseAuth.instance.signOut();
  }
}
