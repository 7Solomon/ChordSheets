import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

import 'song_sheet.dart';

class OverviewPage extends StatefulWidget {
  @override
  _OverviewPageState createState() => _OverviewPageState();
}

class _OverviewPageState extends State<OverviewPage> {
  late List<String> items = [];
  late Map<String, dynamic> data = {};

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    data = await _loadJson();
    setState(() {
      items = data.keys.toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Song Übersicht'),
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SongSheetPage(data: data[items[index]]),
                ),
              );
            },
            child: SongListItem(title: items[index]),
          );
        },
      ),
    );
  }
}

class SongListItem extends StatelessWidget {
  final String title;

  SongListItem({required this.title});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          title,
          style: const TextStyle(fontSize: 18.0),
        ),
      ),
    );
  }
}
//
// Function to load the JSON data from the assets folder

Future<Map<String, dynamic>> _loadJson() async {
  String jsonString = await rootBundle.loadString('assets/data.json');
  Map<String, dynamic> data = jsonDecode(jsonString);
  data = _fixJsonData(data);
  return data;
}

Map<String, dynamic> _fixJsonData(Map<String, dynamic> data) {
  data.forEach((key, value) {
    if (value is Map<String, dynamic>) {
      value['key'] = value['key'] as String? ?? "no Key";
      value['data'] = value['data'] as Map<String, dynamic>? ?? {};
    } else {
      print('Value is not a Map<String, dynamic>');
    }
  });
  return data;
}
