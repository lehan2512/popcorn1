import 'package:flutter/material.dart';
import 'package:popcorn1/Screens/movieDetails_screen.dart';
import 'package:popcorn1/constants.dart';


// ignore: camel_case_types
class movieSlider extends StatelessWidget
{
  const movieSlider
  (
    {super.key, 
      required this.snapshot,
      required this.categorytittle,
      required this.itemlength,
    }
  );

  final AsyncSnapshot snapshot;
  final String categorytittle;
  final int itemlength;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200, 
      width: double.infinity,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: snapshot.data!.length,
        itemBuilder: (context,index){
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child:  GestureDetector(
              onTap: (){
                Navigator.push(
                  context,
                   MaterialPageRoute(
                    builder: (context)=> MovieDetailsScreen(
                      movie: snapshot.data[index]
                    ),
                  ),
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox( 
            
                  height: 200,
                  width: 150,
                  child: Image.network(
                    filterQuality: FilterQuality.high,
                    fit: BoxFit.cover,
                    '${Constants.imagePath}${snapshot.data[index].posterPath}'
                  ),
                 ),
              ),
            ),
          );
        },
      ) ,
    
    );
  }
}