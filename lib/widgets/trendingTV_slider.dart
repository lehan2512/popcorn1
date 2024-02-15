import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:popcorn1/constants.dart';

class TrendingTVSlider extends StatelessWidget {
  const TrendingTVSlider({
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
        itemCount: snapshot.data.length,
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
            child: SizedBox
            (
              height: 200,
              width: 200,
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