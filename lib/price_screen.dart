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
  String rate = 'Loading...';
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
          getRate(CoinData('BTC', selectedCurrency));
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
        getRate(CoinData('BTC', selectedCurrency));
      },
      children: list,
    );
  }

  @override
  void initState() {
    super.initState();
    getRate(CoinData('BTC', selectedCurrency));
  }

  void getRate(CoinData coin) async {
    var data = await coin.getCoinData();
    setState(() {
      if (data != null) {
        rate = data['rate'].toInt().toString();
      } else {
        rate = '0';
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
        children: <Widget>[
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
                  '1 BTC = $rate $selectedCurrency',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? iOSPicker() : androidDropdown(),
          ),
        ],
      ),
    );
  }
}
