import 'package:auguis_profile/edit_profile_page.dart';
import 'package:auguis_profile/model/storage_services.dart';
import 'package:auguis_profile/widget_tree.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:intl/intl.dart';

import 'auth.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Storage storage = Storage();
  final CollectionReference profile = FirebaseFirestore.instance.collection('user');
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final double coverHeight = 280;
  final double profileHeight = 144;

  Future<void> signOut() async {
    FirebaseAuth.instance.signOut();
    await Auth().signOut();
    setState(() {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const WidgetTree()));
    });
  }

  Widget buildCoverImage() {
    return Container(
      color: Colors.grey,
      child: Image.network(
        "https://static.wikia.nocookie.net/interstellarfilm/images/9/9b/Black_hole.png/revision/latest/scale-to-width-down/432?cb=20150322005003",
        width: double.infinity,
        height: coverHeight,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget buildProfileImage() {
    return StreamBuilder(
        stream: storage.getPicStream("profile",_firebaseAuth.currentUser!.uid),
        builder: (context, AsyncSnapshot<String> snapshot){
          return CircleAvatar(
            radius: profileHeight / 2,
            backgroundColor: Colors.grey,
            backgroundImage: NetworkImage(snapshot.data??"https://blogtimenow.com/wp-content/uploads/2014/06/hide-facebook-profile-picture-notification.jpg"),
          );
    });
  }

  Widget buildTopPart() {
    final bottom = profileHeight / 2;
    final top = coverHeight - profileHeight / 2;
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(bottom: bottom),
          child: buildCoverImage(),
        ),
        Positioned(top: top, child: buildProfileImage())
      ],
    );
  }

  buildContentPart() {
    return StreamBuilder(
        stream: profile.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot){
          if(streamSnapshot.hasData){
            for (var i = 0; i < streamSnapshot.data!.docs.length; i++) {
              DocumentSnapshot documentSnapshot =
              streamSnapshot.data!.docs[i];
              if (documentSnapshot.id != _firebaseAuth.currentUser!.uid) {
                continue;
              }else{
                return Column(
                  children: [
                    const SizedBox(height: 8),
                    Text(documentSnapshot['name'],
                        style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text(documentSnapshot['id'].toString(),
                      style: const TextStyle(fontSize: 20, color: Colors.black45),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        buildSocialIcon(FontAwesomeIcons.facebook, documentSnapshot['fb']),
                        const SizedBox(height: 16, width: 10),
                        buildSocialIcon(
                            FontAwesomeIcons.github, documentSnapshot['git']),
                        const SizedBox(height: 16, width: 10),
                        buildSocialIcon(
                            FontAwesomeIcons.twitter, documentSnapshot['twtr']),
                        const SizedBox(height: 16, width: 10),
                        buildSocialIcon(FontAwesomeIcons.instagram,
                            documentSnapshot['ig']),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=> EditProfile(documentSnapshot: documentSnapshot)));
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF698269)
                          ),
                          child: const Text("Edit Profile",style: TextStyle(color: Color(0xFF03001C))),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: (){
                            signOut();
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF698269)
                          ),
                          child: const Text("Sign out",style: TextStyle(color: Color(0xFF03001C))),
                        ),
                      ],
                    ),
                    const Divider(),
                    const SizedBox(height: 16),
                    buildPersonalInfoPart(documentSnapshot),
                    const SizedBox(height: 16),
                    const Divider(),
                    const SizedBox(height: 16),
                    buildAboutPart(documentSnapshot),
                    const SizedBox(height: 20),
                  ],
                );
              }
            }
          }else{
            return const CircularProgressIndicator();
          }
          return const CircularProgressIndicator();
        });

  }

  Widget buildSocialIcon(IconData icon, String baseUrl) {
    final url = Uri.parse(baseUrl);
    return CircleAvatar(
        radius: 25,
        child: Material(
          shape: const CircleBorder(),
          clipBehavior: Clip.hardEdge,
          color: const Color(0xFF698269),
          child: InkWell(
            onTap: () async {
              if (!await canLaunchUrl(url)) {
                await launchUrl(url,
                    webViewConfiguration:
                        const WebViewConfiguration(enableJavaScript: true));
              }
            },
            child: Center(
              child: FaIcon(icon, color: const Color(0xFF03001C), size: 32),
            ),
          ),
        ));
  }

  Widget buildAboutPart(DocumentSnapshot documentSnapshot) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          const Text("About Me                                           ",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(documentSnapshot['aboutMe'],
            style: const TextStyle(fontSize: 16, color: Colors.black45),
          ),
        ],
      ),
    );
  }

  Widget buildPersonalInfoPart(DocumentSnapshot documentSnapshot) {
    Timestamp t = documentSnapshot['birthdate'];
    DateTime date = t.toDate();
    String formattedDate = DateFormat.yMMMEd().format(date);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          const Text(
              "Personal Information                                           ",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text("Name: ${documentSnapshot['name']}",
            style: const TextStyle(fontSize: 16, color: Colors.black45),
          ),
          Text("Section: ${documentSnapshot['section']}",
            style: const TextStyle(fontSize: 16, color: Colors.black45),
          ),
          Text("Birthdate: $formattedDate",
            style: const TextStyle(fontSize: 16, color: Colors.black45),
          ),
          Text("Email: ${documentSnapshot['email']}",
            style: const TextStyle(fontSize: 16, color: Colors.black45),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFB99B6B),
        body: RefreshIndicator(
            child: ListView(
            padding: EdgeInsets.zero,
            children: [buildTopPart(), buildContentPart()]),
            onRefresh: ()async{
              return Future.delayed(const Duration(seconds: 0));
            })
    );
  }
}
