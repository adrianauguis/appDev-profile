import 'dart:async';
import 'dart:io';

import 'package:auguis_profile/model/profile_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart' as firebase_core;


class Storage {
  final firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  Future<void> uploadFile(String filePath, String fileName)async{
    File file = File(filePath);
    try{
      await storage.ref('3QzkxWRoDCMOSBHTbqJw/uploads/$fileName').putFile(file);
    } on firebase_core.FirebaseException catch (e){
      print(e);
    }
  }

  Future <ProfileModel> updateProfileData(ProfileModel profileModel) async {
    final dbClient = FirebaseFirestore.instance.collection('user')
        .doc('3QzkxWRoDCMOSBHTbqJw');

    await dbClient.update(profileModel.toJson());
    return profileModel;
  }


  Future<firebase_storage.ListResult> listFiles()async{
    firebase_storage.ListResult result = await storage.ref('adrian').listAll();

    return result;
  }

  Stream<String> getPicStream(String imageName) {
    return storage.ref('3QzkxWRoDCMOSBHTbqJw/uploads/$imageName').getDownloadURL().asStream();
  }


  Future <String> getPic (String imageName)async{
    String downloadURL = await storage.ref('3QzkxWRoDCMOSBHTbqJw/uploads/$imageName').getDownloadURL();

    return downloadURL;
  }

}
