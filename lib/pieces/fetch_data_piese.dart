import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:auto_sales_flutter/cars/list_widget_masini.dart';
import 'package:auto_sales_flutter/key.dart';
import 'package:auto_sales_flutter/models/anunt_cars.dart';
import 'package:auto_sales_flutter/models/anunt_piese.dart';
import 'package:auto_sales_flutter/pieces/list_widget_piese.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<List<AnuntModelPiese>> fetchAnuntModelPiese() async {
  
  String basicAuth =
      'Basic ' + base64.encode(utf8.encode('$Keys.username:$Keys.password'));

  print(basicAuth);
  final responsePiese = await http.get(
    Uri.parse('https://www.samsareala.ro/wp-json/wc/v3/products'),
    headers: {
      'Content-Type': 'application/json',
      HttpHeaders.authorizationHeader: basicAuth,
    },
  );

  print(responsePiese.statusCode);

  return parseAnuntModelPiese(responsePiese.body);
}

List<AnuntModelPiese> parseAnuntModelPiese(String responsePieseBody) {
  final parsed = jsonDecode(responsePieseBody);
  return parsed
      .map<AnuntModelPiese>((json) => AnuntModelPiese.fromJson(json))
      .toList();
}

class ListMPiese extends StatelessWidget {
  const ListMPiese({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<AnuntModelPiese>>(
        future: fetchAnuntModelPiese(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('An error has occurred!'),
            );
          } else if (snapshot.hasData) {
            return ListItemsPiese(tempList: snapshot.data!);
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
