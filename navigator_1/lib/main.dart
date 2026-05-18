import 'package:flutter/material.dart';

void main() {
  runApp(
    const MaterialApp(
      title: 'Navegação Básica', 
      home: FirstRoute(),
      debugShowCheckedModeBanner: false,
    )
  );
}

class FirstRoute extends StatelessWidget {
  const FirstRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Primeira rota')),
      body: Center(
        child: ElevatedButton(
          child: const Text('Abrir rota 2'),
          onPressed: () {
            //empilha a próxima tela, definida pela classe SecondRoute
            Navigator.push(
              context,
              //define como a nova tela será criada e qual widget ela exibirá
              MaterialPageRoute(builder: (context) => const SecondRoute()),
            );
          },
        ),
      ),
    );
  }
}

class SecondRoute extends StatelessWidget {
  const SecondRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Segunda rota')),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: const Text('Voltar para a primeira rota'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            const SizedBox(width: 20), // Espaço entre os botões
            ElevatedButton(
              child: const Text('Ir para a Primeira rota'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const FirstRoute()),
                );
              },
            ),
          ],
        )
      ),
    );
  }
}
