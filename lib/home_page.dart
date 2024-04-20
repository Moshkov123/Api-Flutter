import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'model/team.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  List<Team> teams = [];

  // get teams
  Future<List<Team>> getTeams() async {
    var response = await http.get(Uri.https('jsonplaceholder.typicode.com', 'posts'));
    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      List<Team> fetchedTeams = [];
      for (var data in jsonData) {
        final team = Team(
          title: data['title'],
          body: data['body'],
        );
        fetchedTeams.add(team);
      }
      return fetchedTeams;
    } else {
      throw Exception('Failed to load teams');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: getTeams(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error fetching data'));
          } else {
            List<Team> teams = snapshot.data as List<Team>;
            return ListView.builder(
              itemCount: teams.length,
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.black,
                  ),
                  child: ListTile(
                    title: Text(teams[index].title, style: TextStyle(color: Colors.redAccent)),
                    subtitle: Text(teams[index].body, style: TextStyle(color: Colors.white)),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
