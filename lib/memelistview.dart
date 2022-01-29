import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:memepedia/theme.dart';
import 'package:memescraper/memescraper.dart';

import 'memeinfo.dart';

class MemeListView extends StatefulWidget {
  List<MiniMeme> miniMemes = [];

  SortedBy sortedBy;

  UnsortableType unsortableType;

  Type memeType;

  int page = 1;

  var query;

  MemeListView._create(this.memeType, this.sortedBy);

  MemeListView._createUnsortable(this.unsortableType);

  MemeListView._createSearching(this.query);

  static Future<MemeListView> create(Type memeType, SortedBy sortedBy) async {
    MemeListView memeListView = MemeListView._create(memeType, sortedBy);
    memeListView.miniMemes +=
        await MemeScraper.listMemes(type: memeType, sortedBy: sortedBy);
    return memeListView;
  }

  static Future<MemeListView> createUnsortable(
      UnsortableType unsortableType) async {
    MemeListView memeListView = MemeListView._createUnsortable(unsortableType);
    memeListView.miniMemes +=
        await MemeScraper.listMemesWithUnsortedType(unsortableType);
    return memeListView;
  }

  static Future<MemeListView> createSearching(String query) async {
    MemeListView memeListView = MemeListView._createSearching(query);
    memeListView.miniMemes += await MemeScraper.searchMemeName(query);
    return memeListView;
  }

  @override
  _MemeListViewState createState() => _MemeListViewState();
}

class _MemeListViewState extends State<MemeListView> {
  var addIndex = 5;
  var addStep = 5;
  var ads = HashMap();
  var loaded = HashMap();

  // var isAdLoaded = false;

  @override
  void initState() {
    super.initState();
    loadMoreAd();
  }

  Container getAd(int i) {
    loadMoreAd();
    var currentAd = ads[i];
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: AdWidget(ad: currentAd),
      width: currentAd.size.width.toDouble(),
      height: currentAd.size.height.toDouble(),
      alignment: Alignment.center,
    );
  }

  void loadMoreAd() {
    var _ad = BannerAd(
      adUnitId: 'ca-app-pub-3940256099942544/6300978111', //debug
      size: AdSize.banner,
      request: AdRequest(keywords: ["meme", "geek", "web"]),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            for (var i = 0; i < addIndex; i += addStep) {
              var adInList = ads[i];
              if (ad != null && ad.hashCode == adInList.hashCode) {
                loaded.update(i, (dynamic val) => true);
              }
            }
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          print('Ad load failed (code=${error.code} message=${error.message})');
        },
      ),
    );
    loaded.putIfAbsent(addIndex, () => false);
    _ad.load();
    ads.putIfAbsent(addIndex, () => _ad);
    addIndex += addStep;
  }

  void dispose() {
    for (var ad in ads.values) {
      ad.dispose();
    }
    super.dispose();
  }

  //TODO: essayer d'afficher 2 ou plusieurs meme par row et de le rendre dynamique (chngmt orientation)
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context),
      child: ListView.builder(
          //use RecyclerView instead
          padding: const EdgeInsets.only(top: 8),
          itemCount: this.widget.miniMemes.length,
          itemBuilder: (BuildContext context, int index) {
            if (index == this.widget.miniMemes.length - 4) {
              loadMore();
            }
            return GestureDetector(
              child: Column(
                children: [
                  if (index != 0 &&
                      index % addStep == 0 &&
                      loaded[index] == true)
                    getAd(index),
                  Container(
                    margin: EdgeInsets.only(bottom: 16),
                    color: Colors.transparent,
                    child: Center(
                      child: Card(
                        color: Colors.transparent,
                        elevation: 6,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Stack(
                          alignment: AlignmentDirectional.bottomCenter,
                          children: [
                            Hero(
                              tag: this.widget.miniMemes[index].name,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(18),
                                child: Image.network(
                                  this.widget.miniMemes[index].image,
                                  scale: 0.80,
                                ),
                              ),
                            ),
                            Container(
                              constraints: BoxConstraints(maxWidth: 235),
                              //TODO: find a less static way to do it
                              child: Padding(
                                padding: EdgeInsets.only(bottom: 8),
                                child: Container(
                                  padding: EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                      border: Border.all(),
                                      color: AppTheme.DarkColor,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  // child: Flexible(
                                  child: Text(
                                    this.widget.miniMemes[index].beautifiedName,
                                    style: TextStyle(
                                      color: AppTheme.BrightColor,
                                    ),
                                  ),
                                  // ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              onTap: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        MemeInfo(this.widget.miniMemes[index]),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      return child;
                    },
                  ),
                );
              },
            );
          }),
    );
  }

  loadMore() async {
    this.widget.page++;
    if (this.widget.unsortableType != null) {
      this.widget.miniMemes += await MemeScraper.listMemesWithUnsortedType(
          this.widget.unsortableType,
          page: this.widget.page);
    } else if (this.widget.memeType != null) {
      this.widget.miniMemes += await MemeScraper.listMemes(
          type: this.widget.memeType,
          sortedBy: this.widget.sortedBy,
          page: this.widget.page);
    } else {
      this.widget.miniMemes += await MemeScraper.searchMemeName(
          this.widget.query,
          page: this.widget.page);
    }
    setState(() {});
  }
}
