import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:popcorn1/Screens/login_screen.dart';
import 'package:popcorn1/colours.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool registerSuccessful = false;

  Future<void> _register(BuildContext context) async {
    // For simplicity, just printing the email and password
    print("email: ${_emailController.text}");
    print("Password: ${_passwordController.text}");

    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      // Show an alert or snackbar indicating that both username and password are required
      // For simplicity, showing a snackbar here
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Both email and password are required.'),
        ),
      );
      return; // Exit the method if either username or password is empty
    }

    await _userAuthentication(context);

    if (registerSuccessful) {
      // Navigate to the HomeScreen and replace the login screen in the navigation stack
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  Future<void> _userAuthentication(BuildContext context) async {
    //show loading circle
    showDialog(
        context: context,
        builder: (context) {
          return const Center(child: CircularProgressIndicator());
        });
    try {
      if (_passwordController.text == _confirmPasswordController.text) {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Passwords don't match"),
          ),
        );
      }

      // If the above line is executed without any errors, authentication is successful
      setState(() {
        registerSuccessful = true;
      });
    } catch (e) {
      // If there's an error during authentication, show a message and set loginSuccessful to false
      print("Authentication Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid username or password. Please try again.'),
        ),
      );
      setState(() {
        registerSuccessful = false;
      });
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    double textFieldWidth = 350.0;

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/popcorn(2).png',
                  fit: BoxFit.cover,
                  height: 100,
                  filterQuality: FilterQuality.high,
                ),
                const SizedBox(height: 100),
                Container(
                  width: textFieldWidth,
                  child: TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email Address',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 20),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  width: textFieldWidth,
                  child: TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 20),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  width: textFieldWidth,
                  child: TextField(
                    controller: _confirmPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Confirm Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 20),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  // Center the ElevatedButton
                  child: Container(
                    width:
                        textFieldWidth, // Set the width if you want a fixed width
                    child: ElevatedButton(
                      onPressed: () => _register(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colours.themeColour,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 16,
                        ),
                      ),
                      child: const Text(
                        'Register',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colours.scaffoldBgColour,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Already registered?',
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(width: 7),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginScreen()),
                        );
                      },
                      child: const Text('Login',
                          style: TextStyle(
                            color: Colours.themeColour,
                            fontWeight: FontWeight.bold,
                          )),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
