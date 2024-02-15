import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:popcorn1/colours.dart';

class TrendingTVSlider extends StatelessWidget {
  const TrendingTVSlider({
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
          viewportFraction: 0.45,
          pageSnapping: true,
        ),
        itemBuilder: (context, itemIndex, pageViewIndex)
        {
          return ClipRRect
          (
            borderRadius: BorderRadius.circular(16),
            child: Container
            (
              height: 200,
              width: 200,
              color: Colours.themeColour,
            ),
          );
        }
      )
    );
  }
}