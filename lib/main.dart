import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'views/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(); // Initialize Firebase
  } catch (e) {
    print("Firebase initialization error: $e");
  }

  runApp(const FundiSmartApp());
}

class FundiSmartApp extends StatelessWidget {
  const FundiSmartApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FundiSmart',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Roboto',
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const HomeScreen(),
    );
  }
}

// ✅ Google Sign-In Function
Future<User?> signInWithGoogle() async {
  try {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) {
      print("Google Sign-In canceled by user.");
      return null;
    }

    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
    print("Google Sign-In successful: ${userCredential.user?.displayName}");
    return userCredential.user;
  } catch (e) {
    print("Google Sign-In Error: $e");
    return null;
  }
}

// ✅ Sign Out Function
Future<void> signOut() async {
  try {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
    print("User signed out successfully.");
  } catch (e) {
    print("Error signing out: $e");
  }
}
