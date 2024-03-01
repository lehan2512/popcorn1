import 'package:popcorn1/Widgets/searchBar.dart';
import 'package:flutter/material.dart';


class SearchScreen extends StatelessWidget 
{
  @override
  Widget build(BuildContext context) 
  {
    return Scaffold
    (
      appBar: AppBar
      (
        title: Text('Search'),
        leading: IconButton
        (
          icon: Icon(Icons.arrow_back),
          onPressed: () 
          {
            Navigator.pop(context);
          },
        ),
      ),
      body: searchBarFunc(),
    );
  }
}
