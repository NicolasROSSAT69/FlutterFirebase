import 'package:flutter/material.dart';

class SearchMoviePage extends StatefulWidget {
  const SearchMoviePage({Key? key}) : super(key: key);

  @override
  _SearchMoviePageState createState() => _SearchMoviePageState();
}

class _SearchMoviePageState extends State<SearchMoviePage> {
  _SearchMoviePageState();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Movie'),
      ),
      body: const Center(
        child: Text('Search Movie'),
      ),
    );
  }
}
