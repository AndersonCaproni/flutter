import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.blue)),
      home: const PageCount(),
    );
  }
}

class PageCount extends StatefulWidget {
  const PageCount({super.key});

  @override
  State<PageCount> createState() => _PageCount();
}

class _PageCount extends State<PageCount> {
  int _contador = 0;

  void _incrementCounter() {
    setState(() {
      _contador++;
    });
  }

  void _decrementCounter() {
    setState(() {
      _contador--;
    });
  }

  void _zerarCounter(){
    setState(() {
      _contador = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Contador de Cliques"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Você clicou no botão'),
            Text(
              '$_contador',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: 
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: _incrementCounter,
            tooltip: 'Increment',
            child: const Icon(Icons.add),
          ),
          SizedBox(width: 16), // Espaçamento entre os botões
          FloatingActionButton(
            onPressed:  _decrementCounter,
            tooltip: 'Decrement',
            child: const Icon(Icons.remove),
          ),
          SizedBox(width: 16), // Espaçamento entre os botões
          FloatingActionButton(
            onPressed:  _zerarCounter,
            tooltip: 'Reset',
            child: const Icon(Icons.refresh),
          ),
        ],
      ),
    );
  }
}
