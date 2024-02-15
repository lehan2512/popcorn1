import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:popcorn1/constants.dart';

class TrendingMoviesSlider extends StatelessWidget {
  const TrendingMoviesSlider({
    super.key, required this.snapshot,
  });

final AsyncSnapshot snapshot;

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
            child: SizedBox
            (
              height: 200,
              width: 300,
              child: Image.network
              (
                filterQuality: FilterQuality.high,
                fit: BoxFit.cover,
                '${Constants.imagePath}${snapshot.data[itemIndex].posterPath}'
              ),
            ),
          );
        }
      )
    );
  }
}