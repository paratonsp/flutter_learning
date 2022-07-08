// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, avoid_print, prefer_const_literals_to_create_immutables, non_constant_identifier_names, unnecessary_this, prefer_collection_literals, unnecessary_new, unused_element, prefer_is_empty, unused_import, prefer_final_fields, prefer_adjacent_string_concatenation

import 'dart:convert';
import 'package:intl/intl.dart';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DictionaryScreen extends StatefulWidget {
  @override
  State<DictionaryScreen> createState() => _DictionaryScreenState();
}

class Arti {
  String kelas_kata;
  String deskripsi;

  Arti({
    this.kelas_kata,
    this.deskripsi,
  });

  Arti.fromJson(Map<String, dynamic> json) {
    kelas_kata = json['kelas_kata'];
    deskripsi = json["deskripsi"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['kelas_kata'] = this.kelas_kata;
    data['deskripsi'] = this.deskripsi;

    return data;
  }
}

class _DictionaryScreenState extends State<DictionaryScreen> {
  TextEditingController keywordController = TextEditingController();

  bool loadKeyword = true;
  String keywordString;
  String lema;
  List<Arti> _listArti = [];

  fetchKeyword(String keyword) async {
    final response = await http
        .get(Uri.parse('https://new-kbbi-api.herokuapp.com/cari/' + keyword));
    setState(() {
      keywordString = keywordController.text;
      lema = jsonDecode(response.body)['data'][0]['lema'];
    });
    if (_listArti.isNotEmpty) {
      _listArti.clear();
    }
    for (var data in jsonDecode(response.body)['data'][0]['arti'] as List) {
      _listArti.add(Arti.fromJson(data));
    }
    setState(() {
      loadKeyword = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CupertinoNavigationBar(
        middle: Text("Dictionary"),
        leading: CupertinoNavigationBarBackButton(
          onPressed: (() {
            Navigator.pop(context);
          }),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(15))),
          child: Padding(
            padding: EdgeInsets.all(30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 1.6,
                      child: CupertinoTextField(
                        placeholder: "Masukkan kata disini...",
                        controller: keywordController,
                        onSubmitted: (data) {
                          fetchKeyword(data);
                        },
                      ),
                    ),
                    Expanded(
                      child: IconButton(
                          onPressed: () {
                            FocusScope.of(context).requestFocus(FocusNode());
                            fetchKeyword(keywordController.text);
                          },
                          icon: Icon(Icons.search)),
                    )
                  ],
                ),
                SizedBox(height: 15),
                Divider(),
                SizedBox(height: 15),
                (loadKeyword)
                    ? Container()
                    : Text(
                        keywordString.toUpperCase(),
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
                        ),
                      ),
                (loadKeyword)
                    ? Container()
                    : Text(
                        lema ?? "",
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                SizedBox(height: 15),
                (loadKeyword)
                    ? Container()
                    : Expanded(
                        child: ListView.builder(
                          physics: BouncingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: _listArti.length,
                          itemBuilder: (context, index) {
                            Arti arti = _listArti[index];
                            return Container(
                              margin: EdgeInsets.only(bottom: 15),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.circle,
                                    size: 8,
                                    color: Colors.blueAccent,
                                  ),
                                  SizedBox(width: 15),
                                  Flexible(
                                    flex: 1,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          arti.deskripsi,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(fontSize: 12),
                                          maxLines: 99,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
