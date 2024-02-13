import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'colours.dart';

class TrendingMovies_slider extends StatelessWidget {
  const TrendingMovies_slider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox
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
    );
  }
}