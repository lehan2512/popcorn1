import 'package:flutter/material.dart';
import 'package:popcorn1/colours.dart';

class CinemaSlider extends StatelessWidget {
  const CinemaSlider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox
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
          return Padding
          (
            padding: const EdgeInsets.all(8.0),
            child: Container
            (
              color: Colours.themeColour,
              height: 200,
              width: 200,
            ),
          );
        },
      ),
    );
  }
}