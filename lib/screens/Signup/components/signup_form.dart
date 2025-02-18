import 'package:flutter/material.dart';
import '../../../components/already_have_an_account_acheck.dart';
import '../../../constants.dart';
import '../../Login/login_screen.dart';

class SignUpForm extends StatelessWidget {
  final void Function() signUp;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final String selectedRole;
  final void Function(String?) onRoleChanged;

  const SignUpForm({
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
      children: [
        // Email input
        TextFormField(
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          cursorColor: kPrimaryColor,
          decoration: const InputDecoration(
            hintText: "Your email",
            prefixIcon: Padding(
              padding: EdgeInsets.all(defaultPadding),
              child: Icon(Icons.email),
            ),
          ),
        ),
        const SizedBox(height: defaultPadding),

        // Password input
        TextFormField(
          controller: passwordController,
          textInputAction: TextInputAction.done,
          obscureText: true,
          cursorColor: kPrimaryColor,
          decoration: const InputDecoration(
            hintText: "Your password",
            prefixIcon: Padding(
              padding: EdgeInsets.all(defaultPadding),
              child: Icon(Icons.lock),
            ),
          ),
        ),
        const SizedBox(height: defaultPadding),

        // Role selection dropdown
        DropdownButtonFormField<String>(
          value: selectedRole,
          onChanged: onRoleChanged,
          decoration: const InputDecoration(
            labelText: 'Select your role',
            prefixIcon: Padding(
              padding: EdgeInsets.all(defaultPadding),
              child: Icon(Icons.person),
            ),
          ),
          items: const [
            DropdownMenuItem(value: 'client', child: Text('Client')),
            DropdownMenuItem(value: 'handyman', child: Text('Handyman')),
          ],
        ),
        const SizedBox(height: defaultPadding),

        // Sign Up button
        ElevatedButton(
          onPressed: signUp,
          child: Text("Sign Up".toUpperCase()),
        ),
        const SizedBox(height: defaultPadding),

        // Already have an account check
        AlreadyHaveAnAccountCheck(
          login: false,
          press: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return const LoginScreen();
                },
              ),
            );
          },
        ),
      ],
    );
  }
}
