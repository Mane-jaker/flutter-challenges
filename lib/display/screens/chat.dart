import 'package:flutter/material.dart';
import 'package:flutter_challenges/display/widgets/app_scaffold.dart';

class Chat extends StatefulWidget {
  const Chat({super.key});

  static Route route() {
    return MaterialPageRoute(
      builder: (context) => const Chat(),
    );
  }

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final List<String> _messages = []; // Lista que almacenará los mensajes
  final TextEditingController _controller = TextEditingController(); // Controlador del TextField

  void _sendMessage() {
    final String message = _controller.text;

    if (message.isNotEmpty) {
      setState(() {
        _messages.insert(0, message); // Agrega el mensaje al inicio de la lista
      });
      _controller.clear(); // Limpia el campo de texto
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Chat',
      body: Column(
        children: [
        
          Expanded(
            child: ListView.builder(
              reverse: true, 
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blueAccent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _messages[index],
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          // Campo de texto y botón de enviar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Escribe un mensaje...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage, // Envía el mensaje al presionar
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
