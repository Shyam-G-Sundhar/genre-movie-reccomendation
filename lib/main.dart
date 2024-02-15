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
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true),
      title: 'Movie Genre Prediction',
      debugShowMaterialGrid: false,
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _descriptionController = TextEditingController();
  String _prediction = '';

  Future<void> _predictGenre() async {
    String description = Uri.encodeQueryComponent(_descriptionController.text);

    final response = await http.get(
      Uri.parse('http://192.168.9.61:5000/predict?description=$description'),
    );

    if (response.statusCode == 200) {
      setState(() {
        _prediction = json.decode(response.body)['predict'];
      });
    } else {
      throw Exception('Failed to load prediction');
    }
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController desc = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Movie Genre Prediction',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(
                  labelText: 'Enter Movie Description:',
                  labelStyle: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                  )),
              maxLines: 4,
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigoAccent),
              onPressed: () {
                if (_descriptionController.text.isNotEmpty) {
                  _predictGenre();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Enter the Movie Description")),
                  );
                }
              },
              child: Text(
                'Predict',
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.w600),
              ),
            ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Predicted genre:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  width: 8,
                ),
                Text(
                  '$_prediction',
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.indigoAccent,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
