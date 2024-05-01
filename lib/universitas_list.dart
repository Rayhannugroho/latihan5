import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'List Universitas',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: UniversityListScreen(),
    );
  }
}

class UniversityListScreen extends StatefulWidget {
  @override
  _UniversityListScreenState createState() => _UniversityListScreenState();
}

class _UniversityListScreenState extends State<UniversityListScreen> {
  List<dynamic> universities = [];

  @override
  void initState() {
    super.initState();
    fetchUniversities();
  }

  Future<void> fetchUniversities() async {
    final response = await http.get(
      Uri.parse('http://universities.hipolabs.com/search?country=Indonesia'),
    );
    if (response.statusCode == 200) {
      setState(() {
        universities = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load universities');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Universitas Di Indonesia'),
      ),
      body: ListView.builder(
        itemCount: universities.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            color: Colors.blue,
            child: ListTile(
              title: Text(
                universities[index]['name'],
                style: TextStyle(color: Colors.black),
              ),
              subtitle: Text(
                universities[index]['web_pages'].isEmpty
                    ? 'No website available'
                    : universities[index]['web_pages'][0],
                style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
              ),
            ),
          );
        },
      ),
    );
  }
}
