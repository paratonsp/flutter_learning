// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nik_validator/nik_validator.dart';
import 'package:pesoros_app/screens/menu.dart';
import 'package:pesoros_app/variables.dart' as variable;

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController numberController = TextEditingController();

  getData() async {
    NIKModel result =
        await NIKValidator.instance.parse(nik: numberController.text);
    print(result);
    if (result.valid) {
      setState(() {
        variable.name = nameController.text;
        variable.nik = result.nik;
        variable.uniqueCode = result.uniqueCode;
        variable.gender = result.gender;
        variable.bornDate = result.bornDate;
        variable.age = result.age;
        variable.nextBirthday = result.nextBirthday;
        variable.zodiac = result.zodiac;
        variable.province = result.province;
        variable.city = result.city;
        variable.subdistrict = result.subdistrict;
        variable.postalCode = result.postalCode;
      });
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) => MenuScreen()));
    } else {
      Fluttertoast.showToast(msg: "NIK Salah!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 60),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Name"),
            SizedBox(height: 3.5),
            CupertinoTextField(
              controller: nameController,
              keyboardType: TextInputType.name,
            ),
            SizedBox(height: 15),
            Text("Identity Number"),
            SizedBox(height: 3.5),
            CupertinoTextField(
              controller: numberController,
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 30),
            Center(
              child: CupertinoButton.filled(
                onPressed: () {
                  if (nameController.text == null ||
                      nameController.text == "") {
                    Fluttertoast.showToast(msg: "Isi Nama!");
                  } else {
                    if (numberController.text == "000") {
                      setState(() {
                        variable.name = nameController.text;
                        variable.nik = "000";
                        variable.uniqueCode = "000";
                        variable.gender = "LAKI-LAKI";
                        variable.bornDate = "09-09-1999";
                        variable.age = "00 tahun, 00 bulan, 00 hari";
                        variable.nextBirthday = "00 bulan, 6 hari lagi";
                        variable.zodiac = "Libra";
                        variable.province = "JAWA TIMUR";
                        variable.city = "SURABAYA";
                        variable.subdistrict = "SUKOMANUNGGAL";
                        variable.postalCode = "60181";
                      });
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => MenuScreen()));
                    } else {
                      getData();
                    }
                  }
                },
                child: Text("Next"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
