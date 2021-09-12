import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task/Constants/const_color.dart';
import 'package:task/Constants/const_value.dart';
import 'package:task/Providers/database_provider.dart';
import 'dart:io' show Platform;

class DialogHelper {
  DialogHelper._();

  static Widget showLoading({Color color}) {
    return Platform.isIOS
        ? CupertinoActivityIndicator()
        : CircularProgressIndicator(
            backgroundColor: color,
          );
  }

  static showConfirmationDialog({BuildContext context, int movieId}) {
    // flutter defined function
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Text("Are you Sure?"),
          content: Text(
              "This operation cannot be undone. Please make sure you have exported the data."),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            MaterialButton(
              child: Text("Yes"),
              onPressed: () async {
                await Provider.of<DatabaseHelperProvider>(context,
                        listen: false)
                    .deleteFromDatabase(movieId: movieId);

                Navigator.of(context).pop();
              },
            ),
            SizedBox(
              width: ConstValue.VERTICAL_SIZE_BETWEEN_ELE,
            ),
            MaterialButton(
              child: Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
