import "package:path/path.dart";
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'dart:io';

import 'package:sqflite/sqflite.dart';
import 'package:task/Models/movie_model.dart';

class DatabaseHelper {
  static Database _database;

  String movie_database = 'Movie';

  String colMovieName = 'MovieName';
  String colMovieId = 'MovieId';
  String colDirector = 'Director';
  String colPoster = 'poster';

  Future<Database> get database async {
    if (_database != null) {
      return _database;
    }
    _database = await initDatabase();
    return _database;
  }

  initDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, "Insta_Influncer.db");
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int vesion) async {
    db.execute(
        'CREATE TABLE $movie_database($colMovieId integer primary key autoincrement, $colMovieName TEXT, $colDirector TEXT, $colPoster TEXT)');
  }

  Future<List<MovieModel>> getTrans({int offset}) async {
    var dbClient = await database;

    final List<Map<String, dynamic>> maps =
        await dbClient.query(movie_database, limit: 10, offset: offset);

    return List.generate(maps.length, (i) {
      return MovieModel(
          movieId: maps[i][colMovieId],
          movieName: maps[i][colMovieName]?.toString(),
          director: maps[i][colDirector]?.toString(),
          poster: maps[i][colPoster]?.toString());
    });
  }

  Future<Map<String, dynamic>> findById(int movieId) async {
    var dbClient = await database;
    List<Map<String, dynamic>> maps = await dbClient
        .rawQuery("SELECT * FROM $movie_database WHERE $colMovieId = $movieId");
    return maps[0];
  }

  Future<bool> isPresent(String movieName) async {
    var dbClient = await database;
    List<Map<String, dynamic>> maps = await dbClient.rawQuery(
        "SELECT * FROM $movie_database WHERE $colMovieName = ${movieName.toLowerCase()}");

    if (maps.length == 0) {
      print(maps.length);
      return false;
    } else {
      return true;
    }
  }

  Future<int> addTransToDatabase(MovieModel movie) async {
    var dbClient = await database;
    // final _isPresent = await isPresent(movie.movieName);
    // if (_isPresent) {
    //   throw Exception();
    // } else {
    final movieId = await dbClient.insert(movie_database, {
      colMovieName: movie.movieName,
      colDirector: movie.director,
      colPoster: movie.poster
    });

    return movieId;
    // }
  }

  Future<void> delete({int movieId}) async {
    var dbClient = await database;

    await dbClient.delete(
      movie_database,
      where: '$colMovieId = ?',
      whereArgs: [movieId],
    );
  }

  Future<void> updateDatabase(
      {int movieid, String movieName, String director, String poster}) async {
    var dbClient = await database;
    print(movieid);
    await dbClient.rawUpdate(
        'UPDATE $movie_database SET $colMovieName = ?, $colDirector = ?, $colPoster=? WHERE $colMovieId = ?',
        [movieName, director, poster, movieid]);
  }

  Future close() async {
    var dbClient = await database;
    dbClient.close();
  }
}
