import 'package:http/http.dart' as http;
import 'dart:convert';

const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];

const apiKey = '987A9337-2791-4C0B-9648-FB41E5BEAC78';

class CoinData {
  final String crypto;
  final String currency;
  CoinData(this.crypto, this.currency);
  Future<dynamic> getCoinData() async {
    http.Response response = await http.get(
        'https://rest.coinapi.io/v1/exchangerate/$crypto/$currency?apikey=$apiKey');
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print(response.statusCode);
    }
  }
}
