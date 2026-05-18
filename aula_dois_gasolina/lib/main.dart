import "package:flutter/material.dart";

void main() {
  runApp(MaterialApp(
    home: const Combustivel(),
    theme: ThemeData(hintColor: Colors.green, primaryColor: Colors.white),
  ));
}

class Combustivel extends StatefulWidget {
  const Combustivel({super.key});

  @override
  State<Combustivel> createState() => _Combustivel();
}

class _Combustivel extends State<Combustivel> {
  var txtEtanol =
      TextEditingController(); //controller que receberá o preço do etanol
  var txtGasolina =
      TextEditingController(); //controller que recebrá o preço da gasolina

  late double
      precoGasolina; //variável para armazenar o preço da gasolina fornecido
  late double
      precoEtanol; // variável para armazenar o preço do etanol fornecido
  String _result =
      ' '; // variável para armazenar o resultado do melhor combustível
  double proporcao = 0; // variável para armazenar o valor da proporção de 70%
  //entre os preços da gasolina e do etanol

  @override
  Widget build(BuildContext context) {
    return (Scaffold(
      appBar: AppBar(
        title: const Text('Com que abastecer?'),
      ),
      body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Icon(
          Icons.attach_money,
          color: Colors.lightBlue,
          size: 180.0,
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextField(
                controller: txtGasolina,
                decoration: const InputDecoration(
                  labelText: 'Preço da gasolina',
                  labelStyle: TextStyle(
                    color: Colors.green,
                  ),
                  border: OutlineInputBorder(),
                ),
                style: const TextStyle(color: Colors.green, fontSize: 25.0),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextField(
                controller: txtEtanol,
                // ignore: prefer_const_constructors
                decoration: InputDecoration(
                  labelText: 'Preço do Etanol',
                  labelStyle: const TextStyle(color: Colors.green),
                  border: const OutlineInputBorder(),
                ),
                style: const TextStyle(color: Colors.green, fontSize: 25.0),

                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
              ),
            ),
            Center(
              child: FittedBox(
                child: FloatingActionButton(
                  backgroundColor: Colors.lightGreen,
                  onPressed: _verificaCombustivel,
                  child: const Text('OK'),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8.0),
              alignment: Alignment.center,
              child: Text('O melhor combustível é $_result'),
            ),
          ],
        ),
      ]),
    ));
  }

  void _verificaCombustivel() {
    precoGasolina =
        double.parse(txtGasolina.text); //connverte o valor fornecido
    //para double
    precoEtanol = double.parse(txtEtanol.text);
    proporcao = precoGasolina * 0.7; //calcula a proporção dos valores

    //chama setState para mudar o estado do Widget
    setState(() {
      if (precoEtanol <= proporcao) {
        _result = 'Etanol';
      } else {
        _result = 'Gasolina';
      }
    });
  }
}