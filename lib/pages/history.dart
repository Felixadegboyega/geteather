import 'package:flutter/material.dart';
import 'package:geteather/pages/weatherInfo.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchHistory extends StatefulWidget {
  const SearchHistory({Key? key}) : super(key: key);

  @override
  _SearchHistoryState createState() => _SearchHistoryState();
}

class _SearchHistoryState extends State<SearchHistory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Histories'),
      ),
      body: buildHistory(),
    );
  }

  Widget buildHistory() {
    return FutureBuilder(
        future: getHistory(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.isNotEmpty) {
              return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int i) {
                    return Column(
                      children: [
                        ListTile(
                          title: Text(snapshot.data[i]),
                          trailing: IconButton(
                              onPressed: () {
                                deleteHistory(snapshot.data[i]);
                              },
                              icon: Icon(Icons.delete_outline)),
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (BuildContext context) => Weatherinfo(
                                    locationName: snapshot.data[i])));
                          },
                        ),
                        Divider()
                      ],
                    );
                  });
            } else {
              return Center(
                child: Text('Your recent search will appear here.'),
              );
            }
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }

  Future getHistory() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('searchHistory') ?? [];
  }

  deleteHistory(text) async {
    final prefs = await SharedPreferences.getInstance();
    final history = prefs.getStringList('searchHistory') ?? [];
    history.remove(text);
    prefs.setStringList('searchHistory', history);
    setState(() {});
  }
}
