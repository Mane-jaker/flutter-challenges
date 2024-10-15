import 'package:flutter/material.dart';
import 'package:flutter_challenges/display/screens/chat.dart';
import 'package:flutter_challenges/display/screens/home.dart';
import 'package:flutter_challenges/display/screens/news/news_bottom_bar.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({
    super.key,
    required this.title,
    required this.body,
    this.bottomNavigationBar, // Acepta un BottomNavigationBar opcional
  });

  final String title;
  final Widget body;
  final Widget? bottomNavigationBar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const SizedBox(
              height: 120,
              child: DrawerHeader(
                decoration:
                    BoxDecoration(color: Color.fromARGB(255, 209, 171, 249)),
                child: Text('Menú de Navegación'),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home_rounded),
              title: const Text('Inicio'),
              onTap: () {
                Navigator.push(context, Home.route());
              },
            ),
            ListTile(
              leading: const Icon(Icons.chat_rounded),
              title: const Text('Chat'),
              onTap: () {
                Navigator.push(context, Chat.route());
              },
            ),
          ],
        ),
      ),
      body: body,
      bottomNavigationBar:
          bottomNavigationBar, // Mostrar solo si es proporcionado
    );
  }
}
