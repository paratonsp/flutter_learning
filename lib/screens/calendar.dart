// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, avoid_print, prefer_const_literals_to_create_immutables, non_constant_identifier_names, unnecessary_this, prefer_collection_literals, unnecessary_new, unused_element, prefer_is_empty

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:calendar_view/calendar_view.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class Event {
  String title;

  Event({this.title = "Title"});

  @override
  bool operator ==(Object other) => other is Event && title == other.title;

  @override
  int get hashCode => super.hashCode;

  @override
  String toString() => title;
}

class CalendarScreen extends StatefulWidget {
  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  final EventController<Event> _controllerEvent = EventController();
  bool loadEvents = true;

  fetchEvents() async {
    final response = await http.get(Uri.parse(
        'https://holidayapi.com/v1/holidays?pretty&key=d2718280-97a2-4f38-9d88-9b04b8b2a7e3&country=ID&year=2021'));
    for (var data in jsonDecode(response.body)['holidays'] as List) {
      DateTime tempDate = DateTime.parse(data['date']);
      _controllerEvent.add(
        CalendarEventData(
          date: tempDate,
          title: data['name'],
        ),
      );
    }
    setState(() {
      loadEvents = false;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchEvents();
  }

  @override
  Widget build(BuildContext context) {
    return CalendarControllerProvider<Event>(
      controller: _controllerEvent,
      child: Scaffold(
        appBar: CupertinoNavigationBar(
          middle: Text("Calendar"),
          leading: CupertinoNavigationBarBackButton(
            onPressed: (() {
              Navigator.pop(context);
            }),
          ),
        ),
        body: (loadEvents)
            ? Center(child: CircularProgressIndicator())
            : MonthViewWidget(),
      ),
    );
  }
}

class MonthViewWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MonthView<Event>(
      initialMonth: DateTime(2021),
      width: MediaQuery.of(context).size.width,
      showBorder: false,
      cellBuilder: (date, events, isToday, isInMonth) {
        return Container(
          color: (events.isNotEmpty)
              ? Colors.blueAccent
              : (isInMonth)
                  ? Colors.white
                  : Colors.grey.withOpacity(0.5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.all(4),
                child: Text(
                  date.day.toString(),
                  style: TextStyle(
                      color: (events.isNotEmpty)
                          ? Colors.white
                          : (isInMonth)
                              ? Colors.grey.withOpacity(0.5)
                              : Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
              ),
              (events.isNotEmpty)
                  ? Container(
                      padding: EdgeInsets.all(4),
                      child: Text(
                        events[0].title,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 8,
                            fontWeight: FontWeight.bold),
                      ),
                    )
                  : Text(""),
            ],
          ),
        );
      },
      headerBuilder: (date) {
        return Container(
            padding: EdgeInsets.all(30),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat('MMMM').format(date),
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  date.year.toString(),
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
              ],
            ));
      },
      weekDayBuilder: (date) {
        return null;
      },
    );
  }
}
