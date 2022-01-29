import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:memepedia/loading.dart';
import 'package:memepedia/theme.dart';
import 'package:memescraper/memescraper.dart';
import 'package:memescraper/src/entities/Meme.dart';
import 'package:string_validator/string_validator.dart';
import 'package:url_launcher/url_launcher.dart';

class MemeInfo extends StatelessWidget {
  Future<Meme> meme;
  MiniMeme miniMeme;

  MemeInfo(this.miniMeme) : this.meme = MemeScraper.miniMemeToMeme(miniMeme);

  @override
  Widget build(BuildContext context) {
    //TODO:if all at null, refresh + set background in black and text in white
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
      child: Scaffold(
        backgroundColor: AppTheme.DarkColor,
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Memepedia',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backwardsCompatibility: true,
        ),
        body: Center(
          child: Padding(
            padding: EdgeInsets.only(left: 14, right: 14),
            child: ListView(
              children: [
                Container(
                  // decoration: BoxDecoration(
                  //   image: DecorationImage(
                  //     image: NetworkImage(miniMeme.image),
                  //     fit: BoxFit.cover,
                  //   ),
                  // ),
                  child: Center(
                    child: Hero(
                      tag: miniMeme.name,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: Image.network(
                          miniMeme.image,
                          // scale: 0.80,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                if (miniMeme.beautifiedName != null) ...[
                  Center(
                    child: Text(
                      miniMeme.beautifiedName.toString(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                ],
                buildMemeInfosFutureBuilder(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  FutureBuilder<Meme> buildMemeInfosFutureBuilder() {
    return FutureBuilder(
      future: meme,
      builder: (BuildContext context, AsyncSnapshot<Meme> snapshot) {
        var data = snapshot.data;
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Center(child: CustomLoading());
          default:
            if (snapshot.hasError ||
                snapshot.data == null ||
                (snapshot.data.link == '' && snapshot.data.name == '') ||
                (snapshot.data.link == null && snapshot.data.name == null ||
                    (snapshot.data.link == 'null' &&
                        snapshot.data.name == 'null')))
              return Center(
                  child: Text(
                      'Error: ${snapshot.error}')); //TODO show an error page
            else
              return Column(
                //TODO: for each check if string == null ? not display : display
                // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  if (data.type != null) ...[
                    Center(child: getTypeTags(data.type.toString())),
                    SizedBox(height: 10),
                  ],
                  Center(
                    child: Padding(
                      padding: EdgeInsets.only(left: 4, right: 4),
                      child: Wrap(
                        direction: Axis.horizontal,
                        alignment: WrapAlignment.center,
                        children: [
                          if (data.year != null)
                            getFlex(Icon(Icons.date_range_rounded),
                                Text(data.year.toString())),
                          if (data.status != null)
                            getFlex(Icon(Icons.article_rounded),
                                Text(data.status.toString())),
                          if (data.origin != null)
                            if (isURL(data.origin.toString()))
                              getFlex(
                                Icon(Icons.system_update_alt_rounded),
                                InkWell(
                                  onTap: () => launch(data.origin.toString()),
                                  child: Text(
                                    data.origin.toString(),
                                    style: TextStyle(
                                        color: AppTheme.BrightAccent),
                                  ),
                                ),
                              )
                            else
                              getFlex(
                                  Icon(Icons.system_update_alt_rounded),
                                  Text(data.origin.toString())),
                          if (data.link != null)
                            getFlex(
                                Icon(Icons.link_rounded),
                                InkWell(
                                    onTap: () => launch(data.link.toString()),
                                    child: Text(
                                      data.link.toString(),
                                      style: TextStyle(
                                          color: AppTheme.BrightAccent),
                                    ))),
                        ],
                      ),
                    ),
                  ),
                  ...getMemeInfos(data),
                ],
              );
        }
      },
    );
  }

  List<Widget> getMemeInfos(Meme meme) {
    var list = <Widget>[];
    for (var entry in meme.infos.entries) {
      if (entry.value != '') {
        list.add(SizedBox(height: 10));
        list.add(
          Center(
            child: Padding(
              padding: EdgeInsets.only(left: 14, right: 14),
              child: Text(
                entry.key,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        );
        list.add(SizedBox(height: 4));
        list.add(Center(
          child: Padding(
              padding: EdgeInsets.only(left: 14, right: 14),
              child: Text(
                entry.value,
                textAlign: TextAlign.justify,
              )),
        ));
      }
    }
    return list;
  }

  Wrap getTypeTags(String types) {
    return Wrap(
        direction: Axis.horizontal,
        alignment: WrapAlignment.center,
        // runSpacing: 6,
        children: types
            .split(",")
            .map((item) => Container(
                margin: EdgeInsets.all(6),
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                    border: Border.all(),
                    color: AppTheme.BrightAccent,
                    borderRadius: BorderRadius.all(Radius.circular(18))),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.label_important_outline),
                    Text(item),
                  ],
                )))
            .toList());
  }

  Container getFlex(Widget w1, Widget w2) {
    return Container(
      margin: EdgeInsets.all(6),
      padding: EdgeInsets.all(6),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [w1, w2],
      ),
    );
  }
}
