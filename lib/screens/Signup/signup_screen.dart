import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fundismart/constants.dart'; // Assuming constants are available
import 'package:fundismart/responsive.dart'; // Assuming responsive is configured
import '../../components/background.dart';
import 'components/sign_up_top_image.dart';
import 'components/signup_form.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  String _selectedRole = 'client'; // Default role is client

  // Text controllers for user inputs
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Function to handle user sign-up
  Future<void> _signUp() async {
    try {
      // Create the user with email and password
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      // Save the role in Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'email': _emailController.text,
        'role': _selectedRole,
        'uid': userCredential.user!.uid,
      });

      // Redirect the user based on their role
      if (_selectedRole == 'client') {
        Navigator.pushReplacementNamed(context, '/home'); // Client redirected to HomeScreen
      } else if (_selectedRole == 'handyman') {
        Navigator.pushReplacementNamed(context, '/handymanProfile'); // Handyman redirected to fill profile
      }
    } catch (e) {
      print("Error during sign-up: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Background(
      child: SingleChildScrollView(
        child: Responsive(
          mobile: MobileSignupScreen(
            signUp: _signUp,
            emailController: _emailController,
            passwordController: _passwordController,
            selectedRole: _selectedRole,
            onRoleChanged: (role) {
              setState(() {
                _selectedRole = role!;
              });
            },
          ),
          desktop: Row(
            children: [
              Expanded(
                child: SignUpScreenTopImage(),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 450,
                      child: SignUpForm(
                        signUp: _signUp,
                        emailController: _emailController,
                        passwordController: _passwordController,
                        selectedRole: _selectedRole,
                        onRoleChanged: (role) {
                          setState(() {
                            _selectedRole = role!;
                          });
                        },
                      ),
                    ),
                    SizedBox(height: defaultPadding / 2),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MobileSignupScreen extends StatelessWidget {
  final void Function() signUp;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final String selectedRole;
  final void Function(String?) onRoleChanged;

  const MobileSignupScreen({
    Key? key,
    required this.signUp,
    required this.emailController,
    required this.passwordController,
    required this.selectedRole,
    required this.onRoleChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SignUpScreenTopImage(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
          child: SignUpForm(
            signUp: signUp,
            emailController: emailController,
            passwordController: passwordController,
            selectedRole: selectedRole,
            onRoleChanged: onRoleChanged,
          ),
        ),
      ],
    );
  }
}
