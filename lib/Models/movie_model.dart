import 'package:flutter/cupertino.dart';

class MovieModel with ChangeNotifier {
  String movieName, director, poster;
  int movieId;

  MovieModel({this.movieName, this.director, this.poster, this.movieId});
}
