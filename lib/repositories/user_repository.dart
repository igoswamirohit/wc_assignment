import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UserRepository {
  UserRepository();

  final db = FirebaseFirestore.instance;
  final storageRef = FirebaseStorage.instance.ref();

  Future<DocumentReference> createUser(Map<String, dynamic> userData) async {
    return await db.collection('Users').add(userData);
  }

  Future<void> editUser(String id, Map<String, dynamic> userData) async {
    return await db
        .collection('Users')
        .doc(id)
        .set(userData, SetOptions(merge: true));
  }

  Future<void> deleteUser(String userId) async {
    return await db.collection('Users').doc(userId).delete();
  }

  Future<String> uploadImage(String path) async {
    final imageRef = storageRef.child(path.split('/').last);
    await imageRef.putFile(File(path));
    return await imageRef.getDownloadURL();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> fetchUsers() {
    return db
        .collection('Users')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }
}
