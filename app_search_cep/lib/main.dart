import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Buscar CEP',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: const MyHomePage(title: 'Buscar CEP'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final cepController = TextEditingController();

  late String logradouro = '', bairro = '', cidade = '', estado = '';

  _searchCEP() {
    
    String cep = cepController.text;
    if (cep == '') {
      return;
    }
    
    _getApi(cep).then((value) {
      setState(() {
        logradouro = value['logradouro'];
        cidade = value['localidade'];
        bairro = value['bairro'];
        estado = value['uf'];
      });
    });

  }

  Future _getApi(String cep) async {
    final response = await http.get(Uri.parse("https://viacep.com.br/ws/${cep}/json/"));

    var body = jsonDecode(response.body);
    return body;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView (child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                TextField(
                  controller: cepController,
                  decoration: const InputDecoration(labelText: "CEP"),
                  obscureText: false,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                ),
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(top: 10),
                  child: ElevatedButton(
                    onPressed: _searchCEP,
                    child: const Text("Buscar CEP", style: TextStyle(fontSize: 18),),
                  ),
                ),
                const SizedBox(height: 10,),
                Container(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text("Logradouro: ", style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold),),
                          Text((logradouro == '' ? 'Não pesquisado.' : logradouro))
                        ],
                      ),
                      const SizedBox(height: 5,),
                      Row(
                        children: [
                          Text("Bairro: ", style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold),),
                          Text((bairro == '' ? 'Não pesquisado.' : bairro))
                        ],
                      ),
                      const SizedBox(height: 5,),
                      Row(
                        children: [
                          Text("Cidade: ", style: TextStyle(color: Theme.of(context).primaryColor,  fontWeight: FontWeight.bold),),
                          Text((cidade == '' ? 'Não pesquisado.' : cidade))
                        ],
                      ),
                      const SizedBox(height: 5,),
                      Row(
                        children: [
                          Text("Estado: ", style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold),),
                          Text((estado == '' ? 'Não pesquisado.' : estado))
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ]
      ))// This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
