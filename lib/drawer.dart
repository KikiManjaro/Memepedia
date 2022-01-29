import 'package:flutter/material.dart';
import 'package:memepedia/main.dart';
import 'package:memepedia/theme.dart';
import 'package:memescraper/memescraper.dart';

class NavDrawer extends StatelessWidget {
  MyHomePageState myHomePageState;

  NavDrawer(this.myHomePageState);

  @override
  Widget build(BuildContext context) {
    //TODO: set lighter color on selected one
    return Theme(
      data: Theme.of(context),
      //     .copyWith(
      //   canvasColor: AppTheme.DarkColor,
      //   iconTheme: IconThemeData(color: AppTheme.BrightColor),
      //   textTheme: TextTheme(
      //     headline2: TextStyle(
      //       color: Color(0xFFF4EDED),
      //     ),
      //   ),
      // ),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.50,
        child: Drawer(
          child: SafeArea(
            bottom: false,
            child: Container(
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  ListTile(
                    enabled: false,
                    title: Text(
                      'Categories',
                      style: TextStyle(
                          color: AppTheme.BrightColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    onTap: () => {},
                  ),
                  ListTile(
                    enabled: false,
                    title: Divider(
                        color: AppTheme.BrightColor, thickness: 2),
                    onTap: () => {},
                  ),
                  ListTile(
                    leading: Icon(Icons.verified_user,
                        color: myHomePageState.widget.memeType == Type.confirmed
                            ? AppTheme.BrightAccent
                            : AppTheme.BrightColor),
                    title: Text(
                      'Confirmed',
                      style: TextStyle(
                          color: myHomePageState.widget.memeType == Type.confirmed
                              ? AppTheme.BrightAccent
                              : AppTheme.BrightColor),
                    ),
                    onTap: () => {
                      myHomePageState.widget.unsortableType = null,
                      myHomePageState.widget.memeType = Type.confirmed,
                      myHomePageState.refresh(),
                      Navigator.of(context).pop()
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.add_box,
                        color: myHomePageState.widget.memeType == Type.submissions
                            ? AppTheme.BrightAccent
                            : AppTheme.BrightColor),
                    title: Text('Submissions',
                      style: TextStyle(
                          color: myHomePageState.widget.memeType == Type.submissions
                              ? AppTheme.BrightAccent
                              : AppTheme.BrightColor),),
                    onTap: () => {
                      myHomePageState.widget.unsortableType = null,
                      myHomePageState.widget.memeType = Type.submissions,
                      myHomePageState.refresh(),
                      Navigator.of(context).pop()
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.delete_forever,
                        color: myHomePageState.widget.memeType == Type.deadpool
                            ? AppTheme.BrightAccent
                            : AppTheme.BrightColor),
                    title: Text('Deadpool',
                      style: TextStyle(
                          color: myHomePageState.widget.memeType == Type.deadpool
                              ? AppTheme.BrightAccent
                              : AppTheme.BrightColor),),
                    onTap: () => {
                      myHomePageState.widget.unsortableType = null,
                      myHomePageState.widget.memeType = Type.deadpool,
                      myHomePageState.refresh(),
                      Navigator.of(context).pop()
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.all_inbox,
                        color: myHomePageState.widget.memeType == Type.all
                            ? AppTheme.BrightAccent
                            : AppTheme.BrightColor),
                    title: Text('All',
                      style: TextStyle(
                          color: myHomePageState.widget.memeType == Type.all
                              ? AppTheme.BrightAccent
                              : AppTheme.BrightColor),),
                    onTap: () => {
                      myHomePageState.widget.unsortableType = null,
                      myHomePageState.widget.memeType = Type.all,
                      myHomePageState.refresh(),
                      Navigator.of(context).pop()
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.search,
                        color: myHomePageState.widget.unsortableType == UnsortableType.researching
                            ? AppTheme.BrightAccent
                            : AppTheme.BrightColor),
                    title: Text('Researching',
                      style: TextStyle(
                          color: myHomePageState.widget.unsortableType == UnsortableType.researching
                              ? AppTheme.BrightAccent
                              : AppTheme.BrightColor),),
                    onTap: () => {
                      myHomePageState.widget.memeType = null,
                      myHomePageState.widget.unsortableType =
                          UnsortableType.researching,
                      myHomePageState.refresh(),
                      Navigator.of(context).pop()
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.new_releases,
                        color: myHomePageState.widget.unsortableType == UnsortableType.newsworthy
                            ? AppTheme.BrightAccent
                            : AppTheme.BrightColor),
                    title: Text('Newsworthy',
                      style: TextStyle(
                          color: myHomePageState.widget.unsortableType == UnsortableType.newsworthy
                              ? AppTheme.BrightAccent
                              : AppTheme.BrightColor),),
                    onTap: () => {
                      myHomePageState.widget.memeType = null,
                      myHomePageState.widget.unsortableType =
                          UnsortableType.newsworthy,
                      myHomePageState.refresh(),
                      Navigator.of(context).pop()
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.vertical_align_top,
                        color: myHomePageState.widget.unsortableType == UnsortableType.popular
                            ? AppTheme.BrightAccent
                            : AppTheme.BrightColor),
                    title: Text('Popular',
                      style: TextStyle(
                          color: myHomePageState.widget.unsortableType == UnsortableType.popular
                              ? AppTheme.BrightAccent
                              : AppTheme.BrightColor),),
                    onTap: () => {
                      myHomePageState.widget.memeType = null,
                      myHomePageState.widget.unsortableType =
                          UnsortableType.popular,
                      myHomePageState.refresh(),
                      Navigator.of(context).pop()
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
