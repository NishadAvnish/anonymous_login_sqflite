import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:task/Constants/const_color.dart';
import 'package:task/Constants/const_value.dart';
import 'package:task/Constants/strings.dart';
import 'package:task/Helpers/text_field_helper.dart';
import 'package:task/Models/movie_model.dart';
import 'package:task/Providers/database_provider.dart';

class AddMovie extends StatefulWidget {
  MovieModel movie;
  AddMovie({Key key, this.movie}) : super(key: key);

  @override
  _AddMovieState createState() => _AddMovieState();
}

class _AddMovieState extends State<AddMovie> {
  TextEditingController movieNameController;
  TextEditingController directorController;
  TextEditingController posterController;

  final _formKey = GlobalKey<FormState>();
  bool _showImageContainer;
  FirebaseAuth _auth;
  @override
  void initState() {
    super.initState();
    movieNameController = TextEditingController();
    directorController = TextEditingController();
    posterController = TextEditingController();

    if (widget.movie != null) {
      movieNameController.text = widget.movie.movieName;
      directorController.text = widget.movie.director;
      posterController.text = widget.movie.poster;
      _showImageContainer = true;
    } else {
      _showImageContainer = false;
    }

    if (mounted) {
      _auth = FirebaseAuth.instance;
      print(_auth.currentUser);
    }
  }

  @override
  void dispose() {
    movieNameController?.dispose();
    directorController?.dispose();
    posterController?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(ConstString.ADD_MOVIE),
        centerTitle: true,
      ),
      body: SafeArea(
          child: _auth?.currentUser?.email == null
              ? Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, "/loginPage");
                    },
                    child: Text(
                      "To add new movie please login first.\n Click Here",
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .button
                          .copyWith(color: Colors.grey),
                    ),
                  ),
                )
              : !_auth.currentUser.emailVerified
                  ? Text(
                      "Please verify your email address to proceed. Check registered email for verification code.",
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .button
                          .copyWith(color: Colors.grey),
                    )
                  : Form(
                      key: _formKey,
                      child: SingleChildScrollView(
                        child: Padding(
                          padding:
                              const EdgeInsets.all(ConstValue.LEFT_PADDING),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                height:
                                    ConstValue.LARGE_VERTICAL_SIZE_BETWEEN_ELE,
                              ),
                              Text(
                                "Fill all the details in respective field to add or edit movie Database",
                                textAlign: TextAlign.center,
                                style: Theme.of(context)
                                    .textTheme
                                    .button
                                    .copyWith(color: Colors.grey),
                              ),
                              SizedBox(
                                height:
                                    ConstValue.LARGE_VERTICAL_SIZE_BETWEEN_ELE,
                              ),
                              TextFieldHelperWidget(
                                  controller: movieNameController,
                                  labelText: "Movie Name",
                                  inputAction: TextInputAction.next,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return "Movie Name can\'t be null";
                                    }

                                    return null;
                                  }),
                              SizedBox(
                                height: ConstValue.VERTICAL_SIZE_BETWEEN_ELE,
                              ),
                              TextFieldHelperWidget(
                                  controller: directorController,
                                  labelText: "Director",
                                  inputAction: TextInputAction.next,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return "Fill Director Name";
                                    }

                                    return null;
                                  }),
                              SizedBox(
                                height: ConstValue.VERTICAL_SIZE_BETWEEN_ELE,
                              ),
                              TextFieldHelperWidget(
                                  controller: posterController,
                                  labelText: "Poster",
                                  inputAction: TextInputAction.done,
                                  onFieldSubmitted: (value) {
                                    setState(() {
                                      _showImageContainer = true;
                                      posterController.text = value;
                                    });
                                  },
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return "Poster is mandatory";
                                    } else if (!value
                                            .toString()
                                            .contains("http") &&
                                        !value.toString().contains("https")) {
                                      return "Invalid Url";
                                    }

                                    return null;
                                  }),
                              SizedBox(
                                height: ConstValue.VERTICAL_SIZE_BETWEEN_ELE,
                              ),
                              _showImageContainer
                                  ? Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.25,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: ConstColor.BORDER_COLOR),
                                        borderRadius: BorderRadius.circular(
                                            ConstValue.BORDER_RADIUS),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                            ConstValue.BORDER_RADIUS),
                                        child: FadeInImage(
                                          image: NetworkImage(
                                              posterController.text),
                                          placeholder:
                                              AssetImage("Assets/loading.gif"),
                                          imageErrorBuilder:
                                              (context, error, stackTrace) {
                                            return Center(
                                              child: Text('😢Image Not found',
                                                  textAlign: TextAlign.center),
                                            );
                                          },
                                          fit: BoxFit.fitWidth,
                                        ),
                                      ),
                                    )
                                  : Container(),
                              SizedBox(
                                height: ConstValue.VERTICAL_SIZE_BETWEEN_ELE,
                              ),
                              MaterialButton(
                                color: Colors.blue,
                                padding: const EdgeInsets.symmetric(
                                    vertical: ConstValue.SMALL_PADDING,
                                    horizontal: ConstValue.LEFT_PADDING),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        ConstValue.BORDER_RADIUS)),
                                onPressed: () {
                                  if (_formKey.currentState.validate()) {
                                    final DatabaseHelperProvider provider =
                                        Provider.of<DatabaseHelperProvider>(
                                            context,
                                            listen: false);
                                    if (widget.movie != null) {
                                      provider
                                          .updateDatabase(
                                              movieId: widget.movie.movieId,
                                              movieName:
                                                  movieNameController.text,
                                              director: directorController.text,
                                              poster: posterController.text)
                                          .then((value) {
                                        ScaffoldMessenger.of(context)
                                            .hideCurrentSnackBar();
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                content: Text(
                                                    "Movie Database Updated")));
                                      }).catchError((e) {
                                        ScaffoldMessenger.of(context)
                                            .hideCurrentSnackBar();
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                content: Text(
                                                    "Something went wrong!")));
                                      });
                                    } else {
                                      provider
                                          .addToDatabase(
                                              MovieModel(
                                                  movieName:
                                                      movieNameController.text,
                                                  director:
                                                      directorController.text,
                                                  poster:
                                                      posterController.text),
                                              context)
                                          .then((value) {
                                        ScaffoldMessenger.of(context)
                                            .hideCurrentSnackBar();
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                content: Text("Movie Added")));

                                        movieNameController.clear();
                                        posterController.clear();
                                        directorController.clear();
                                      }).catchError((e) {
                                        ScaffoldMessenger.of(context)
                                            .hideCurrentSnackBar();
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                content: Text(
                                                    "Something went wrong!")));
                                      });
                                    }
                                  }
                                },
                                child: Text(
                                  widget.movie != null
                                      ? "Edit Movie"
                                      : "Add Movie",
                                  style: Theme.of(context)
                                      .textTheme
                                      .button
                                      .copyWith(fontWeight: FontWeight.bold),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    )),
    );
  }
}
