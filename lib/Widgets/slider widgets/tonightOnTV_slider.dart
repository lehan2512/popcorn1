import 'package:flutter/material.dart';
import 'package:popcorn1/Screens/tvDetails_screen.dart';
import 'package:popcorn1/constants.dart';

class TonightOnTVSlider extends StatelessWidget 
{
  const TonightOnTVSlider({
    super.key, required this.snapshot,
  });
final AsyncSnapshot snapshot;
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
        itemCount: snapshot.data.length,
        itemBuilder: (context, index) 
        {
          return Padding
          (
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector
            (
              onTap: ()
              {
                Navigator.push
                (
                  context,
                  MaterialPageRoute
                  (
                    builder: (context) => TVDetailsScreen
                    (
                      tv: snapshot.data[index]
                    )
                  )
                );
              },
              child: ClipRect
              (
                child: SizedBox
                (
                  height: 200,
                  width: 200,
                  child: Image.network
                  (
                    filterQuality: FilterQuality.high,
                    fit: BoxFit.cover,
                    '${Constants.imagePath}${snapshot.data[index].posterPath}'
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}