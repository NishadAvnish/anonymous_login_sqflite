import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task/Constants/const_value.dart';
import 'package:task/Constants/strings.dart';
import 'package:task/Helpers/dialog_helper.dart';
import 'package:task/Models/movie_model.dart';
import 'package:task/Providers/database_provider.dart';

import 'Widgets/list_item.dart';

class MovieListPage extends StatefulWidget {
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<MovieListPage> {
  // DatabaseHelper databasehelper;

  bool _isLoading, _isLogout;
  bool _isLoadingMoreData;
  double _previousCurrentPosition = 0.0;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    _isLoadingMoreData = false;
    _isLogout = false;
    // databasehelper = DatabaseHelper();

    if (this.mounted) {
      _scrollController.addListener(() {
        final _maxExtent = _scrollController.position.maxScrollExtent;
        final _current = _scrollController.position.pixels;

        if (_maxExtent == _current &&
            _current - _previousCurrentPosition > 130) {
          _previousCurrentPosition = _current;
          _getMoreData();
        }
      });
    }

    if (mounted) {
      _fetchData();
    }
  }

  Future<void> _fetchData() async {
    await Provider.of<DatabaseHelperProvider>(context, listen: false)
        .fetchDatabaseData();
    setState(() {
      _isLoading = false;
    });
  }

  _getMoreData() async {
    if (mounted) {
      setState(() {
        _isLoadingMoreData = true;
      });
    }

    if (Provider.of<DatabaseHelperProvider>(context, listen: false)
        .isMoreDataAvailable) {
      await Provider.of<DatabaseHelperProvider>(context, listen: false)
          .fetchDatabaseData(pagination: true);
    }
    if (this.mounted) {
      setState(() {
        _isLoadingMoreData = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(ConstString.HOME_SCREEN),
          centerTitle: true,
          leading: null,
          actions: [
            if (FirebaseAuth.instance?.currentUser?.email != null && !_isLogout)
              Padding(
                padding: const EdgeInsets.only(right: ConstValue.RIGHT_PADDING),
                child: GestureDetector(
                    onTap: () {
                      FirebaseAuth.instance.signOut();
                      setState(() {
                        _isLogout = true;
                      });
                    },
                    child: Icon(Icons.logout)),
              )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.of(context).pushNamed("/addMovie"),
          child: Icon(Icons.add),
        ),
        body: SafeArea(
          child: _isLoading
              ? Center(child: DialogHelper.showLoading())
              : Consumer<DatabaseHelperProvider>(
                  builder: (context, snapshot, _) {
                  return snapshot.movieList.length == 0
                      ? Center(
                          child: Text("No Data Found!"),
                        )
                      : Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: ConstValue.LEFT_PADDING,
                              vertical: ConstValue.TOP_PADDING),
                          child: ListView.builder(
                            controller: _scrollController,
                            itemBuilder: (context, int index) {
                              if (index == snapshot.movieList.length) {
                                return _isLoadingMoreData
                                    ? Align(
                                        alignment: Alignment.center,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: DialogHelper.showLoading(),
                                        ))
                                    : Container();
                              } else {
                                MovieModel movie = MovieModel();
                                movie = snapshot.movieList[index];
                                return ChangeNotifierProvider.value(
                                  value: movie,
                                  child: ListItem(
                                    movie: movie,
                                  ),
                                );
                              }
                            },
                            itemCount: snapshot.movieList.length + 1,
                          ),
                        );
                }),
        ));
  }
}
