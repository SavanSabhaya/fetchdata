import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:web_demo/api_service.dart';
import 'package:web_demo/model.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Main(),
    );
  }
}

class Main extends StatefulWidget {
  const Main({Key? key}) : super(key: key);

  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {
  Future<DataResponse>? dataResponse;
  @override
  void initState() {
    super.initState();
    dataResponse = getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<DataResponse>(
        future: dataResponse,
        builder: (context, response) {
          if (response.data != null) {
            return Center(
              child: Container(
                  height: /* constraints.maxHeight / 1.5 */ 200,
                  width: /* constraints.maxWidth / 1.5 */ 200,
                  decoration: BoxDecoration(
                      border: Border.all(),
                      image: DecorationImage(image: NetworkImage(response.data!.data![1].avatar.toString()), fit: BoxFit.contain)),
                  child: Center(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(response.data!.data![1].firstName.toString(), textAlign: TextAlign.center),
                      Text(response.data!.data![1].lastName.toString(), textAlign: TextAlign.center),
                      Text(response.data?.data?[1].email ?? '', textAlign: TextAlign.center),
                    ],
                  ))),
            );
          } else {
            return Text("");
          }
        },
      ),
    );
  }
}

Future<DataResponse> getData() async {
  var url = Uri.parse('https://reqres.in/api/users');
  var response = await http.get(url);
  print('Response status:${response.statusCode}');
  if (response.statusCode == 200) {
    print('Response status:${response.body}');
  }
  final data = jsonDecode(response.body);
  var dataResponse = DataResponse.fromJson(data);
  print('dataResponse==>${dataResponse.page}');
  return dataResponse;
}
