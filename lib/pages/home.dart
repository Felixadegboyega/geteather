import 'package:flutter/material.dart';
import 'package:geteather/pages/new.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppHome extends StatelessWidget {
  const AppHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return getHome(context);
  }

  Scaffold getHome(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.keyboard_arrow_right_rounded,
          size: 30,
          color: Colors.indigo,
        ),
        backgroundColor: Colors.white70,
        onPressed: () async {
          final prefs = await SharedPreferences.getInstance();
          prefs.setBool('newUser', false);

          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => NewWeather()));
        },
      ),
      backgroundColor: Colors.indigo,
      body: Center(
        child: Column(
          children: [
            Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                width: double.infinity,
                margin: EdgeInsets.only(top: 150),
                child: Text('Easily get weather information of Locations',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white70, fontSize: 40))),
          ],
        ),
      ),
    );
  }
}
