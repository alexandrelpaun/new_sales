import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:auto_sales_flutter/cars/list_widget_masini.dart';
import 'package:auto_sales_flutter/key.dart';
import 'package:auto_sales_flutter/models/anunt_cars.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<List<AnuntModel>> fetchAnuntModel() async {
 
  String basicAuth =
      'Basic ' + base64.encode(utf8.encode('$Keys.username:$Keys.password'));

  print(basicAuth);
  final response = await http.get(
    Uri.parse('https://www.samsareala.ro/wp-json/wc/v3/products'),
    headers: <String, String>{
      'Content-Type': 'application/json',
      'authorization': basicAuth
    },
  );

  print(response.statusCode);

  return parseAnuntModel(response.body);
}

List<AnuntModel> parseAnuntModel(String responseBody) {
  final parsed = jsonDecode(responseBody);
  return parsed.map<AnuntModel>((json) => AnuntModel.fromJson(json)).toList();
}

class ListM extends StatelessWidget {
  const ListM({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<AnuntModel>>(
        future: fetchAnuntModel(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('An error has occurred!'),
            );
          } else if (snapshot.hasData) {
            return ListItems(anunturi: snapshot.data!);
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
