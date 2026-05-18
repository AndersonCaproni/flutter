import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Trabalhando com Layouts',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Container(
        // Widget usado para compor outros widgets
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(color: Colors.green, width: 100, height: 100),
                SizedBox(height: 20),
                Container(color: Colors.orange, width: 100, height: 100),
                SizedBox(height: 20),
                Container(color: Colors.purple, width: 100, height: 100),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image(
                  image: NetworkImage(
                    'https://cdn-icons-png.flaticon.com/512/5968/5968267.png',
                  ),
                  width: 100,
                  height: 100,
                ),
                SizedBox(width: 20),
                Image(
                  image: NetworkImage(
                    'https://cdn-icons-png.flaticon.com/512/5968/5968242.png',
                  ),
                  width: 100,
                  height: 100,
                ),
                SizedBox(width: 20),
                Image(
                  image: NetworkImage(
                    'https://cdn-icons-png.flaticon.com/512/1199/1199124.png ',
                  ),
                  width: 90,
                  height: 90,
                  
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
