import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Weatherinfo extends StatefulWidget {
  Weatherinfo({Key? key, required this.locationName})
      : super(
          key: key,
        );

  final String locationName;

  @override
  _WeatherinfoState createState() => _WeatherinfoState();
}

class _WeatherinfoState extends State<Weatherinfo> {
  bool reLoading = false;
  @override
  Widget build(BuildContext context) {
    getWeather();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.locationName),
      ),
      body: Container(
        padding: EdgeInsets.only(left: 20, right: 20, top: 30),
        child: !reLoading
            ? weatherBody()
            : Center(
                child: Padding(
                  child: LinearProgressIndicator(),
                  padding: EdgeInsets.symmetric(horizontal: 100),
                ),
              ),
      ),
    );
  }

  Widget weatherBody() {
    return FutureBuilder(
        future: getWeather(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return buildBody(snapshot.data);
          } else {
            return Center(
              child: Padding(
                child: LinearProgressIndicator(),
                padding: EdgeInsets.symmetric(horizontal: 100),
              ),
            );
          }
        });
  }

  Widget buildBody(data) {
    if (data["cod"] == 200) {
      saveToHistory();
      return Column(
        children: [
          getWeatherProperty("Temperature: ${data['main']['temp']}"),
          Divider(),
          getWeatherProperty(
              "Minimum Temperature: ${data['main']['temp_min']}"),
          Divider(),
          getWeatherProperty(
              "Maximum Temperature: ${data['main']['temp_max']}"),
          Divider(),
          getWeatherProperty(
              "Description: ${data['weather'][0]['description']}"),
          Divider(),
          getWeatherProperty("Pressure: ${data['main']['pressure']}"),
          Divider(),
          getWeatherProperty("Humidity: ${data['main']['humidity']}"),
          Divider(),
          getWeatherProperty("Wind Speed: ${data['wind']['speed']}"),
          Divider(),
        ],
      );
    } else if (data["cod"] == '404') {
      return Center(
        child: Text(
          "${data['message']}, Please make sure the address you supplied is valid and include a comma between your location address",
          style: TextStyle(fontSize: 15),
          textAlign: TextAlign.center,
        ),
      );
    } else if (data["networkError"]) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Please check your internet connection",
              style: TextStyle(fontSize: 15),
              textAlign: TextAlign.center,
            ),
            // TextButton(
            //     onPressed: () {
            //       setState(() {
            //         getWeather();
            //         reLoading = true;
            //       });
            //     },
            //     child: Text('Retry'))
          ],
        ),
      );
    } else {
      return Center(
        child: Text(
          "Please try again in few seconds",
          style: TextStyle(fontSize: 15),
          textAlign: TextAlign.center,
        ),
      );
    }
  }

  void saveToHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final history = prefs.getStringList('searchHistory') ?? [];
    if (!history.contains(widget.locationName)) {
      history.add(widget.locationName);
      prefs.setStringList('searchHistory', history);
    }
  }

  Container getWeatherProperty(String info) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      width: double.infinity,
      child: Text(
        info,
        style: TextStyle(
          fontSize: 18,
        ),
        textAlign: TextAlign.left,
      ),
    );
  }

  Future<Map<String, dynamic>> getWeather() async {
    var weather;
    Uri url = Uri.parse(
        'https://community-open-weather-map.p.rapidapi.com/weather?q=${widget.locationName}');
    Map<String, String> headers = {
      'x-rapidapi-key': '04f36b90d0msh823b078d72423a2p1d81ffjsnb87fd776b03e',
      'x-rapidapi-host': 'community-open-weather-map.p.rapidapi.com'
    };
    try {
      var res = await http.get(url, headers: headers);
      var data = json.decode(res.body);
      weather = data;
    } catch (e) {
      // reLoading = false;
      print(e);
      weather = {'networkError': true};
    }
    // setState(() {
    //   reLoading = false;
    // });
    return weather;
  }
}
