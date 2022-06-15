// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_element

import 'package:flutter/material.dart';
import 'package:pesoros_app/variables.dart' as variable;

class MenuScreen extends StatefulWidget {
  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _header(context),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.width / 3,
                child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: 15,
                    itemBuilder: (BuildContext context, int index) {
                      bool firstPadding = false;
                      bool lastPadding = false;
                      if (index == 0) {
                        firstPadding = true;
                      }
                      if (index == 14) {
                        lastPadding = true;
                      }
                      return Padding(
                        padding: EdgeInsets.only(
                            left: (firstPadding) ? 30 : 10,
                            right: (lastPadding) ? 30 : 0),
                        child: _sliderWidget(context),
                      );
                    }),
              ),
              // _listMenu(context, "KAMPUS"),
              // _listMenu(context, "PEMERINTAHAN"),
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
                color: Colors.white,
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
              Text(
                variable.nik,
                style: TextStyle(fontSize: 12),
              ),
            ],
          )
        ],
      ),
    );
  }

  _sliderWidget(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 2.3,
      height: MediaQuery.of(context).size.width / 3,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(15))),
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.rocket_rounded),
            Text("data"),
            Text("data"),
            Text("data"),
          ],
        ),
      ),
    );
  }

  _listMenu(BuildContext context, String menuName) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(menuName),
          Icon(Icons.arrow_forward_ios),
        ],
      ),
    );
  }
}
