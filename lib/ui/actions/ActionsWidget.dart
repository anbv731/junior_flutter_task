import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:junior_test/blocs/actions/ActionsItemQueryBloc.dart';
import 'package:junior_test/blocs/actions/ActionsQueryBloc.dart';
import 'package:junior_test/blocs/base/bloc_provider.dart';
import 'package:junior_test/model/RootResponse.dart';
import 'package:junior_test/model/actions/Promo.dart';
import 'package:junior_test/model/actions/PromoItem.dart';
import 'package:junior_test/resources/api/RootType.dart';
import 'package:junior_test/tools/MyColors.dart';
import 'package:junior_test/tools/MyDimens.dart';
import 'package:junior_test/tools/Tools.dart';
import 'package:junior_test/ui/actions/item/ActionsItemArguments.dart';
import 'package:junior_test/ui/actions/item/ActionsItemWidget.dart';
import 'package:junior_test/ui/base/NewBasePageState.dart';
import 'package:junior_test/ui/views/appbar/flexible/FlexAppBar.dart';

class ActionsWidget extends StatefulWidget {
  static String TAG = "ActionsWidget";

  @override
  _ActionsWidgetState createState() => _ActionsWidgetState();
}

class _ActionsWidgetState extends NewBasePageState<ActionsWidget> {
  ActionsQueryBloc bloc;

  _ActionsWidgetState() {
    bloc = ActionsQueryBloc();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {'/ActionsItemWidget': (context) => ActionsItemWidget()},
      home: Scaffold(
        body: BlocProvider<ActionsQueryBloc>(
            bloc: bloc, child: getBaseQueryStream(bloc.shopContentStream)),
      ),
    );
  }

  @override
  Widget onSuccess(RootTypes event, RootResponse response) {
    var actionsInfo = response.serverResponse.body.promo;
    return StaticAppBar('Акции', _actionsList(actionsInfo));
  }

  void runOnWidgetInit() {
    bloc.loadActionsContent();
  }

  Widget _actionsList(Promos actionInfo) {
    return Container(
      margin: EdgeInsets.only(left: 12, right: 12),
      child: StaggeredGridView.countBuilder(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 12,
          itemCount: actionInfo.list.length,
          itemBuilder: (context, index) {
            return Container(
              decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/ActionsItemWidget',
                      arguments:
                          ActionsItemArguments(actionInfo.list[index].id));
                  print(index);
                },
                child: CachedNetworkImage(
                  imageUrl: Tools.getImagePath(actionInfo.list[index].imgFull),
                  placeholder: (context, url) =>
                      Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) =>
                      Image(image: AssetImage('mall_background.png')),
                  imageBuilder: (context, imageProvider) => Stack(children: [
                    Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        Expanded(
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              actionInfo.list[index].name,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: "YesEva",
                                  color: MyColors.appbar_text,
                                  fontSize: MyDimens.titleNormal,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text(
                              actionInfo.list[index].shop,
                              style: TextStyle(
                                  fontFamily: "YesEva",
                                  color: MyColors.appbar_text,
                                  fontSize: MyDimens.subtitleBig,
                                  fontWeight: FontWeight.w300),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ]),
                ),
              ),
            );
          },
          staggeredTileBuilder: (index) {
            return StaggeredTile.count(1, index.isEven ? 1 : 2);
          }),
    );
  }
}
