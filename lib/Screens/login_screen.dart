import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:popcorn1/colours.dart';
import 'package:popcorn1/screens/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _rememberMe = false;
  bool loginSuccessful = false;

  @override
  void initState() {
    super.initState();
    // Check local storage for rememberMe setting
    _checkRememberMe();
  }

  //autofill
  Future<void> _checkRememberMe() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool rememberMe = prefs.getBool('rememberMe') ?? false;
    if (rememberMe) {
      // If rememberMe is true, set the checkbox value and fill in the username
      setState(() {
        _rememberMe = true;
        _emailController.text = prefs.getString('email') ?? '';
        _passwordController.text = prefs.getString('password') ?? '';
        // Password should not be stored in plain text for security reasons,
        // so you may not automatically fill the password field.
      });
    }
  }

  Future<void> _login(BuildContext context) async {
    // Perform login logic here
    // For simplicity, just printing the email and password
    print("email: ${_emailController.text}");
    print("Password: ${_passwordController.text}");

    // Check if the username and password are filled
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
    
    // Get the existing SharedPreferences instance
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if ((_rememberMe) && (loginSuccessful))
    {
      // Save the "Remember Me" setting and username in local storage
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool('rememberMe', _rememberMe);
      prefs.setString('email', _emailController.text);
      prefs.setString('password', _passwordController.text);
      // Password should not be stored in plain text for security reasons.
      // You may implement more secure solutions like token-based authentication.
    } else {
    // If "Remember Me" is not checked, erase the data in local storage
      prefs.remove('rememberMe');
      prefs.remove('email');
      prefs.remove('password');
    }

    if (loginSuccessful) {
      // Navigate to the HomeScreen and replace the login screen in the navigation stack
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    }
  }

  Future<void> _userAuthentication(BuildContext context) async {
  //show loading circle
    showDialog(
      context : context,
      builder : (context)
      {
        return const Center(
          child: CircularProgressIndicator()
        );
      }
      );
  try {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: _emailController.text,
      password: _passwordController.text,
    );

    // If the above line is executed without any errors, authentication is successful
    setState(() {
      loginSuccessful = true;
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
      loginSuccessful = false;
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
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
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
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                      children: [
                        Checkbox(
                          value: _rememberMe,
                          onChanged: (value) {
                            setState(() {
                              _rememberMe = value ?? false;
                            });
                          },
                        ),
                        const Text('Remember Me'),
                      ],
                ),
                const SizedBox(height: 20),
                Center( // Center the ElevatedButton
                    child: Container(
                      width: textFieldWidth, // Set the width if you want a fixed width
                      child: ElevatedButton(
                        onPressed: () => _login(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colours.themeColour,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 16,
                          ),
                        ),
                        child: const Text(
                          'Login',
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
                      'New user?',
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(width: 7),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const RegisterScreen()),
                        );
                      },
                      child: const Text(
                        'Register now',
                        style: TextStyle(
                          color: Colours.themeColour,
                          fontWeight: FontWeight.bold,
                        )
                      ),
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
