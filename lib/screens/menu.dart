// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_element, avoid_print

import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:pesoros_app/screens/calendar.dart';
import 'package:pesoros_app/screens/dictionary.dart';
import 'package:pesoros_app/screens/financial.dart';
import 'package:pesoros_app/screens/health.dart';
import 'package:pesoros_app/screens/library.dart';
import 'package:pesoros_app/screens/music.dart';
import 'package:pesoros_app/variables.dart' as variable;
import 'package:http/http.dart' as http;

class MenuScreen extends StatefulWidget {
  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  bool shimmerLoad = true;

  String zodiacDescription;
  String zodiacCompatibility;
  String zodiacMood;
  String zodiacColor;
  String zodiacNumber;

  Color randomColor =
      Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0);

  getZodiac() async {
    String url = "https://aztro.sameerkumar.website?sign=" + variable.zodiac;
    var uri = Uri.parse(url);

    var response = await http.post(uri);
    setState(() {
      zodiacDescription = jsonDecode(response.body)["description"];
      zodiacCompatibility = jsonDecode(response.body)["compatibility"];
      zodiacMood = jsonDecode(response.body)["mood"];
      zodiacColor = jsonDecode(response.body)["color"];
      zodiacNumber = jsonDecode(response.body)["lucky_number"];
      shimmerLoad = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getZodiac();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              _header(context),
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
                        SizedBox(width: 30),
                        _sliderWidget(
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 30,
                                    height: 30,
                                    decoration: BoxDecoration(
                                        color: Colors.blueAccent,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20))),
                                    child: Icon(
                                      Icons.star,
                                      size: 18,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(width: 15),
                                  Text(
                                    variable.zodiac,
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blueAccent),
                                  ),
                                ],
                              ),
                              SizedBox(height: 15),
                              Text(
                                zodiacDescription ?? "",
                                maxLines: 5,
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                    overflow: TextOverflow.ellipsis),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 15),
                        _sliderWidget(
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 30,
                                    height: 30,
                                    decoration: BoxDecoration(
                                        color: Colors.blueAccent,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20))),
                                    child: Icon(
                                      Icons.favorite,
                                      size: 18,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(width: 15),
                                  Text(
                                    "Compatibility",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blueAccent),
                                  ),
                                ],
                              ),
                              SizedBox(height: 30),
                              Center(
                                child: Text(
                                  zodiacCompatibility ?? "",
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 26,
                                      fontWeight: FontWeight.bold),
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(width: 15),
                        Container(
                          width: 200,
                          height: 150,
                          decoration: BoxDecoration(
                              color: Colors.blueAccent,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15))),
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
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20))),
                                      child: Icon(
                                        Icons.mood,
                                        size: 18,
                                        color: Colors.blueAccent,
                                      ),
                                    ),
                                    SizedBox(width: 15),
                                    Text(
                                      "Color",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 30),
                                Center(
                                  child: Text(
                                    zodiacColor ?? "",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 26,
                                        fontWeight: FontWeight.bold),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: 15),
                        _sliderWidget(
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 30,
                                    height: 30,
                                    decoration: BoxDecoration(
                                        color: Colors.blueAccent,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20))),
                                    child: Icon(
                                      Icons.mood,
                                      size: 18,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(width: 15),
                                  Text(
                                    "Mood",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blueAccent),
                                  ),
                                ],
                              ),
                              SizedBox(height: 30),
                              Center(
                                child: Text(
                                  zodiacMood ?? "",
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 26,
                                      fontWeight: FontWeight.bold),
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(width: 15),
                        _sliderWidget(
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 30,
                                    height: 30,
                                    decoration: BoxDecoration(
                                        color: Colors.blueAccent,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20))),
                                    child: Icon(
                                      Icons.numbers,
                                      size: 18,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(width: 15),
                                  Text(
                                    "Number",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blueAccent),
                                  ),
                                ],
                              ),
                              SizedBox(height: 15),
                              Center(
                                child: Text(
                                  zodiacNumber ?? "",
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 50,
                                      fontWeight: FontWeight.bold),
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(width: 30),
                      ],
                    );
                  },
                ),
              ),
              SizedBox(height: 15),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                  child: Column(
                    children: [
                      SizedBox(height: 15),
                      _listMenu(
                        context,
                        "Library",
                        Icon(
                          Icons.book,
                          color: Colors.white,
                          size: 18,
                        ),
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LibraryScreen()),
                          );
                        },
                      ),
                      Divider(
                        thickness: 1,
                        color: Colors.grey.withOpacity(0.2),
                      ),
                      _listMenu(
                        context,
                        "Financial",
                        Icon(
                          Icons.attach_money,
                          color: Colors.white,
                          size: 18,
                        ),
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => FinancialScreen()),
                          );
                        },
                      ),
                      Divider(
                        thickness: 1,
                        color: Colors.grey.withOpacity(0.2),
                      ),
                      _listMenu(
                        context,
                        "Calendar",
                        Icon(
                          Icons.calendar_month,
                          color: Colors.white,
                          size: 18,
                        ),
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CalendarScreen()),
                          );
                        },
                      ),
                      Divider(
                        thickness: 1,
                        color: Colors.grey.withOpacity(0.2),
                      ),
                      _listMenu(
                        context,
                        "Dictionary",
                        Icon(
                          Icons.menu_book_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DictionaryScreen()),
                          );
                        },
                      ),
                      Divider(
                        thickness: 1,
                        color: Colors.grey.withOpacity(0.2),
                      ),
                      _listMenu(
                        context,
                        "Health",
                        Icon(
                          Icons.health_and_safety,
                          color: Colors.white,
                          size: 18,
                        ),
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HealthScreen()),
                          );
                        },
                      ),
                      Divider(
                        thickness: 1,
                        color: Colors.grey.withOpacity(0.2),
                      ),
                      _listMenu(
                        context,
                        "Music",
                        Icon(
                          Icons.music_note,
                          color: Colors.white,
                          size: 18,
                        ),
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MusicScreen()),
                          );
                        },
                      ),
                      SizedBox(height: 15),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 15),
              Center(
                child: Text(
                  "Develop by Pesoros",
                  style: TextStyle(fontSize: 9, color: Colors.grey),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _header(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 30, left: 30, right: 30, bottom: 15),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    Colors.blueAccent,
                    Colors.white,
                  ],
                ),
                borderRadius: BorderRadius.all(Radius.circular(50))),
          ),
          SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                variable.name,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 7),
              Text(
                variable.nik,
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          )
        ],
      ),
    );
  }

  _sliderWidget(Widget child) {
    return Container(
      width: 200,
      height: 150,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(15))),
      child: Padding(padding: EdgeInsets.all(15), child: child),
    );
  }

  _listMenu(
      BuildContext context, String menuName, Widget icon, Function navigate) {
    return InkWell(
      child: Padding(
        padding: EdgeInsets.only(top: 0, left: 15, right: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                        color: Colors.blueAccent,
                        borderRadius: BorderRadius.all(Radius.circular(50))),
                    child: icon),
                SizedBox(width: 10),
                Text(
                  menuName,
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
      onTap: navigate,
    );
  }
}
