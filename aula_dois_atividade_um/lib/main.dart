import "package:flutter/material.dart";
import 'dart:math';

void main() {
  runApp(
    MaterialApp(home: const Quadrado(), debugShowCheckedModeBanner: false),
  );
}

class Quadrado extends StatefulWidget {
  const Quadrado({super.key});

  @override
  State<Quadrado> createState() => _Quadrado();
}

class _Quadrado extends State<Quadrado> {
  final Random random = Random();

  Color cor = Colors.blue;

  Color gerarCorAleatoria() {
    int hex = random.nextInt(0xFFFFFF);
    return Color(0xFF000000 | hex);
  }

  void _mudarCor() {
    setState(() {
      cor = gerarCorAleatoria();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          'Mudando a Cor',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(width: 200, height: 200, color: cor),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
              ),
              onPressed: _mudarCor,
              child: const Text(
                'Mudar a Cor',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
