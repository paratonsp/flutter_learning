// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, avoid_print, prefer_const_literals_to_create_immutables, non_constant_identifier_names, unnecessary_this, prefer_collection_literals, unnecessary_new, unused_element, prefer_is_empty

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LibraryScreen extends StatefulWidget {
  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class Book {
  String book_title;
  String authors_name;
  List subjects;
  String image_link;

  Book({
    this.book_title,
    this.authors_name,
    this.subjects,
    this.image_link,
  });

  Book.fromJson(Map<String, dynamic> json) {
    book_title = json['title'];
    authors_name = json["authors"][0]['name'];
    subjects = json["subjects"];
    image_link = json["formats"]["image/jpeg"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['book_title'] = this.book_title;
    data['authors_name'] = this.authors_name;
    data['subjects'] = this.subjects;
    data['image_link'] = this.image_link;

    return data;
  }
}

class _LibraryScreenState extends State<LibraryScreen> {
  List<Book> listBook = [];
  bool loadBook = true;

  fetchBook() async {
    final response = await http.get(Uri.parse('https://gutendex.com/books'));

    for (var data in jsonDecode(response.body)['results'] as List) {
      listBook.add(Book.fromJson(data));
    }
    setState(() {
      loadBook = false;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchBook();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CupertinoNavigationBar(
        middle: Text("Library"),
        leading: CupertinoNavigationBarBackButton(
          onPressed: (() {
            Navigator.pop(context);
          }),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 30, left: 30),
            child: Text(
              "Book List",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 15),
          (loadBook)
              ? Expanded(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : Expanded(
                  child: ListView.builder(
                    physics: BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: listBook.length,
                    itemBuilder: (context, index) {
                      Book book = listBook[index];
                      return _listBook(book.book_title, book.authors_name,
                          book.image_link, book.subjects);
                    },
                  ),
                ),
        ],
      ),
    );
  }

  Widget _listBook(
      String book_title, String name, String image, List subjects) {
    return Padding(
      padding: EdgeInsets.only(left: 30, right: 30, bottom: 7),
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(15))),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 100,
              height: 150,
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                    topLeft: (Radius.circular(15)),
                    bottomLeft: (Radius.circular(15))),
                child: Image.network(
                  image,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 7),
                  Text(
                    book_title,
                    maxLines: 2,
                    style: TextStyle(
                        overflow: TextOverflow.ellipsis,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 3.5),
                  Text(
                    "Author",
                    style: TextStyle(
                        overflow: TextOverflow.ellipsis,
                        fontSize: 10,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    name,
                    style: TextStyle(
                        overflow: TextOverflow.ellipsis, fontSize: 10),
                  ),
                  SizedBox(height: 3.5),
                  Text(
                    "Subjects",
                    style: TextStyle(
                        overflow: TextOverflow.ellipsis,
                        fontSize: 10,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    subjects[0] ?? "",
                    style: TextStyle(
                        overflow: TextOverflow.ellipsis, fontSize: 10),
                  ),
                  Text(
                    (subjects.length > 1) ? subjects[1] : "",
                    style: TextStyle(
                        overflow: TextOverflow.ellipsis, fontSize: 10),
                  ),
                  Text(
                    // subjects.length.toString(),
                    (subjects.length > 2) ? subjects[2] : "",
                    style: TextStyle(
                        overflow: TextOverflow.ellipsis, fontSize: 10),
                  ),
                  Text(
                    (subjects.length > 3) ? subjects[3] : "",
                    style: TextStyle(
                        overflow: TextOverflow.ellipsis, fontSize: 10),
                  ),
                  Text(
                    // subjects.length.toString(),
                    (subjects.length > 4) ? subjects[4] : "",
                    style: TextStyle(
                        overflow: TextOverflow.ellipsis, fontSize: 10),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
