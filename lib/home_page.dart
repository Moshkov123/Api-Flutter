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
          id:data['id'] ,
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
                    color: Color(0xFF262626),
                    shape: BoxShape.rectangle, // Замените 'RoundedRectangle' на 'BoxShape.rectangle'
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ListTile(
                    title: Text(teams[index].id.toString(), style: TextStyle(color: Colors.redAccent)),
                    subtitle: Column(
                      children: [
                        Text(teams[index].title, style: TextStyle(color: Colors.redAccent)),
                        Text(teams[index].body, style: TextStyle(color: Colors.white)),
                      ],
                    ),
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
