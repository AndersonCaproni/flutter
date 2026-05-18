import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    //cria a propriedade GoRouter
    // Antes, não se esqueça de instalar a dependência,
    //executando o comando flutter pub add go_route no terminal

    //criação do objeto GoRouter
    final GoRouter _router = GoRouter(
      //definição das rotas nomeadas
      routes: [
        GoRoute(
          name: "home",
          path: "/",
          builder: (context, state) => const HomePage(),
          routes: [
            //a rota settings tem um parâmetro "nome"
            GoRoute(
              name: "settings",
              path: "settings/:nome",
              builder: (context, state) =>
                  SettingsPage(nome: state.pathParameters["nome"]!),
            ),
          ],
        ),
      ],
    );

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
      title: 'Exemplo Go Router',
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tela Inicial')),
      body: Center(
        child: ElevatedButton(
          //o método goNamed chama uma rota nomeada
          onPressed: () =>
              context.goNamed("settings", pathParameters: {"nome": "Celso"}),
          child: const Text('Ir para a página de Configurações'),
        ),
      ),
    );
  }
}

class SettingsPage extends StatelessWidget {
  final String nome;
  //construtor com parâmetro nome obrigatório
  const SettingsPage({super.key, required this.nome});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //insere o valor do parâmetro nome na barra de título do app
        title: Text(nome),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => context.go("/"),
          child: const Text('Ir para a página Inicial'),
        ),
      ),
    );
  }
}
