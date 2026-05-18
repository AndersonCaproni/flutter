import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    //cria a propriedade GoRouter
    final GoRouter _router = GoRouter(
      routes: [
        GoRoute(path: "/", builder: (context, state) => const PrimeiraPagina()),
        GoRoute(
          path: "/segunda",
          builder: (context, state) => const SegundaPagina(),
        ),
      ],
    );
    // gerenciador de rotas
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      //parâmetro obrigatório que define o gerenciador de rotas _router
      routerConfig: _router,
      title: 'Exemplo Go Router',
    );
  }
}

class PrimeiraPagina extends StatelessWidget {
  const PrimeiraPagina({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tela Inicial')),
      body: Center(
        child: ElevatedButton(
          //ao tap no botão, navega para a rota /segunda
          onPressed: () => context.go("/segunda"),
          child: const Text('Ir para a segunda página'),
        ),
      ),
    );
  }
}

class SegundaPagina extends StatelessWidget {
  const SegundaPagina({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Segunda página')),
      body: Center(
        child: ElevatedButton(
          //ao tap no botão, navega para a rota / (inicial)
          onPressed: () => context.go("/"),
          child: const Text('Ir para a página Inicial'),
        ),
      ),
    );
  }
}
