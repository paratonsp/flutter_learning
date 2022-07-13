// ignore_for_file: use_key_in_widget_constructors, prefer_const_literals_to_create_immutables, avoid_print, must_be_immutable, prefer_const_constructors

import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:http/http.dart' as http;

class News {
  const News(
    this.authorNews,
    this.contentNews,
    this.dateNews,
    this.imageUrlNews,
    this.titleNews,
  );
  final String authorNews;
  final String contentNews;
  final String dateNews;
  final String imageUrlNews;
  final String titleNews;
}

class NewsScreen extends StatefulWidget {
  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  List categoryNews = [
    'business',
    'sports',
    'world',
    'politics',
    'technology',
    'startup',
    'entertainment',
    'miscellaneous',
    'hatke',
    'science',
    'automobile'
  ];
  List<List<News>> listNews = [];

  getNews(String category, int index) async {
    final response = await http
        .get(Uri.parse("https://inshorts.deta.dev/news?category=$category"));

    List<News> temp = [];
    for (var data in jsonDecode(response.body)['data'] as List) {
      temp.add(
        News(
          data['author'],
          data['content'],
          data['date'],
          data['imageUrl'],
          data['title'],
        ),
      );
    }
    setState(() {
      listNews[index] = temp;
    });
  }

  @override
  void initState() {
    listNews = List.generate(categoryNews.length, (i) => []);
    for (var i = 0; i < categoryNews.length; i++) {
      getNews(categoryNews[i], i);
    }
    _tabController = TabController(length: categoryNews.length, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CupertinoNavigationBar(
        middle: Text("News"),
        leading: CupertinoNavigationBarBackButton(
          onPressed: (() {
            Navigator.pop(context);
          }),
        ),
      ),
      body: Padding(
          padding: EdgeInsets.only(top: 30, left: 30, right: 30, bottom: 0),
          child: NestedScrollView(
            headerSliverBuilder: (context, value) {
              return [
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            Jiffy(DateTime.now()).format("EEEE MMMM do"),
                            style: TextStyle(
                              fontSize: 12,
                            ),
                          ),
                          SizedBox(height: 7),
                          Text(
                            "Daily feed",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 15),
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: 150,
                            child: ListView.builder(
                              physics: BouncingScrollPhysics(),
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: 1,
                              itemBuilder: (BuildContext context, int index) {
                                return Row(
                                  children: [
                                    for (int i = 0;
                                        i < categoryNews.length;
                                        i++) ...[
                                      _sliderWidget(),
                                      SizedBox(width: 15),
                                    ],
                                  ],
                                );
                              },
                            ),
                          ),
                          SizedBox(height: 15),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(15.0),
                            child: SizedBox(
                              child: TabBar(
                                physics: BouncingScrollPhysics(),
                                isScrollable: true,
                                controller: _tabController,
                                overlayColor:
                                    MaterialStateProperty.all(Colors.white),
                                indicator: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15.0),
                                  color: Colors.blueAccent,
                                ),
                                labelColor: Colors.white,
                                unselectedLabelColor: Colors.black,
                                tabs: [
                                  for (int i = 0;
                                      i < categoryNews.length;
                                      i++) ...[
                                    SizedBox(
                                      height: 30,
                                      child: Tab(
                                        text: categoryNews[i]
                                            .toString()
                                            .toUpperCase(),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 15),
                        ],
                      ),
                    ],
                  ),
                ),
              ];
            },
            body: SizedBox(
              child: TabBarView(
                physics: BouncingScrollPhysics(),
                controller: _tabController,
                children: [
                  for (int i = 0; i < categoryNews.length; i++) ...[
                    ListNewsWidget(listNews[i]),
                  ]
                ],
              ),
            ),
          )),
    );
  }

  _sliderWidget() {
    return Container(
      width: 200,
      height: 150,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(15))),
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: Icon(
                    Icons.star,
                    size: 18,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: 15),
                Text(
                  "variable",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent),
                ),
              ],
            ),
            SizedBox(height: 15),
            Text(
              "zodiacDescription",
              maxLines: 5,
              style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                  overflow: TextOverflow.ellipsis),
            ),
          ],
        ),
      ),
    );
  }
}

class ListNewsWidget extends StatelessWidget {
  ListNewsWidget(this.listNews);
  List listNews = [];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: BouncingScrollPhysics(),
      shrinkWrap: true,
      itemCount: listNews.length,
      itemBuilder: (context, index) {
        News news = listNews[index];
        return Padding(
          padding: EdgeInsets.only(bottom: 15),
          child: InkWell(
            highlightColor: Colors.transparent,
            splashFactory: NoSplash.splashFactory,
            child: Container(
              padding: EdgeInsets.all(7),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7), color: Colors.white),
              child: Column(
                children: [
                  Row(
                    children: [
                      Hero(
                        tag: news.imageUrlNews,
                        child: SizedBox(
                          height: 70,
                          width: 70,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(7),
                            child: Image.network(
                              news.imageUrlNews,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 15),
                      Expanded(
                        child: SizedBox(
                          height: 70,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                news.dateNews,
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey,
                                ),
                              ),
                              Text(news.titleNews,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold)),
                              Text(
                                news.authorNews,
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 7),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.comment_outlined,
                                size: 16,
                              ),
                              SizedBox(width: 3.5),
                              Text(
                                Random().nextInt(100).toString(),
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          SizedBox(width: 7.5),
                          Row(
                            children: [
                              Icon(
                                Icons.bookmark_outline,
                                size: 16,
                              ),
                              SizedBox(width: 3.5),
                              Text(
                                "Save",
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Icon(
                        Icons.share_outlined,
                        size: 16,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => NewDetailNewsWidget(
                          news.authorNews,
                          news.contentNews,
                          news.dateNews,
                          news.imageUrlNews,
                          news.titleNews,
                        )),
              );
            },
          ),
        );
      },
    );
  }
}

class NewDetailNewsWidget extends StatelessWidget {
  NewDetailNewsWidget(
    this.authorNews,
    this.contentNews,
    this.dateNews,
    this.imageUrlNews,
    this.titleNews,
  );
  String authorNews = "";
  String contentNews = "";
  String dateNews = "";
  String imageUrlNews = "";
  String titleNews = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 10, 10, 10),
      body: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: MediaQuery.of(context).size.height / 1.5,
            backgroundColor: Color.fromARGB(255, 10, 10, 10),
            pinned: true,
            stretch: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: imageUrlNews,
                child: ShaderMask(
                  shaderCallback: (rect) {
                    return LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.black, Colors.transparent],
                    ).createShader(
                        Rect.fromLTRB(0, 0, rect.width, rect.height));
                  },
                  blendMode: BlendMode.dstIn,
                  child: Image.network(
                    imageUrlNews,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              stretchModes: [
                StretchMode.fadeTitle,
                StretchMode.zoomBackground,
              ],
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          left: 30, right: 30, top: 15, bottom: 0),
                      child: Text(
                        titleNews,
                        maxLines: 99,
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: 30, right: 30, top: 15, bottom: 0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Author: " + authorNews,
                              style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            Text(
                              dateNews,
                              style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ]),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: 30, right: 30, top: 30, bottom: 0),
                      child: Text(
                        contentNews,
                        maxLines: 999,
                        style: TextStyle(fontSize: 12, color: Colors.white),
                      ),
                    ),
                  ],
                );
              },
              childCount: 1,
            ),
          ),
        ],
      ),
    );
  }
}
