import 'package:flutter/material.dart';
import 'package:popcorn1/Widgets/searchBar.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(
          margin: const EdgeInsets.only(top: 16, left: 16),
          child: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: const searchBarFunc(),
    );
  }
}
