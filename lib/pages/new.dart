import 'package:flutter/material.dart';
import 'package:geteather/pages/history.dart';
import 'package:geteather/pages/weatherInfo.dart';

class NewWeather extends StatefulWidget {
  NewWeather({Key? key}) : super(key: key);

  @override
  _NewWeatherState createState() => _NewWeatherState();
}

class _NewWeatherState extends State<NewWeather> {
  var locationNameController = TextEditingController();

  String? errorText;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Get New Weather Info'),
        actions: [
          IconButton(onPressed: pushHistory, icon: Icon(Icons.history))
        ],
      ),
      body: Column(
        children: [
          Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                child: Container(
                  width: double.infinity,
                  child: Text(
                    'Enter your location',
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      child: Text(
                        getText(),
                        style: TextStyle(color: Colors.red),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                            flex: 7,
                            child: TextField(
                              controller: locationNameController,
                            )),
                        ElevatedButton(
                            onPressed: () {
                              search();
                            },
                            child: Text(
                              'Search',
                              style: TextStyle(fontSize: 20.0),
                            ))
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  pushHistory() {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (BuildContext context) => SearchHistory()));
  }

  getText() {
    if (errorText != null) {
      return errorText;
    } else {
      return '';
    }
  }

  void search() {
    if (locationNameController.text != '') {
      setState(() {
        errorText = null;
      });
      Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) =>
              Weatherinfo(locationName: locationNameController.text)));
    } else {
      setState(() {
        errorText = "Please, enter a location";
      });
    }
  }
}
