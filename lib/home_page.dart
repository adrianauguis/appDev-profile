import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

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
        "https://static.wikia.nocookie.net/interstellarfilm/images/9/9b/Black_hole.png/revision/latest/scale-to-width-down/432?cb=20150322005003",
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
          "https://lh3.googleusercontent.com/a/AEdFTp4Vst6s5IgmYX3LNmRPGpgHPpR-7HJDapJ0tOTRlw=s288-p-rw-no"),
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
          "ID: 2020300482",
          style: TextStyle(fontSize: 20, color: Colors.black45),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildSocialIcon(FontAwesomeIcons.facebook,
                "https://www.facebook.com/adrian.auguis/"),
            const SizedBox(height: 16, width: 10),
            buildSocialIcon(
                FontAwesomeIcons.github, "https://github.com/adrianauguis"),
            const SizedBox(height: 16, width: 10),
            buildSocialIcon(
                FontAwesomeIcons.twitter, "https://twitter.com/AuguisAdrian"),
            const SizedBox(height: 16, width: 10),
            buildSocialIcon(FontAwesomeIcons.instagram,
                "https://www.instagram.com/adrian.auguis/"),
          ],
        ),
        const SizedBox(height: 16),
        const Divider(),
        const SizedBox(height: 16),
        buildPersonalInfoPart(),
        const SizedBox(height: 16),
        const Divider(),
        const SizedBox(height: 16),
        buildAboutPart(),
        const SizedBox(height: 20),
      ],
    );
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

  Widget buildAboutPart() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          SizedBox(height: 8),
          Text("About Me",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Text(
            "A 3rd year BSIT Student in USTP, currently learning Application Development and Emerging Technologies"
            ". I am determined to pursue this program to further expand my knowledge in mobile programming & development.",
            style: TextStyle(fontSize: 16, color: Colors.black45),
          ),
        ],
      ),
    );
  }

  Widget buildPersonalInfoPart() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          SizedBox(height: 8),
          Text(
              "Personal Information                                           ",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Text(
            "Name: Adrian Auguis",
            style: TextStyle(fontSize: 16, color: Colors.black45),
          ),
          Text(
            "Section: BSIT - 3R1",
            style: TextStyle(fontSize: 16, color: Colors.black45),
          ),
          Text(
            "Birthdate: February 23, 2001",
            style: TextStyle(fontSize: 16, color: Colors.black45),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFB99B6B),
        body: ListView(
          padding: EdgeInsets.zero,
          children: [buildTopPart(), buildContentPart()],
    ));
  }
}
