import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Busca CEP',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _cep = TextEditingController();
  final _bairro = TextEditingController();
  final _cidade = TextEditingController();
  final _uf = TextEditingController();
  final _complemento = TextEditingController();
  final _logradouro = TextEditingController();
  final _estado = TextEditingController();
  final _regiao = TextEditingController();

  String _mensagem = '';
  bool _sucesso = false;
  bool _carregando = false;

  final _cepMask = MaskTextInputFormatter(
    mask: '#####-###',
    filter: {'#': RegExp(r'[0-9]')},
  );

  Future<void> _buscarEndereco() async {
    final cep = _cepMask.getUnmaskedText();
    if (cep.length != 8) return;

    setState(() {
      _carregando = true;
      _mensagem = '';
    });

    try {
      final response = await http.get(Uri.parse('https://viacep.com.br/ws/$cep/json/'));

      if (response.statusCode == 200) {
        final dados = json.decode(response.body);

        if (dados.containsKey('erro')) {
          setState(() {
            _mensagem = 'CEP não encontrado';
            _sucesso = false;
            _bairro.clear();
            _cidade.clear();
            _uf.clear();
            _complemento.clear();
            _logradouro.clear();
            _estado.clear();
            _regiao.clear();
          });
          return;
        }

        setState(() {
          _logradouro.text = dados['logradouro'] ?? '';
          _bairro.text = dados['bairro'] ?? '';
          _cidade.text = dados['localidade'] ?? '';
          _uf.text = dados['uf'] ?? '';
          _complemento.text = dados['complemento'] ?? '';
          _estado.text = dados['estado'] ?? '';
          _regiao.text = dados['regiao'] ?? '';
          _mensagem = 'Endereço encontrado';
          _sucesso = true;
        });
      }
    } catch (_) {
      setState(() {
        _mensagem = 'Erro de conexão';
        _sucesso = false;
      });
    } finally {
      setState(() => _carregando = false);
    }
  }

  @override
  void dispose() {
    for (final c in [_cep, _bairro, _cidade, _uf, _complemento, _logradouro, _estado, _regiao]) {
      c.dispose();
    }
    super.dispose();
  }

  Widget _campo(String label, TextEditingController controller, {bool readOnly = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        readOnly: readOnly,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: readOnly ? Colors.grey.shade50 : Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text('Busca CEP'),
        centerTitle: true,
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            
            TextField(
              controller: _cep,
              keyboardType: TextInputType.number,
              inputFormatters: [_cepMask],
              onChanged: (_) {
                if (_cepMask.getUnmaskedText().length == 8) _buscarEndereco();
              },
              decoration: InputDecoration(
                labelText: 'CEP',
                hintText: '00000-000',
                filled: true,
                fillColor: Colors.white,
                prefixIcon: const Icon(Icons.location_on_rounded, color: Colors.indigo),
                suffixIcon: _carregando
                    ? const Padding(
                        padding: EdgeInsets.all(14),
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      )
                    : null,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),

            if (_mensagem.isNotEmpty)
              Container(
                margin: const EdgeInsets.only(top: 10),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: _sucesso ? Colors.green.shade50 : Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: _sucesso ? Colors.green.shade200 : Colors.red.shade200,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _sucesso ? Icons.check_circle_rounded : Icons.error_rounded,
                      size: 16,
                      color: _sucesso ? Colors.green.shade700 : Colors.red.shade700,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      _mensagem,
                      style: TextStyle(
                        color: _sucesso ? Colors.green.shade700 : Colors.red.shade700,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 20),

            _campo('Região', _regiao, readOnly: true),
            _campo('Estado', _estado, readOnly: true),

            Row(
              children: [
                SizedBox(
                  width: 80,
                  child: _campo('UF', _uf, readOnly: true),
                ),
                const SizedBox(width: 10),
                Expanded(child: _campo('Cidade', _cidade, readOnly: true)),
              ],
            ),

            _campo('Bairro', _bairro),
            _campo('Logradouro', _logradouro),
            _campo('Complemento', _complemento),
          ],
        ),
      ),
    );
  }
}