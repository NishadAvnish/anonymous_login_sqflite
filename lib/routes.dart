import 'package:flutter/material.dart';
import 'package:task/Models/movie_model.dart';
import 'package:task/Pages/MovieListPage/movie_list.dart';

import 'Pages/AddMovie/add_movie.dart';
import 'Pages/Login/login_screen.dart';
import 'Pages/Login/signup_screen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case "/":
        return MaterialPageRoute(builder: (context) => MovieListPage());
      case "/addMovie":
        return MaterialPageRoute(builder: (context) => AddMovie());
      case "/loginPage":
        return MaterialPageRoute(builder: (context) => LoginScreen());
      case "/signupPage":
        return MaterialPageRoute(builder: (context) => SignupScreen());
      case "/editMovie":
        MovieModel movie = settings.arguments;
        return MaterialPageRoute(
            builder: (context) => AddMovie(
                  movie: movie,
                ));
    }
  }
}
