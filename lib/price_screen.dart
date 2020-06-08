import 'package:bitcoin_ticker/coin_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  static String selectedCurrency = 'USD';
  String rateBTC = 'Loading...';
  String rateETH = 'Loading...';
  String rateLTC = 'Loading...';
  DropdownButton<String> androidDropdown() {
    List<DropdownMenuItem<String>> menuItems = [];
    for (String string in currenciesList) {
      var item = DropdownMenuItem(
        child: Text(string),
        value: string,
      );
      menuItems.add(item);
    }
    return DropdownButton<String>(
      value: selectedCurrency,
      items: menuItems,
      onChanged: (value) {
        setState(() {
          selectedCurrency = value;
          getRate('BTC');
          getRate('ETH');
          getRate('LTC');
        });
      },
    );
  }

  CupertinoPicker iOSPicker() {
    List<Text> list = [];
    for (String s in currenciesList) {
      Text t = Text(s);
      list.add(t);
    }
    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 30.0,
      onSelectedItemChanged: (selected) {
        selectedCurrency = list[selected].data;
        getRate('BTC');
        getRate('ETH');
        getRate('LTC');
      },
      children: list,
    );
  }

  List<Widget> cardList() {
    List<Widget> l = [];
    String rate;
    for (String s in cryptoList) {
      if (s == 'BTC') {
        rate = rateBTC;
      } else if (s == 'ETH') {
        rate = rateETH;
      } else if (s == 'LTC') {
        rate = rateLTC;
      } else {
        rate = "Unavailable";
      }
      l.add(
        Padding(
          padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
          child: Card(
            color: Colors.lightBlueAccent,
            elevation: 5.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
              child: Text(
                '1 $s = $rate $selectedCurrency',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      );
    }
    l.add(
      Container(
        height: 150.0,
        alignment: Alignment.center,
        padding: EdgeInsets.only(bottom: 30.0),
        color: Colors.lightBlue,
        child: Platform.isIOS ? iOSPicker() : androidDropdown(),
      ),
    );
    return l;
  }

  @override
  void initState() {
    super.initState();
    getRate('BTC');
    getRate('ETH');
    getRate('LTC');
  }

  void getRate(String crypt) async {
    CoinData coin = CoinData(crypt, selectedCurrency);
    var data = await coin.getCoinData();
    setState(() {
      if (data != null) {
        if (crypt == 'BTC') {
          rateBTC = data['rate'].toInt().toString();
        } else if (crypt == 'ETH') {
          rateETH = data['rate'].toInt().toString();
        } else {
          rateLTC = data['rate'].toInt().toString();
        }
      } else {
        rateBTC = 'Unavailable';
        rateETH = 'Unavailable';
        rateLTC = 'Unavailable';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: cardList(),
      ),
    );
  }
}
