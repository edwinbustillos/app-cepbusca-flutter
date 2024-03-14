import 'package:flutter/material.dart';
import 'package:cepbusca/widgets/cepForm.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CEP',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: const Text(
            'Consulta de CEP',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: const CepForm(),
      ),
    );
  }
}
