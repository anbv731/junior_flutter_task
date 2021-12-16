// ignore: file_names
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:junior_test/ui/actions/item/ActionsItemArguments.dart';
import 'package:junior_test/ui/actions/item/ActionsItemWidget.dart';
import 'package:junior_test/ui/base/NewBasePageState.dart';

import 'item/ActionsWidgetX.dart';

class ActionsWidget extends StatelessWidget {

  Widget build(BuildContext context) {
    return MaterialApp(
        routes: {
          '/ActionsItemWidget': (context) => ActionsItemWidget(),
          '/ActionsWidget': (context) => ActionsWidgetX(),
        },
        home: Builder(
          builder: (context)=>
          Scaffold(
              body: Center(
                  child: GestureDetector(
                      onTap: () {

                        Navigator.of(context).pushNamed( '/ActionsWidget',
                            );
                      },
                      child: Text("Do me")))),
        ));
  }
}
