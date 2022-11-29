import 'package:flutter/material.dart';
import "package:http/http.dart" as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          
          ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  String basarili = "";
  int? ummu;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _onMoneyButtonPressed() {
    final url = "http://127.0.0.1:8000/derda/";
    http.get(Uri.parse(url)).then((response) {
      if (response.statusCode == 200) {
        basarili = "İşlem başarılı";
      }
      _deneme(ummu ?? 20);
    });
  }

  void _deneme(int x) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextButton(
              onPressed: _onMoneyButtonPressed,
              child: const Icon(Icons.money),
            ),
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter $basarili',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), 
    );
  }
}
