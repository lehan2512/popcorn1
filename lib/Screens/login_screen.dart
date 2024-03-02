import 'package:flutter/material.dart';
import 'package:popcorn1/screens/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool _rememberMe = false;

  @override
  void initState() {
    super.initState();
    // Check local storage for rememberMe setting
    _checkRememberMe();
  }

  Future<void> _checkRememberMe() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool rememberMe = prefs.getBool('rememberMe') ?? false;
    if (rememberMe) {
      // If rememberMe is true, set the checkbox value and fill in the username
      setState(() {
        _rememberMe = true;
        _usernameController.text = prefs.getString('username') ?? '';
        _passwordController.text = prefs.getString('password') ?? '';
        // Password should not be stored in plain text for security reasons,
        // so you may not automatically fill the password field.
      });
    }
  }

  Future<void> _login(BuildContext context) async {
    // Perform login logic here
    // For simplicity, just printing the email and password
    print("Username: ${_usernameController.text}");
    print("Password: ${_passwordController.text}");

    // Check if the username and password are filled
  if (_usernameController.text.isEmpty || _passwordController.text.isEmpty) {
    // Show an alert or snackbar indicating that both username and password are required
    // For simplicity, showing a snackbar here
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Both username and password are required.'),
      ),
    );
    return; // Exit the method if either username or password is empty
    }

    // Check if the login is successful (You can replace this with your actual authentication logic)
    bool loginSuccessful = true; // Replace this with your authentication logic

    // Get the existing SharedPreferences instance
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (_rememberMe) {
      // Save the "Remember Me" setting and username in local storage
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool('rememberMe', _rememberMe);
      prefs.setString('username', _usernameController.text);
      prefs.setString('password', _passwordController.text);
      // Password should not be stored in plain text for security reasons.
      // You may implement more secure solutions like token-based authentication.
    } else {
    // If "Remember Me" is not checked, erase the data in local storage
      prefs.remove('rememberMe');
      prefs.remove('username');
      prefs.remove('password');
    }

    if (loginSuccessful) {
      // Navigate to the HomeScreen and replace the login screen in the navigation stack
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double textFieldWidth = 350.0;

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/popcorn(2).png',
                fit: BoxFit.cover,
                height: 100,
                filterQuality: FilterQuality.high,
              ),
              SizedBox(height: 100),
              Container(
                width: textFieldWidth,
                child: TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 20),
                  ),
                ),
              ),
              SizedBox(height: 16),
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
                    contentPadding: EdgeInsets.symmetric(horizontal: 20),
                  ),
                ),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
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
                      Text('Remember Me'),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () => _login(context),
                    child: Text('Login'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
