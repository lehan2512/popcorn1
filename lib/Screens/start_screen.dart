import 'package:flutter/material.dart';
import 'package:popcorn1/Screens/login_screen.dart';
import 'package:popcorn1/Screens/register_screen.dart';
import 'package:popcorn1/colours.dart';

class StartupScreen extends StatefulWidget {
  const StartupScreen({Key? key}) : super(key: key);

  @override
  _StartupScreenState createState() => _StartupScreenState();
}

class _StartupScreenState extends State<StartupScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000), // Animation duration
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn, // Fade-in curve
      ),
    );
    _animationController.forward(); // Start the animation
  }

  @override
  void dispose() {
    _animationController.dispose(); // Dispose animation controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Set background color to black
      body: FadeTransition(
        opacity: _animation, // Apply fade-in animation
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Column(
                children: [
                  Image.asset(
                    'assets/popcorn(2).png', // Your logo asset
                    height: 200,
                    width: 350,
                    fit: BoxFit.contain,
                  ),
                  SizedBox(
                      height: 10), // Add some space between logo and slogan
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal:
                            20), // Adjust the horizontal padding as needed
                    child: Text(
                      'Welcome to Popcorn: Your Gateway to Cinematic Exploration!\n\nEmbark on an immersive journey into the captivating world of cinema with Popcorn, your ultimate movie companion. As the startup screen greets you, prepare to delve into a realm where movie magic knows no bounds.', // Your slogan
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
                height: 60), // Add some space between the slogan and buttons
            Center(
              child: Column(
                children: [
                  SizedBox(
                    width: 300, // Set the width if you want a fixed width
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()),
                        );
                      },
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
                  SizedBox(height: 25), // Add some space between buttons
                  SizedBox(
                    width: 300, // Set the width if you want a fixed width
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RegisterScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
