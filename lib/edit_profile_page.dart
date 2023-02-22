import 'dart:io';

import 'package:auguis_profile/home_page.dart';
import 'package:auguis_profile/model/profile_model.dart';
import 'package:auguis_profile/model/storage_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class EditProfile extends StatefulWidget {
  DocumentSnapshot documentSnapshot;

  EditProfile({Key? key, required this.documentSnapshot}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  Storage storage = Storage();
  final CollectionReference profile =
      FirebaseFirestore.instance.collection('user');
  final formKey = GlobalKey<FormState>();
  final double coverHeight = 230;
  final double profileHeight = 144;

  Future _selectDate(DateTime date) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: date,
        firstDate: DateTime(1990),
        lastDate: DateTime(2025));
    if (picked != null) {
      final TimeOfDay? time =
      await showTimePicker(context: context, initialTime: TimeOfDay.now());
      if (time != null) {
        return DateTime(
          picked.year,
          picked.month,
          picked.day,
          time.hour,
          time.minute,
        );
      }
    }
    return picked;
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
        stream: storage.getPicStream("profile"),
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
        Positioned(top: top, child: buildProfileImage()),
        Positioned(
            top: 245,
            right: 85,
            child: RawMaterialButton(
              onPressed: () async{
                final result = await FilePicker.platform.pickFiles(
                    allowMultiple: false,
                    type: FileType.custom,
                    allowedExtensions: ['png', 'jpg', 'jpeg']);

                if (result == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text("No Image Selected")));
                  return;
                }
                final filePath = result.files.single.path!;
                const fileName = "profile";
                storage.uploadFile(filePath, fileName);
              },
              elevation: 2.0,
              fillColor: const Color(0xFF698269),
              padding: const EdgeInsets.all(15.0),
              shape: const CircleBorder(),
              child: const Icon(
                Icons.camera_alt_outlined,
                color: Color(0xFF03001C),
              ),
            )),
      ],
    );
  }

  Widget buildFormPart() {
    TextEditingController name = TextEditingController();
    TextEditingController id = TextEditingController();
    TextEditingController section = TextEditingController();
    TextEditingController birthdate = TextEditingController();
    TextEditingController aboutMe = TextEditingController();

    name.text = widget.documentSnapshot['name'];
    id.text = widget.documentSnapshot['id'].toString();
    section.text = widget.documentSnapshot['section'];
    Timestamp t = widget.documentSnapshot['birthdate'];
    DateTime date = t.toDate();
    DateTime? addDate;
    String formattedDate = DateFormat.yMMMEd().format(date);
    birthdate.text = formattedDate;
    aboutMe.text = widget.documentSnapshot['aboutMe'];
    return Form(
        child: Padding(
      key: formKey,
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      child: Column(
        children: [
          TextFormField(
            controller: name,
            keyboardType: TextInputType.name,
            decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Name",
                suffixIcon: Icon(Icons.person)),
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: id,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "ID",
                suffixIcon: Icon(Icons.person)),
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: section,
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Section",
                suffixIcon: Icon(Icons.meeting_room)),
          ),
          const SizedBox(height: 10),
          TextFormField(
            readOnly: true,
            controller: birthdate,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              labelText: 'Birthdate',
              prefixIcon: InkWell(
                child: const Icon(Icons.calendar_today),
                onTap: ()async{
                  DateTime d = DateTime.now();
                  addDate = await _selectDate(d);
                  String formattedDate = DateFormat('E, d MMM yyyy, h:mm a').format(addDate!);
                  birthdate.text = formattedDate;
                },
              ),
            ),
            validator: (value) {
              return (value == '')
                  ? 'Please enter a date and time'
                  : null;
            },
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: aboutMe,
            textAlignVertical: TextAlignVertical.center,
            keyboardType: TextInputType.multiline,
            maxLines: null,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: "About me",
              suffixIcon: Icon(Icons.info_outline),
              contentPadding:
                  EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () async {
              await storage.updateProfileData(ProfileModel(
                  id: int.parse(id.text),
                  name: name.text,
                  birthdate: addDate ?? date,
                  aboutMe: aboutMe.text,
                  section: section.text));
              Navigator.push(context, MaterialPageRoute(builder: (context)=> const HomePage()));
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF698269)),
            child: const Text("Save Changes",
                style: TextStyle(color: Color(0xFF03001C))),
          ),
        ],
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFB99B6B),
      appBar: AppBar(
        backgroundColor: const Color(0xFF698269),
        title: const Text("Edit Profile",
            style: TextStyle(color: Color(0xFF03001C))),
      ),
      body: RefreshIndicator(
          child: ListView(
              padding: EdgeInsets.zero,
              children: [buildTopPart(), buildFormPart()]),
          onRefresh: ()async{
            return Future.delayed(const Duration(seconds: 0));
          })
    );
  }
}
