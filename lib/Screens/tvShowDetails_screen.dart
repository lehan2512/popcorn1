// ignore_for_file: file_names, camel_case_types

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:popcorn1/Models/movie.dart';
import 'package:popcorn1/colours.dart';
import 'package:popcorn1/constants.dart';

class tvShowDetailsScreen extends StatefulWidget {
  final Movie movie;
  const tvShowDetailsScreen({super.key, required this.movie});

  @override
  State<tvShowDetailsScreen> createState() => _tvShowDetailsState();
}

class _tvShowDetailsState extends State<tvShowDetailsScreen> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            leading: Container(
              height: 70,
              width: 70,
              margin: const EdgeInsets.only(top: 16, left: 16),
              decoration: BoxDecoration(
                  color: Colours.scaffoldBgColour,
                  borderRadius: BorderRadius.circular(8)),
              child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back_ios_new_rounded)),
            ),
            backgroundColor: Colours.scaffoldBgColour,
            expandedHeight: 300,
            pinned: true,
            floating: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Container(
                  color: Colours.scaffoldBgColour.withOpacity(0.3),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    widget.movie.title,
                    style: GoogleFonts.aBeeZee(
                        fontSize: 16, fontWeight: FontWeight.w600),
                  )),
              background: Image.network(
                  '${Constants.imagePath}${widget.movie.backdropPath}',
                  filterQuality: FilterQuality.high,
                  fit: BoxFit.fitWidth),
            ),
          ),
          SliverToBoxAdapter(
              child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      Text(
                        'Overview',
                        style: GoogleFonts.aBeeZee(
                            fontSize: 20, fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        widget.movie.overview,
                        style: GoogleFonts.aBeeZee(
                            fontSize: 15, fontWeight: FontWeight.w400),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Text(
                            'Cast: ',
                            style: GoogleFonts.roboto(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: FutureBuilder(
                              future: fetchMainCharacters(widget.movie.id),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                } else if (snapshot.hasError) {
                                  return Center(
                                    child: Text(snapshot.error.toString()),
                                  );
                                } else if (snapshot.hasData) {
                                  // Display the cast names
                                  return Text(
                                    snapshot.data!.join(', '),
                                    style: GoogleFonts.roboto(
                                      fontSize: 12,
                                    ),
                                  );
                                } else {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Row(children: [
                        Text('Vote average: ',
                            style: GoogleFonts.roboto(
                                fontSize: 12, fontWeight: FontWeight.bold)),
                        Text(widget.movie.voteAverage.toStringAsFixed(1),
                            style: GoogleFonts.roboto(
                              fontSize: 12,
                            ))
                      ]),
                      const SizedBox(height: 20),
                    ],
                  )))
        ],
      ),
    );
  }
}
