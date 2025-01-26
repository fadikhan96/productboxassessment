import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class FirebaseService {
  static late FirebaseFirestore firestore;

  static Future<void> initializeFirebase() async {
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: "AIzaSyAVWn4OCZpXxkfyqD_XVVda2Z96Sx1wUj8",
        appId: "1:452391772096:android:54be3ed7aa481ea7ec7225",
        messagingSenderId: "452391772096",
        projectId: "first-firebase-87667",
        storageBucket: "first-firebase-87667.appspot.com",
      )
    );
    firestore = FirebaseFirestore.instance;
  }


  static Future<void> toggleFavoriteMovie(Map<String, dynamic> movieData) async {
    final snapshot = await firestore
        .collection('favorites')
        .where('id', isEqualTo: movieData['id'])
        .get();

    if (snapshot.docs.isNotEmpty) {
      await snapshot.docs.first.reference.delete();
    } else {
      await firestore.collection('favorites').add(movieData);
    }
  }

  static Future<List<Map<String, dynamic>>> getFavoriteMovies() async {
    final snapshot = await firestore.collection('favorites').get();
    return snapshot.docs
        .map((doc) => {"id": doc.id, ...doc.data()})
        .toList();
  }
}
