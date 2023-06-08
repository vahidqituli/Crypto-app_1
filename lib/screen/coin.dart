import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:vahid/data/model/crypto.dart';

import '../data/constans/constants.dart';
import '../data/model/user.dart';

class CoinListScreen extends StatefulWidget {
  CoinListScreen({super.key, this.cryptolist});
  List<Crypto>? cryptolist;

  @override
  State<CoinListScreen> createState() => _CoinListScreenState();
}

class _CoinListScreenState extends State<CoinListScreen> {
  List<Crypto>? crytptolist;
  bool isSearchvisibil = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    crytptolist = widget.cryptolist;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: blackColor,
      appBar: AppBar(
        backgroundColor: blackColor,
        title: Text(
          "کریپتو بازار وحید",
          style: TextStyle(
            fontFamily: 'morbaee',
          ),
        ),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: TextField(
                  onChanged: (value) {
                    _filterList(value);
                  },
                  decoration: InputDecoration(
                    hintText: "اسم رمز ارز معتبر را سرچ کنید",
                    hintStyle:
                        TextStyle(fontFamily: "morbaee", color: Colors.white),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(width: 0, style: BorderStyle.none),
                    ),
                    fillColor: greenColor,
                    filled: true,
                  ),
                ),
              ),
            ),
            Visibility(
              visible: isSearchvisibil,
              child: Text(
                "در حال آپدیت اطلاعات رمز ارزها",
                style: TextStyle(fontFamily: "morbaee", color: greenColor),
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                backgroundColor: Colors.green,
                color: Colors.black,
                child: ListView.builder(
                  itemCount: crytptolist!.length,
                  itemBuilder: (context, index) =>
                      _getTile(crytptolist![index]),
                ),
                onRefresh: () async {
                  List<Crypto> freshdata = await getdata();
                  setState(() {
                    crytptolist = freshdata;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getTile(Crypto crypto) {
    return ListTile(
      title: Text(
        crypto.name,
        style: TextStyle(color: greenColor),
      ),
      subtitle: Text(crypto.symbol, style: TextStyle(color: greyColor)),
      leading: SizedBox(
        width: 30,
        child: Center(
          child:
              Text(crypto.rank.toString(), style: TextStyle(color: greyColor)),
        ),
      ),
      trailing: SizedBox(
        width: 150,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  crypto.priceUsd.toStringAsFixed(2),
                  style: TextStyle(color: greyColor, fontSize: 18),
                ),
                Text(
                  crypto.changePercent24Hr.toStringAsFixed(2),
                  style: TextStyle(
                    color: _getChangeText(crypto.changePercent24Hr),
                  ),
                ),
              ],
            ),
            SizedBox(
              width: 25,
              child: Center(
                  child: _getIconChangePercent(
                crypto.changePercent24Hr,
              )),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getIconChangePercent(double percentChange) {
    return percentChange <= 0
        ? Icon(
            Icons.trending_down,
            size: 25,
            color: redColor,
          )
        : Icon(
            Icons.trending_up,
            size: 25,
            color: greenColor,
          );
  }

  Color _getChangeText(double percentChange) {
    return percentChange <= 0 ? redColor : greenColor;
  }

  Future<List<Crypto>> getdata() async {
    print("Sending GET request to: https://jsonplaceholder.typicode.com/users");
    var response = await Dio().get("https://api.coincap.io/v2/assets");

    List<Crypto> cryptolist = response.data['data']
        .map((jsonMapObject) => Crypto.fromMapJson(jsonMapObject))
        .toList()
        .cast<Crypto>();
    return cryptolist;
  }

  Future<void> _filterList(String enterkeyword) async {
    List<Crypto> cryptolistResult = [];

    if (enterkeyword.isEmpty) {
      setState(() {
        isSearchvisibil = true;
      });
      var result = await getdata();
      setState(() {
        crytptolist = result;
      });
      setState(() {
        isSearchvisibil = false;
      });
      return;
    }

    cryptolistResult = crytptolist!
        .where(
          (element) => element.name.toLowerCase().contains(
                enterkeyword.toLowerCase(),
              ),
        )
        .toList();
    setState(() {
      crytptolist = cryptolistResult;
    });
  }
}
