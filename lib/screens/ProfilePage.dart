import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:minimal_social_media_app/componets/text_box.dart';
import 'package:minimal_social_media_app/string_constants.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  final usersCollection = FirebaseFirestore.instance.collection(STRINGS.CollectionUsers);

  Future<void> editField(String field, String title) async{
    String nv = '';
    await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: Colors.grey[900],
          title: Text('${title} Düzenle', style: TextStyle(
            color: Colors.white
          ),),
          content: TextField(
            autofocus: true,
            style: TextStyle(
              color: Colors.white
            ),
            decoration: InputDecoration(
              hintText: "Yeni ${title} Giriniz",
              hintStyle: TextStyle(
                color: Colors.grey
              )
            ),
            onChanged: (value){
              nv = value;
            },
          ),
          actions: [
            TextButton(onPressed: (){
              Navigator.pop(context);
            }, child: Text('Vazgeç', style: TextStyle(color: Colors.white),)),
            TextButton(onPressed: (){
              Navigator.of(context).pop(nv);
            }, child: Text('Kaydet', style: TextStyle(color: Colors.white),))
          ],
        )
    );

    if(nv.trim().length > 0){
      await usersCollection.doc(currentUser.email).update(
        {
         field: nv
        }
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profil Sayfası'),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection(STRINGS.CollectionUsers).doc(currentUser.email).snapshots(),
        builder: (context, snapshot){
          if(snapshot.hasData){
            final userData = snapshot.data!.data() as Map<String, dynamic>;
            return  ListView(
              children: [
                const SizedBox(
                  height: 25,
                ),
                const Icon(Icons.person, size: 72),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  currentUser!.email.toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey[700]),
                ),
                const SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 25),
                  child: Text(
                    'Detaylar',
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                ),
                MyTextBox(
                  text: userData['username'],
                  sectionName: 'Kullanıcı Adı',
                  onPressed: () => editField('username', 'Kullanıcı Adı'),
                ),
                MyTextBox(
                  text: userData['bio'],
                  sectionName: 'Hakkında',
                  onPressed: () => editField('bio', 'Biografi'),
                )
              ],
            );
          }
          else if(snapshot.hasError){
            return Text(snapshot.error.toString());
          }

          return CircularProgressIndicator();
        },
      )
    );
  }
}
