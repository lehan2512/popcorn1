import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Function to save user information to Firestore
Future<void> saveUserInfoToFirestore(String email) async {
  try {
    // Get the current user
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Reference to the users collection in Firestore
      CollectionReference<Map<String, dynamic>> users =
          FirebaseFirestore.instance.collection('users');

      // Add a new document with a generated ID
      await users.doc(user.uid).set({
        'email': email,
        // You can add more fields as per your requirement
      });
    } else {
      print('User is not signed in.');
    }
  } catch (e) {
    print('Error saving user information: $e');
  }
}

Future<void> saveMovieDetailsToFirestore(String userId, int movieId, String listType) async {
  try {
    // Reference to the user's document in the users collection
    DocumentReference<Map<String, dynamic>> userDocRef =
        FirebaseFirestore.instance.collection('users').doc(userId);

    // Reference to the "watched" subcollection within the user's document
    CollectionReference<Map<String, dynamic>> watchedMovies =
        userDocRef.collection('watched');

    // Add a new document with a specific ID (movieId in this case)
    await watchedMovies.doc(movieId.toString()).set({
      'id': movieId,
      // Add more fields as per your requirement
    });
  } catch (e) {
    print('Error saving movie details: $e');
  }
}