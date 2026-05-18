import "package:flutter/material.dart";

void main() {
  runApp(
    MaterialApp(
      home: const IMC(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(hintColor: Colors.blue, primaryColor: Colors.white),
    ),
  );
}

class IMC extends StatefulWidget {
  const IMC({super.key});

  @override
  State<IMC> createState() => _IMC();
}

class _IMC extends State<IMC> {
  var txtAltura = TextEditingController();
  var txtPeso = TextEditingController();

  late double valorPeso;
  late double valorAltura;
  String _result = ' ';
  double imc = 0;

  @override
  Widget build(BuildContext context) {
    return (Scaffold(
      appBar: AppBar(
        title: const Text(
          'Calculadora de IMC',
          style: TextStyle(color: Colors.white),
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: TextField(
                  controller: txtAltura,
                  decoration: const InputDecoration(
                    labelText: 'Digite sua Altura',
                    labelStyle: TextStyle(color: Colors.black),
                    border: OutlineInputBorder(),
                  ),
                  style: const TextStyle(color: Colors.black, fontSize: 25.0),
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: TextField(
                  controller: txtPeso,
                  // ignore: prefer_const_constructors
                  decoration: InputDecoration(
                    labelText: 'Digite seu Peso',
                    labelStyle: const TextStyle(color: Colors.black),
                    border: const OutlineInputBorder(),
                  ),
                  style: const TextStyle(color: Colors.black, fontSize: 25.0),

                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                ),
              ),
              Center(
                child: FittedBox(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 50,
                        vertical: 20,
                      ),
                    ),
                    onPressed: _calculaIMC,
                    child: const Text(
                      'Calcular',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8.0),
                alignment: Alignment.center,
                child: Text('O seu IMC é de $_result'),
              ),
            ],
          ),
        ],
      ),
    ));
  }

  void _calculaIMC() {
    valorPeso = double.parse(txtPeso.text);

    valorAltura = double.parse(txtAltura.text);

    imc = valorPeso / (valorAltura * valorAltura);
    
    imc = double.parse(imc.toStringAsFixed(2));

    setState(() {
      if (imc < 18.5) {
        _result = '$imc - Magreza';
      } else if (imc < 25) {
        _result = '$imc - Normal';
      } else if (imc < 30) {
        _result = '$imc - Sobrepeso';
      } else if (imc < 35) {
        _result = '$imc - Obesidade Grau I';
      } else if (imc < 40) {
        _result = '$imc - Obesidade Grau II';
      } else {
        _result = '$imc - Obesidade Grau III';
      }
    });
  }
}
