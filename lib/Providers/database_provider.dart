import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:task/Helpers/database_helper.dart';
import 'package:task/Models/movie_model.dart';

class DatabaseHelperProvider with ChangeNotifier {
  List<MovieModel> _movieList = [];

  bool _isMoreDataAvailable = true;
  bool get isMoreDataAvailable {
    return _isMoreDataAvailable;
  }

  List<MovieModel> get movieList {
    return [..._movieList];
  }

  Future<void> fetchDatabaseData({bool pagination = false}) async {
    final _tempData =
        await DatabaseHelper().getTrans(offset: _movieList.length);
    if (pagination) {
      _movieList.addAll(_tempData);
    } else {
      _movieList = _tempData;
    }
    await Future.delayed(Duration(seconds: 2));
    if (_tempData.length < 10) {
      _isMoreDataAvailable = false;
    }

     notifyListeners();
  }

  Future<void> addToDatabase(MovieModel movie, BuildContext context) async {
    try {
        final movie1 = MovieModel(
            movieName: movie.movieName,
            director: movie.director,
            poster: movie.poster);
        final int movieId = await DatabaseHelper().addTransToDatabase(movie1);

        Map<String, dynamic> lastAddedData =
            await DatabaseHelper().findById(movieId);
        _movieList.add(MovieModel(
          movieId: movieId,
          movieName: lastAddedData["MovieName"],
          director: lastAddedData["Director"],
          poster: lastAddedData["poster"],
        ));
  
      notifyListeners();
    } catch (e) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              "Something went Wrong!. May be same movie Name is present in database")));
    }
  }

  Future<void> deleteFromDatabase({int movieId}) async {
    try {
      await DatabaseHelper().delete(movieId: movieId);
      _movieList.removeWhere((element) => element.movieId == movieId);

      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<void> updateDatabase({movieId, movieName, director, poster}) async {
    try {
      await DatabaseHelper().updateDatabase(
          movieid: movieId,
          director: director,
          movieName: movieName,
          poster: poster);
      final index =
          _movieList.indexWhere((element) => element.movieId == movieId);

      if (index != -1) {
        _movieList[index].movieName = movieName;
        _movieList[index].director = director;
        _movieList[index].poster = poster;
      }

      notifyListeners();
    } catch (e) {
      throw e;
    }
  }
}
