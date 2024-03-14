import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:popcorn1/Screens/gridView_screen.dart';
import 'package:popcorn1/Screens/tvShowDetails_screen.dart';
import 'package:popcorn1/constants.dart';

class TvShowSlider extends StatelessWidget {
  final AsyncSnapshot snapshot;
  final String categorytittle;
  final int itemlength;

  const TvShowSlider({
    super.key,
    required this.snapshot,
    required this.categorytittle,
    required this.itemlength,
  });

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
            padding: const EdgeInsets.only(left: 10.0, top: 15, bottom: 10),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CategoryListScreen(
                              movies: snapshot.data,
                              categoryTitle:
                                  categorytittle, // Pass the entire list of movies
                            )));
              },
              child: Text(
                categorytittle,
                style: GoogleFonts.aBeeZee(fontSize: 20),
              ),
            )),
        SizedBox(
            height: 250,
            width: double.infinity,
            child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemCount: itemlength,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => tvShowDetailsScreen(
                                    movie: snapshot.data[index])));
                      },
                      child: Container(
                        margin: const EdgeInsets.only(left: 13),
                        width: 130,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(18),
                                image: DecorationImage(
                                  image: NetworkImage(
                                    '${Constants.imagePath}${snapshot.data[index].posterPath}',
                                  ),
                                  fit: BoxFit.contain,
                                ),
                              ),
                              height: 200, // Adjust as needed
                              width: 150,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                })),
      ])
    ]);
  }
}
