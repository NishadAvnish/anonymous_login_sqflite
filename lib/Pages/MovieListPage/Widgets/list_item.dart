import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:task/Constants/const_color.dart';
import 'package:task/Constants/const_value.dart';
import 'package:task/Helpers/dialog_helper.dart';
import 'package:task/Models/movie_model.dart';
import 'package:task/Providers/database_provider.dart';

class ListItem extends StatelessWidget {
  final MovieModel movie;
  const ListItem({Key key, this.movie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      child: Card(
          shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.all(Radius.circular(ConstValue.BORDER_RADIUS))),
          elevation: 2,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: ConstValue.LEFT_PADDING),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: ConstValue.SMALL_PADDING),
                        width: MediaQuery.of(context).size.width * 0.2,
                        decoration: BoxDecoration(
                            border: Border.all(color: ConstColor.BORDER_COLOR),
                            borderRadius:
                                BorderRadius.circular(ConstValue.BORDER_RADIUS),
                            image: DecorationImage(
                                image: NetworkImage(movie.poster),
                                fit: BoxFit.fill)),
                      ),
                      SizedBox(
                        width: ConstValue.HORIZONTAL_SIZE_BETWEEN_ELE,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Flexible(
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.40,
                              child: Text(movie.movieName,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline6
                                      .copyWith(fontWeight: FontWeight.bold)),
                            ),
                          ),
                          Text(
                            movie.director,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodyText1,
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Flexible(
                      child: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          DialogHelper.showConfirmationDialog(
                              context: context, movieId: movie.movieId);
                        },
                      ),
                    ),
                    Flexible(
                      child: IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          Navigator.of(context)
                              .pushNamed("/editMovie", arguments: movie);
                        },
                      ),
                    ),
                  ],
                )
              ],
            ),
          )),
    );
  }
}
