import 'package:flutter/material.dart';
import 'package:popcorn1/Screens/movieDetails_screen.dart';
import 'package:popcorn1/constants.dart';

class MovieSlider extends StatelessWidget {
  const MovieSlider({
    super.key, required this.snapshot,
  });

final AsyncSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column
    (
      crossAxisAlignment: CrossAxisAlignment.start,
      children:
      [
        Container
        (
          height: 200,
          child: ListView.builder
      (
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
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
                    builder: (context) => MovieDetailsScreen
                    (
                      movie: snapshot.data[index]
                    )
                  )
                );
              },
              child: Column(
                children: 
                [
                  ClipRect
                  (
                    child: SizedBox
                    (
                      height: 150,
                      width: 150,
                      child: Image.network(
                        '${Constants.imagePath}${snapshot.data[index].posterPath}',
                        filterQuality: FilterQuality.high,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text
                  (
                    snapshot.data[index].title,
                    style: TextStyle(
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
        )
      
      
      
    ]);
  }
}