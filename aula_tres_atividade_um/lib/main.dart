import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    
    final GoRouter _router = GoRouter(
      //definição das rotas nomeadas
      routes: [
        GoRoute(
          name: "login",
          path: "/",
          builder: (context, state) => const LoginPage(),
          routes: [
            //a rota settings tem um parâmetro "nome"
            GoRoute(
              name: "home",
              path: "home",
              builder: (context, state) => const HomePage(),
            ),
            GoRoute(
              name: "fail",
              path: "fail",
              builder: (context, state) => const FailPage(),
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

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {
  var txtUsuario = TextEditingController();
  var txtSenha = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return (Scaffold(
      appBar: AppBar(
        title: const Text(
          'Login',
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
                  controller: txtUsuario,
                  decoration: const InputDecoration(
                    labelText: 'Digite seu Usuário',
                    labelStyle: TextStyle(color: Colors.black),
                    border: OutlineInputBorder(),
                  ),
                  style: const TextStyle(color: Colors.black, fontSize: 20.0),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                // senha
                child: TextField(
                  controller: txtSenha,
                  decoration: const InputDecoration(
                    labelText: 'Digite sua Senha',
                    labelStyle: TextStyle(color: Colors.black),
                    border: OutlineInputBorder(),
                  ),
                  style: const TextStyle(color: Colors.black, fontSize: 20.0),
                  obscureText: true,
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
                    onPressed: _validarLogin,
                    child: const Text(
                      'Login',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ));
  }

  void _validarLogin() {
    if (txtUsuario.text == "aula" && txtSenha.text == "123") {
      context.go("/home");
    } else {
      context.go("/fail");
    }
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Página Inicial',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Text(
          'Bem-vindo à página inicial!',
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}

class FailPage extends StatelessWidget {
  const FailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Falha', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error, color: Colors.red, size: 100),
            SizedBox(height: 20),
            Text(
              'Login ou senha incorretos!',
              style: const TextStyle(fontSize: 24, color: Colors.red),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () => context.go("/"),
                child: const Text('Voltar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
