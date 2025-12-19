import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

String get uid => FirebaseAuth.instance.currentUser!.uid;

CollectionReference<Map<String, dynamic>> shelvesRef() =>
    FirebaseFirestore.instance.collection('users').doc(uid).collection('shelves');

CollectionReference<Map<String, dynamic>> itemsRef() =>
    FirebaseFirestore.instance.collection('users').doc(uid).collection('items');
