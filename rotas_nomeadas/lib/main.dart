import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      title: 'Navegação com rotas nomeadas',
      //define a rota da primeira tela
      initialRoute: '/',
      //nomeando as rotas
      routes: {
        '/': (context) => const FirstScreen(),
        '/segunda': (context) => const SecondScreen(),
      },
    ),
  );
}

class FirstScreen extends StatelessWidget {
  const FirstScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Primeira tela')),
      body: Center(
        child: ElevatedButton(
          child: const Text('Abrir tela 2'),
          onPressed: () {
            //navega para a rota nomeada
            Navigator.pushNamed(context, '/segunda');
          },
        ),
      ),
    );
  }
}

class SecondScreen extends StatelessWidget {
  const SecondScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Segunda tela')),
      body: Center(
        child: ElevatedButton(
          child: const Text('Voltar'),
          onPressed: () {
            //navegar para voltar à rota 1 quando tap
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}
