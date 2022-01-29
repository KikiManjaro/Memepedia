import 'package:flutter/material.dart';
import 'package:memepedia/loading.dart';
import 'package:memepedia/memelistview.dart';
import 'package:memepedia/theme.dart';

class CustomSearchDelegate extends SearchDelegate {
  CustomSearchDelegate({this.contextPage});

  BuildContext contextPage;
  final suggestions1 = [];

  @override
  String get searchFieldLabel => "Enter a meme name";

  @override
  ThemeData appBarTheme(BuildContext context) {
    //TODO set themedata
    assert(context != null);
    final ThemeData theme = Theme.of(context);
    assert(theme != null);
    return theme;
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = "";
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) { //TODO: show something if result is empty
    return FutureBuilder<MemeListView>(
      future: MemeListView.createSearching(query),
      builder: (BuildContext context, AsyncSnapshot<MemeListView> snapshot) {
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
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) { //TODO: put something in background
    final suggestions = query.isEmpty ? suggestions1 : [];
    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (content, index) => ListTile(
          leading: Icon(Icons.arrow_left), title: Text(suggestions[index])),
    );
  }
}
