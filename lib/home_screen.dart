import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget
{
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
{
  @override
  Widget build(BuildContext context)
  {
    return Scaffold
    (
      appBar: AppBar
      (
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Image.asset
        (
          'assets/popcorn(2).png',
          fit: BoxFit.cover,
          height: 30,
          filterQuality: FilterQuality.high,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView
      (
        physics: const BouncingScrollPhysics(),
        child: Column
        (
          crossAxisAlignment: CrossAxisAlignment.start,
          children:
          [
            Text
            (
              'Trending movies',
              style: GoogleFonts.aBeeZee(fontSize: 25),
            )
          ],
        )
      )
    );
  }
}

