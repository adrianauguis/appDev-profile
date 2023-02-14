import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final double coverHeight = 280;
  final double profileHeight = 144;

  Widget buildCoverImage() {
    return Container(
      color: Colors.grey,
      child: Image.network(
        "https://vtv1.mediacdn.vn/thumb_w/650/2020/11/6/1604639296-20201106-chaeyoung-16046520874311221545609.jpg",
        width: double.infinity,
        height: coverHeight,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget buildProfileImage() {
    return CircleAvatar(
      radius: profileHeight / 2,
      backgroundColor: Colors.grey,
      backgroundImage: const NetworkImage(
          "https://pbs.twimg.com/media/FCq7HF2VgAoD60l?format=jpg&name=small"),
    );
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

  Widget buildContentPart() {
    return Column(
      children: [
        const SizedBox(height: 8),
        const Text("Adrian Auguis",
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        const Text(
          "2020300482",
          style: TextStyle(fontSize: 20, color: Colors.black45),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildSocialIcon(FontAwesomeIcons.slack),
            const SizedBox(height: 16, width: 10),
            buildSocialIcon(FontAwesomeIcons.github),
            const SizedBox(height: 16, width: 10),
            buildSocialIcon(FontAwesomeIcons.twitter),
            const SizedBox(height: 16, width: 10),
            buildSocialIcon(FontAwesomeIcons.linkedin),
          ],
        ),
        const SizedBox(height: 16),
        const Divider(),
        const SizedBox(height: 16),
        buildAboutPart()
      ],
    );
  }

  Widget buildSocialIcon(IconData icon){
    return CircleAvatar(
      radius: 25,
      child: Center(child: Icon(icon, size: 32),
    )
    );
  }

  Widget buildAboutPart(){
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            SizedBox(height: 8),
            Text("About",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text(
              "A 3rd year BSIT Student in USTP, currently learning Application Development and Emerging Technologies",
              style: TextStyle(fontSize: 16, color: Colors.black45),
            ),
            SizedBox(height: 16),
            Divider(),
            SizedBox(height: 16)
          ],
        ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
          padding: EdgeInsets.zero,
          children: [buildTopPart(), buildContentPart()],
        ));
  }
}
