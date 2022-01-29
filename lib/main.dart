import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:memepedia/drawer.dart';
import 'package:memepedia/memelistview.dart';
import 'package:memepedia/searchdelegate.dart';
import 'package:memepedia/theme.dart';
import 'package:memescraper/memescraper.dart';

import 'loading.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  FirebaseAnalytics analytics = FirebaseAnalytics();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorObservers: [
        FirebaseAnalyticsObserver(analytics: analytics),
      ],
      debugShowCheckedModeBanner: false,
      title: 'Memepedia',
      theme: ThemeData(
        fontFamily: GoogleFonts.openSans().fontFamily,
        // primarySwatch: Color(0xFFF4EDED),
        primaryColor: AppTheme.DarkColor,
        canvasColor: AppTheme.DarkColor,
        primaryColorLight: AppTheme.BrightAccent,
        primaryColorDark: AppTheme.DarkAccent,
        scaffoldBackgroundColor: AppTheme.DarkColor,
        textTheme: TextTheme(
          subtitle1: TextStyle(color: AppTheme.BrightColor),
          subtitle2: TextStyle(color: AppTheme.BrightColor),
          bodyText1: TextStyle(color: AppTheme.BrightColor),
          bodyText2: TextStyle(color: AppTheme.BrightColor),
          headline1: TextStyle(color: AppTheme.BrightColor),
          headline2: TextStyle(color: AppTheme.BrightColor),
          headline3: TextStyle(color: AppTheme.BrightColor),
          headline4: TextStyle(color: AppTheme.BrightColor),
          headline5: TextStyle(color: AppTheme.BrightColor),
          headline6: TextStyle(color: AppTheme.BrightColor),
        ),
        primaryTextTheme: TextTheme(
          subtitle1: TextStyle(color: AppTheme.BrightColor),
          subtitle2: TextStyle(color: AppTheme.BrightColor),
          bodyText1: TextStyle(color: AppTheme.BrightColor),
          bodyText2: TextStyle(color: AppTheme.BrightColor),
          headline1: TextStyle(color: AppTheme.BrightColor),
          headline2: TextStyle(color: AppTheme.BrightColor),
          headline3: TextStyle(color: AppTheme.BrightColor),
          headline4: TextStyle(color: AppTheme.BrightColor),
          headline5: TextStyle(color: AppTheme.BrightColor),
          headline6: TextStyle(color: AppTheme.BrightColor),
        ),
        hintColor: AppTheme.BrightAccent,
        inputDecorationTheme: InputDecorationTheme(
          border: UnderlineInputBorder(
              borderSide: BorderSide(color: AppTheme.BrightAccent)),
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: AppTheme.BrightAccent)),
        ),
        iconTheme: IconThemeData(color: AppTheme.BrightColor),
      ),
      home: MyHomePage(
        title: 'Memepedia',
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;
  Type memeType = Type.confirmed;
  UnsortableType unsortableType;

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    if (widget.memeType != null) {
      return getSortableContainer();
    } else {
      return getUnsortableContainer();
    }
  }

  Container getSortableContainer() {
    return Container(
      color: AppTheme.DarkColor,
      child: DefaultTabController(
        length: 8,
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              widget.title,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            bottom: PreferredSize(
                child: TabBar(
                    isScrollable: true,
                    indicatorColor: AppTheme.BrightAccent,
                    unselectedLabelColor: Colors.white.withOpacity(0.3),
                    // indicatorColor: AppTheme.BrightColor,
                    tabs: [
                      Tab(
                        child: Text('newest'),
                      ),
                      Tab(
                        child: Text('oldest'),
                      ),
                      Tab(
                        child: Text('views'),
                      ),
                      Tab(
                        child: Text('chronological'),
                      ),
                      Tab(
                        child: Text('reverse_chronological'),
                      ),
                      Tab(
                        child: Text('comments'),
                      ),
                      Tab(
                        child: Text('images'),
                      ),
                      Tab(
                        child: Text('videos'),
                      )
                    ]),
                preferredSize: Size.fromHeight(30.0)),
            actions: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () => showSearch(
                      context: context, delegate: CustomSearchDelegate()),
                ),
              ),
            ],
          ),
          body: TabBarView(
            children: <Widget>[
              Container(
                color: AppTheme.DarkColor,
                child: Center(
                  child: FutureBuilder<MemeListView>(
                    future:
                        MemeListView.create(widget.memeType, SortedBy.newest),
                    builder: (BuildContext context,
                        AsyncSnapshot<MemeListView> snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                          return Center(
                            child: CustomLoading(),
                          );
                        default:
                          if (snapshot.hasError)
                            return Text(
                              'Error: ${snapshot.error}',
                              style: TextStyle(color: AppTheme.BrightColor),
                            );
                          else
                            return snapshot.data;
                      }
                    },
                  ),
                ),
              ),
              Container(
                color: AppTheme.DarkColor,
                child: Center(
                  child: FutureBuilder<MemeListView>(
                    future:
                        MemeListView.create(widget.memeType, SortedBy.oldest),
                    builder: (BuildContext context,
                        AsyncSnapshot<MemeListView> snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                          return Center(
                            child: CustomLoading(),
                          );
                        default:
                          if (snapshot.hasError)
                            return Text(
                              'Error: ${snapshot.error}',
                              style: TextStyle(color: AppTheme.BrightColor),
                            );
                          else
                            return snapshot.data;
                      }
                    },
                  ),
                ),
              ),
              Container(
                color: AppTheme.DarkColor,
                child: Center(
                  child: FutureBuilder<MemeListView>(
                    future:
                        MemeListView.create(widget.memeType, SortedBy.views),
                    builder: (BuildContext context,
                        AsyncSnapshot<MemeListView> snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                          return Center(
                            child: CustomLoading(),
                          );
                        default:
                          if (snapshot.hasError)
                            return Text(
                              'Error: ${snapshot.error}',
                              style: TextStyle(color: AppTheme.BrightColor),
                            );
                          else
                            return snapshot.data;
                      }
                    },
                  ),
                ),
              ),
              Container(
                color: AppTheme.DarkColor,
                child: Center(
                  child: FutureBuilder<MemeListView>(
                    future: MemeListView.create(
                        widget.memeType, SortedBy.chronological),
                    builder: (BuildContext context,
                        AsyncSnapshot<MemeListView> snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                          return Center(
                            child: CustomLoading(),
                          );
                        default:
                          if (snapshot.hasError)
                            return Text(
                              'Error: ${snapshot.error}',
                              style: TextStyle(color: AppTheme.BrightColor),
                            );
                          else
                            return snapshot.data;
                      }
                    },
                  ),
                ),
              ),
              Container(
                color: AppTheme.DarkColor,
                child: Center(
                  child: FutureBuilder<MemeListView>(
                    future: MemeListView.create(
                        widget.memeType, SortedBy.reverse_chronological),
                    builder: (BuildContext context,
                        AsyncSnapshot<MemeListView> snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                          return Center(
                            child: CustomLoading(),
                          );
                        default:
                          if (snapshot.hasError)
                            return Text(
                              'Error: ${snapshot.error}',
                              style: TextStyle(color: AppTheme.BrightColor),
                            );
                          else
                            return snapshot.data;
                      }
                    },
                  ),
                ),
              ),
              Container(
                color: AppTheme.DarkColor,
                child: Center(
                  child: FutureBuilder<MemeListView>(
                    future:
                        MemeListView.create(widget.memeType, SortedBy.comments),
                    builder: (BuildContext context,
                        AsyncSnapshot<MemeListView> snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                          return Center(
                            child: CustomLoading(),
                          );
                        default:
                          if (snapshot.hasError)
                            return Text(
                              'Error: ${snapshot.error}',
                              style: TextStyle(color: AppTheme.BrightColor),
                            );
                          else
                            return snapshot.data;
                      }
                    },
                  ),
                ),
              ),
              Container(
                color: AppTheme.DarkColor,
                child: Center(
                  child: FutureBuilder<MemeListView>(
                    future:
                        MemeListView.create(widget.memeType, SortedBy.images),
                    builder: (BuildContext context,
                        AsyncSnapshot<MemeListView> snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                          return Center(
                            child: CustomLoading(),
                          );
                        default:
                          if (snapshot.hasError)
                            return Text(
                              'Error: ${snapshot.error}',
                              style: TextStyle(color: AppTheme.BrightColor),
                            );
                          else
                            return snapshot.data;
                      }
                    },
                  ),
                ),
              ),
              Container(
                color: AppTheme.DarkColor,
                child: Center(
                  child: FutureBuilder<MemeListView>(
                    future:
                        MemeListView.create(widget.memeType, SortedBy.videos),
                    builder: (BuildContext context,
                        AsyncSnapshot<MemeListView> snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                          return Center(
                            child: CustomLoading(),
                          );
                        default:
                          if (snapshot.hasError)
                            return Text(
                              'Error: ${snapshot.error}',
                              style: TextStyle(color: AppTheme.BrightColor),
                            );
                          else
                            return snapshot.data;
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
          drawer: NavDrawer(this),
        ),
      ),
    );
  }

  Widget getUnsortableContainer() {
    return Container(
      color: AppTheme.DarkColor,
      child: DefaultTabController(
        length: 8,
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(widget.title),
            actions: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () => showSearch(
                      context: context, delegate: CustomSearchDelegate()),
                ),
              ),
            ],
          ),
          body: Container(
            color: AppTheme.DarkColor,
            child: Center(
              child: FutureBuilder<MemeListView>(
                future: MemeListView.createUnsortable(widget.unsortableType),
                builder: (BuildContext context,
                    AsyncSnapshot<MemeListView> snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return Center(
                        child: CustomLoading(),
                      );
                    default:
                      if (snapshot.hasError)
                        return Text(
                          'Error: ${snapshot.error}',
                          style: TextStyle(color: AppTheme.BrightColor),
                        );
                      else
                        return snapshot.data;
                  }
                },
              ),
            ),
          ),
          drawer: NavDrawer(this),
        ),
      ),
    );
  }

  void refresh() {
    setState(() {});
  }
}
