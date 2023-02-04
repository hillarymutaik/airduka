/// Author: Hillary Mutai
/// profile: https://github.com/hillarymutaik
import 'dart:convert';

import 'package:airduka/model/data_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../widgets/constants.dart';

class AirdukaScreen extends StatefulWidget {
  AirdukaScreen({Key? key}) : super(key: key);

  @override
  _AirdukaScreenState createState() => _AirdukaScreenState();
}

enum ViewType { grid, list }

class _AirdukaScreenState extends State<AirdukaScreen> {
  int _crossAxisCount = 2;

  double _aspectRatio = 1.5;

  ViewType _viewType = ViewType.grid;

  late Future<List<Data>> seasons;

  AnimationController? animationController;
  final ScrollController _scrollController = ScrollController();

  // DateTime startDate = DateTime.now();
  // DateTime endDate = DateTime.now().add(const Duration(days: 5));

  @override
  void initState() {
    super.initState();
    seasons = getData();
  }

  //function to retrieve data from the api
  Future<List<Data>> getData() async {
    final http.Response response =
        await http.get(Uri.parse("https://api.airduka.com/ad-interview/"));
    if (response.statusCode == 200) {
      final data = response.body;
      var jsonData = jsonDecode(data)['data']['data'];
      var results = jsonData.map<Data>((map) => Data.fromJson(map)).toList();
      print('Data here :${results}');
      return results;
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AirdukaTheme.buildLightTheme(),
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            InkWell(
              splashColor: Colors.transparent,
              focusColor: Colors.transparent,
              highlightColor: Colors.transparent,
              hoverColor: Colors.transparent,
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
              },
              child: Column(
                children: <Widget>[
                  appBar(),
                  Expanded(
                    child: NestedScrollView(
                        controller: _scrollController,
                        headerSliverBuilder:
                            (BuildContext context, bool innerBoxIsScrolled) {
                          return <Widget>[];
                        },
                        body: Container(
                          margin: const EdgeInsets.all(10),
                          child: FutureBuilder<List<Data>>(
                            future: seasons,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return GridView.builder(
                                    itemCount: snapshot.data?.length,
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: _crossAxisCount,
                                      childAspectRatio: _aspectRatio,
                                    ),
                                    itemBuilder: (context, index) {
                                      return dataView(
                                          viewData: snapshot.data![index]);
                                    });
                              } else if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              }
                              return Center(
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                    SizedBox(
                                      width: 30,
                                      height: 30,
                                      child: CircularProgressIndicator(
                                        color: Colors.deepOrange.shade900,
                                      ),
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.only(top: 16),
                                      child: Text(
                                        'Loading...',
                                      ),
                                    ),
                                  ]));
                            },
                          ),
                        )),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget appBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        boxShadow: <BoxShadow>[
          BoxShadow(
              color: Colors.white70.withOpacity(0.2),
              offset: const Offset(0, 2),
              blurRadius: 8.0),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top, left: 8, right: 8),
        child: Row(
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              width: AppBar().preferredSize.height + 40,
              height: AppBar().preferredSize.height,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    'airduka',
                    style: TextStyle(
                        color: Colors.blue.shade900,
                        fontFamily: 'Airduka',
                        fontSize: 15,
                        fontWeight: FontWeight.normal),
                  ),
                  Text(
                    '.com',
                    style: TextStyle(
                        color: Colors.deepOrange.shade300,
                        fontFamily: 'Airduka',
                        fontSize: 15,
                        fontWeight: FontWeight.normal),
                  ),
                ],
              ),
            ),
            Expanded(
                child: Center(
              child: Text(
                'Toggler',
                style: TextStyle(
                    color: Colors.deepOrange.shade300,
                    fontFamily: 'Airduka',
                    fontWeight: FontWeight.w600,
                    fontSize: 15),
              ),
            )),
            Container(
              width: AppBar().preferredSize.height + 40,
              height: AppBar().preferredSize.height,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  IconButton(
                    color: Colors.deepOrange.shade300,
                    icon: Icon(_viewType == ViewType.list
                        ? Icons.grid_on
                        : Icons.view_list),
                    onPressed: () {
                      if (_viewType == ViewType.list) {
                        _crossAxisCount = 2;
                        _aspectRatio = 1.5;
                        _viewType = ViewType.grid;
                      } else {
                        _crossAxisCount = 1;
                        _aspectRatio = 1.2;
                        _viewType = ViewType.list;
                      }
                      setState(() {});
                    },
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  GridTile dataView({required Data viewData}) {
    final size = MediaQuery.of(context).size;
    return GridTile(
        child: (_viewType == ViewType.list)
            ? Container(
                padding: const EdgeInsets.only(
                    left: 24, right: 24, top: 8, bottom: 10),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(16.0)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Colors.white.withOpacity(0.2),
                      offset: const Offset(2, 2),
                      blurRadius: 6.0,
                    ),
                    BoxShadow(
                      color: Colors.white70.withOpacity(0.9),
                      offset: const Offset(4, 4),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                            child: ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(4.0)),
                          child: Stack(
                            children: <Widget>[
                              Column(
                                children: <Widget>[
                                  AspectRatio(
                                    aspectRatio: 1.5,
                                    child: Image.network(
                                      viewData.path,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Container(
                                    color: AirdukaTheme.buildLightTheme()
                                        .backgroundColor,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 16, top: 8, bottom: 6),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  viewData.name,
                                                  textAlign: TextAlign.left,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize:
                                                        size.width * 0.023,
                                                  ),
                                                ),
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: <Widget>[
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 4),
                                                      child: Text(
                                                        viewData.seller,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                            fontSize:
                                                                size.width *
                                                                    0.025,
                                                            color: Colors
                                                                .orange.shade900
                                                                .withOpacity(
                                                                    0.8)),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 4),
                                                  child: Row(
                                                    children: <Widget>[
                                                      Text(
                                                        'Kshs. ${viewData.price}',
                                                        textAlign:
                                                            TextAlign.left,
                                                        style: TextStyle(
                                                          color: Colors.blue,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize:
                                                              size.width * 0.02,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )),
                      ],
                    )))
            : Container(
                padding: const EdgeInsets.all(5.0),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Colors.white.withOpacity(0.2),
                      offset: const Offset(2, 2),
                      blurRadius: 6.0,
                    ),
                  ],
                ),
                child: Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Expanded(
                    child:ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(4.0)),
                          child: Stack(
                            children: <Widget>[
                              Column(
                                children: <Widget>[
                                  AspectRatio(
                                    aspectRatio: 2.4,
                                    child: Image.network(
                                      viewData.path,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Container(
                                    color: AirdukaTheme.buildLightTheme()
                                        .backgroundColor,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 10, top: 4, bottom: 6),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  viewData.name,
                                                  textAlign: TextAlign.left,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize:
                                                        size.width * 0.013,
                                                  ),
                                                ),
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: <Widget>[
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 4),
                                                      child: Text(
                                                        viewData.seller,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                            fontSize:
                                                                size.width *
                                                                    0.02,
                                                            color: Colors
                                                                .orange.shade900
                                                                .withOpacity(
                                                                    0.8)),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 4),
                                                  child: Row(
                                                    children: <Widget>[
                                                      Text(
                                                        'Kshs. ${viewData.price}',
                                                        textAlign:
                                                            TextAlign.left,
                                                        style: TextStyle(
                                                          color: Colors.blue,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize:
                                                              size.width * 0.02,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )),
                      ],
                    ))));
  }
}
