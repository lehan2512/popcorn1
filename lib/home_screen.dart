import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colours.dart';

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
          height: 40,
          filterQuality: FilterQuality.high,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView
      (
        physics: const BouncingScrollPhysics(),
        child: Padding
        (
          padding: const EdgeInsets.all(8.0),
          child: Column
          (
            crossAxisAlignment: CrossAxisAlignment.start,
            children:
            [
              Text
              (
                'Trending movies',
                style: GoogleFonts.aBeeZee(fontSize: 20),
              ),
              const SizedBox(height: 15),
              SizedBox
              (
                width: double.infinity,
                child: CarouselSlider.builder
                (
                  itemCount: 10,
                  options: CarouselOptions
                  (
                    height: 200,
                    autoPlay: true,
                    viewportFraction: 0.55,
                    enlargeCenterPage: true,
                    pageSnapping: true,
                    autoPlayCurve: Curves.fastOutSlowIn,
                    autoPlayAnimationDuration: const Duration(seconds: 1),
                  ),
                  itemBuilder: (context, itemIndex, pageViewIndex)
                  {
                    return ClipRRect
                    (
                      borderRadius: BorderRadius.circular(16),
                      child: Container
                      (
                        height: 200,
                        width: 300,
                        color: Colours.themeColour,
                      ),
                    );
                  }
                )
              ),
              const SizedBox(height: 32),
              Text
              (
                'Trending TV shows',
                style: GoogleFonts.aBeeZee(fontSize: 20)
              ),
              const SizedBox(height: 15),
              SizedBox
              (
                height: 200,
                width: double.infinity,
                child: ListView.builder
                (
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemCount: 10,
                  itemBuilder: (context, index)
                  {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container
                      (
                          color: Colours.themeColour,
                          height: 200,
                          width: 200
                      ),
                    );
                  },
                )
              )
            ],
          ),
        )
      )
    );
  }
}

