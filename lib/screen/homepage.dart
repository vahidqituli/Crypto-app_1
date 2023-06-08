import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:vahid/data/constans/constants.dart';
import 'package:vahid/data/model/crypto.dart';
import 'package:vahid/data/model/user.dart';
import 'package:vahid/screen/coin.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Homepage extends StatefulWidget {
  Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  String title = "looding";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdata();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: blackColor,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(image: AssetImage('images/logo.png')),
            SpinKitWave(
              color: Colors.blue,
              size: 30.0,
            ),
          ],
        ),
      ),
    );
  }

  void getdata() async {
    print("Sending GET request to: https://jsonplaceholder.typicode.com/users");
    var response = await Dio().get("https://api.coincap.io/v2/assets");

    List<Crypto> cryptolist = response.data['data']
        .map((jsonMapObject) => Crypto.fromMapJson(jsonMapObject))
        .toList()
        .cast<Crypto>();

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CoinListScreen(
                  cryptolist: cryptolist,
                )));
  }
}
