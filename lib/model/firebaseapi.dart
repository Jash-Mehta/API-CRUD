import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';

class FirebasePDFApi {
  static UploadTask? uploadFile(String destination, final file) {
    try {
      final ref = FirebaseStorage.instance.ref(destination);
      print(ref);
      return ref.putFile(file);
    } on FirebaseException catch (e) {
      return null;
    }
  }

  static UploadTask? uploadtask(String destination, Uint8List file) {
    try {
      final ref = FirebaseStorage.instance.ref(destination);
      return ref.putData(file);
    } on FirebaseException catch (e) {
      return null;
    }
  }
}
class FirebaseimageApi {
  static UploadTask? uploadFile(String destination, final file) {
    try {
      final ref = FirebaseStorage.instance.ref(destination);
      print(ref);
      return ref.putFile(file);
    } on FirebaseException catch (e) {
      return null;
    }
  }

  static UploadTask? uploadtask(String destination, Uint8List file) {
    try {
      final ref = FirebaseStorage.instance.ref(destination);
      return ref.putData(file);
    } on FirebaseException catch (e) {
      return null;
    }
  }
}
