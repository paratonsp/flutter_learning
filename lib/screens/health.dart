// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, avoid_print, prefer_const_literals_to_create_immutables, non_constant_identifier_names, unnecessary_this, prefer_collection_literals, unnecessary_new, unused_element, prefer_is_empty, unused_import, prefer_final_fields, prefer_adjacent_string_concatenation, prefer_typing_uninitialized_variables

import 'dart:convert';
import 'package:intl/intl.dart';
import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_maps/maps.dart';

class HealthScreen extends StatefulWidget {
  @override
  State<HealthScreen> createState() => _HealthScreenState();
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

class Model {
  const Model(
    this.state,
    this.color,
    this.val,
    this.stateCode,
    this.valSmbuh,
    this.valMeninggal,
    this.laki,
    this.perempuan,
  );
  final String state;
  final Color color;
  final int val;
  final String stateCode;
  final int valSmbuh;
  final int valMeninggal;
  final int laki;
  final int perempuan;
}

class _HealthScreenState extends State<HealthScreen> {
  TextEditingController keywordController = TextEditingController();

  bool loadData = true;
  bool loadImage = true;
  List<Model> _data = [];
  MapShapeSource _mapMainLayer;
  MapShapeSource _mapSubLayer;
  String lastUpdate;
  String imageLink;
  var avgKasus;
  var defaultCity = 0;

  fetchData() async {
    final response = await http
        .get(Uri.parse("https://data.covid19.go.id/public/api/prov.json"));

    var a = 0;
    var b = 0;
    var c = 0;

    for (var data in jsonDecode(response.body)['list_data'] as List) {
      b = data['penambahan']['positif'];
      a = b + a;
      c = c + 1;
    }

    var d = a / c;

    setState(() {
      avgKasus = d;
      lastUpdate = jsonDecode(response.body)['last_date'];
    });

    for (var data in jsonDecode(response.body)['list_data'] as List) {
      _data.add(Model(
        data['key'],
        (data['penambahan']['positif'] > d)
            ? Color.fromRGBO(172, 12, 12, 100)
            : Color.fromRGBO(167, 216, 46, 100),
        data['penambahan']['positif'],
        data['key'],
        data['penambahan']['sembuh'],
        data['penambahan']['meninggal'],
        data['jenis_kelamin'][0]['doc_count'],
        data['jenis_kelamin'][1]['doc_count'],
      ));
    }
    setState(() {
      _mapMainLayer = MapShapeSource.asset('assets/asia.json');
      _mapSubLayer = MapShapeSource.asset(
        'assets/indonesia.json',
        shapeDataField: 'Propinsi',
        dataCount: _data.length,
        primaryValueMapper: (int index) => _data[index].state,
        dataLabelMapper: (int index) => _data[index].stateCode,
        shapeColorValueMapper: (int index) => _data[index].color,
      );
    });
    getImage(defaultCity);
    setState(() {
      loadData = false;
    });
  }

  getImage(int intImage) async {
    final response = await http.get(Uri.parse(
        "https://api.unsplash.com/search/photos?client_id=Brj99O62zS6VJYxFCCwJy_UfoxmoTnIz-W-93EgCcKc&page=1&per_page=340&query=indonesia"));
    setState(() {
      imageLink =
          jsonDecode(response.body)['results'][intImage]['urls']['regular'];
      loadImage = false;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CupertinoNavigationBar(
        border: Border(bottom: BorderSide(color: Colors.transparent)),
        middle: Text("Health"),
        leading: CupertinoNavigationBarBackButton(
          onPressed: (() {
            Navigator.pop(context);
          }),
        ),
      ),
      body: (loadData)
          ? Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: SfMaps(
                    layers: <MapShapeLayer>[
                      MapShapeLayer(
                        source: _mapMainLayer,
                        zoomPanBehavior: MapZoomPanBehavior(
                          focalLatLng: MapLatLng(-2.6000285, 118.015776),
                          zoomLevel: 1,
                        ),
                        strokeColor: Theme.of(context).scaffoldBackgroundColor,
                        strokeWidth: 0.2,
                        sublayers: [
                          MapShapeSublayer(
                            source: _mapSubLayer,
                            showDataLabels: true,
                            strokeColor:
                                Theme.of(context).scaffoldBackgroundColor,
                            strokeWidth: 0.2,
                            onSelectionChanged: (val) {
                              setState(() {
                                defaultCity = val;
                                loadImage = true;
                                getImage(defaultCity);
                              });
                            },
                            dataLabelSettings: MapDataLabelSettings(
                                textStyle: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 0)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 15, left: 30),
                  child: Text(
                    "Indonesian Covid Data",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 52.5, left: 30),
                  child: Text(
                    "Source: data.covid19.go.id",
                    style: TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  child: SizedBox(
                    height: 225,
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: EdgeInsets.all(30),
                      child: (loadImage)
                          ? Center(
                              child: Container(
                                  padding: EdgeInsets.all(7),
                                  decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.7),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(50))),
                                  child: CircularProgressIndicator()))
                          : Container(
                              decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.7),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15))),
                              child: Row(
                                children: [
                                  SizedBox(
                                    height: 165,
                                    width:
                                        MediaQuery.of(context).size.width / 2.5,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: Image.network(
                                        imageLink,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.all(15),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Flexible(
                                            flex: 1,
                                            child: Text(
                                              _data[defaultCity].state,
                                              style: TextStyle(
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.blueAccent),
                                            ),
                                          ),
                                          SizedBox(height: 7),
                                          Row(
                                            children: [
                                              Container(
                                                width: 12,
                                                height: 12,
                                                decoration: BoxDecoration(
                                                    color: Colors.orange,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                20))),
                                                child: Icon(
                                                  Icons.add,
                                                  size: 10,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              SizedBox(width: 7),
                                              Text(
                                                "Positif: " +
                                                    _data[defaultCity]
                                                        .val
                                                        .toString(),
                                                style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 12,
                                                    overflow:
                                                        TextOverflow.ellipsis),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 3.5),
                                          Row(
                                            children: [
                                              Container(
                                                width: 12,
                                                height: 12,
                                                decoration: BoxDecoration(
                                                    color: Colors.green,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                20))),
                                                child: Icon(
                                                  Icons.remove,
                                                  size: 10,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              SizedBox(width: 7),
                                              Text(
                                                "Negative: " +
                                                    _data[defaultCity]
                                                        .valSmbuh
                                                        .toString(),
                                                style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 12,
                                                    overflow:
                                                        TextOverflow.ellipsis),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 3.5),
                                          Row(
                                            children: [
                                              Container(
                                                width: 12,
                                                height: 12,
                                                decoration: BoxDecoration(
                                                    color: Colors.red,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                20))),
                                                child: Icon(
                                                  Icons.clear,
                                                  size: 10,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              SizedBox(width: 7),
                                              Text(
                                                "Meninggal: " +
                                                    _data[defaultCity]
                                                        .valMeninggal
                                                        .toString(),
                                                style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 12,
                                                    overflow:
                                                        TextOverflow.ellipsis),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 15),
                                          Row(
                                            children: [
                                              Container(
                                                width: 12,
                                                height: 12,
                                                decoration: BoxDecoration(
                                                    color: Colors.blueAccent,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                20))),
                                                child: Icon(
                                                  Icons.male,
                                                  size: 10,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              SizedBox(width: 7),
                                              Text(
                                                _data[defaultCity]
                                                    .laki
                                                    .toString(),
                                                style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 12,
                                                    overflow:
                                                        TextOverflow.ellipsis),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 3.5),
                                          Row(
                                            children: [
                                              Container(
                                                width: 12,
                                                height: 12,
                                                decoration: BoxDecoration(
                                                    color: Colors.pink,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                20))),
                                                child: Icon(
                                                  Icons.female,
                                                  size: 10,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              SizedBox(width: 7),
                                              Text(
                                                _data[defaultCity]
                                                    .perempuan
                                                    .toString(),
                                                style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 12,
                                                    overflow:
                                                        TextOverflow.ellipsis),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
