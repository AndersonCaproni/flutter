//pacote para acessar a API e converter o JSON
import 'dart:convert';

import 'package:flutter/material.dart';
//pacote para fazer requisições HTTP
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Conversor de Moeda',
      home: const HomePage(),
    );
  }
}

//tela inicial do aplicativo
//StatefulWidget porque a interface vai mudar quando o resultado for exibido
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  //método que cria o estado da tela
  State<HomePage> createState() => _HomePageState();
}

//estado da tela inicial
class _HomePageState extends State<HomePage> {
  //Controller do campo de texto
  final TextEditingController _valorController = TextEditingController();

  //Texto do resultado
  String _resultado = '';

  //método para acessar a API e converter o valor
  //Future significa que a função é assíncrona e pode levar um tempo
  Future<void> converterMoeda() async {
    //url da API para obter a cotação do dólar. A API retorna um JSON com a cotação atual do dólar em relação ao real.
    final url = Uri.parse(
      'https://economia.awesomeapi.com.br/json/last/USD-BRL',
    );

    //requisição GET para a API
    final response = await http.get(url);

    //Verifica se a requisição deu certo
    if (response.statusCode == 200) {
      //Converte JSON para objeto Dart
      final dados = json.decode(response.body);

      //Obtém a cotação do dólar
      //USDBRL é a chave do JSON que contém a cotação do dólar em relação ao real. Bid é o valor de compra do dólar.
      double cotacao = double.parse(dados['USDBRL']['bid']);

      //Obtém o valor digitado
      double valor = double.parse(_valorController.text);

      //Realiza a conversão
      double convertido = valor * cotacao;

      //Atualiza a interface
      setState(() {
        _resultado = 'Valor em reais: R\$ ${convertido.toStringAsFixed(2)}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Conversor de Moeda')),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            TextField(
              controller: _valorController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Valor em dólar',
                border: OutlineInputBorder(),
              ),
            ),
            //Espaçamento entre o campo de texto e o botão
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: converterMoeda,
              child: const Text('Converter'),
            ),

            const SizedBox(height: 30),

            Text(
              _resultado,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}