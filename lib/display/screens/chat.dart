// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_challenges/display/widgets/app_scaffold.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

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
  List<Map<String, String>> _messages = [];
  final TextEditingController _controller = TextEditingController();
  late GenerativeModel _model;
  bool _isConnected = true;
  static const int maxContextMessages = 10;

  Future<void> _checkConnectivity() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    setState(() {
      _isConnected = connectivityResult != ConnectivityResult.none;
    });
  }

  Future<void> _updateConnectivityStatus(
      List<ConnectivityResult> result) async {
    setState(() {
      _isConnected =
          result.isNotEmpty && result.first != ConnectivityResult.none;
    });
    print('Connectivity changed: $_isConnected');
  }

  Future<void> _loadMessages() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedMessages = prefs.getString('chat_messages');
    if (savedMessages != null) {
      setState(() {
        // Convierte cada elemento de la lista decodificada en Map<String, String>
        _messages = List<Map<String, String>>.from(
          json.decode(savedMessages).map(
                (item) => Map<String, String>.from(item),
              ),
        );
      });
      print('Mensajes cargados: $_messages');
    } else {
      print('No hay mensajes guardados');
    }
  }

  @override
  void initState() {
    super.initState();
    _model = GenerativeModel(
      model: 'gemini-1.5-flash-latest',
      apiKey:
          'AIzaSyADl4iRQDNbimyFNgYJaFUvb-HTtk58Pyk', // Reemplaza con tu clave API
    );
    _loadMessages(); // Cargar los mensajes guardados al iniciar
    _checkConnectivity(); // Verificar conectividad al iniciar
    Connectivity().onConnectivityChanged.listen(_updateConnectivityStatus);
  }

  Future<void> _saveMessages() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String encodedMessages = json.encode(_messages);
    await prefs.setString('chat_messages', encodedMessages);
    print('Mensajes guardados: $_messages');
  }

  Future<void> sendMessage(String message) async {
    setState(() {
      _messages.add({'user': message}); // Agrega el mensaje del usuario
    });
    _saveMessages(); // Guarda el historial actualizado

    try {
      // Prepara el contexto a enviar al modelo
      final List<Content> content = [];

      // Agrega los mensajes anteriores al contexto, respetando el límite
      int start = _messages.length - maxContextMessages < 0
          ? 0
          : _messages.length - maxContextMessages;
      for (int i = start; i < _messages.length; i++) {
        final message = _messages[i];
        if (message.containsKey('user')) {
          content.add(Content.text('Usuario: ${message['user']}'));
        } else {
          content.add(Content.text('Bot: ${message['bot']}'));
        }
      }

      // Agrega el mensaje actual del usuario
      content.add(Content.text('Usuario: $message'));

      // Genera una respuesta desde el modelo de Google Gemini
      final response = await _model.generateContent(content);

      // Muestra la respuesta del chatbot
      setState(() {
        _messages.add({
          'bot': response.text ?? 'No response available.'
        }); // Respuesta del bot
      });
      _saveMessages(); // Guarda el historial actualizado con la respuesta del bot
    } catch (error) {
      setState(() {
        _messages.add({'bot': 'Error: No se pudo obtener una respuesta.'});
      });
      _saveMessages(); // Guarda el historial incluso si ocurre un error
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
              reverse:
                  false, // Cambiado a false para mostrar los mensajes en orden correcto
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isUser = message.containsKey('user');
                final messageText = isUser
                    ? message['user']!
                    : message['bot']!.replaceFirst('Bot: ', '');
                return ListTile(
                  title: Align(
                    alignment:
                        isUser ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isUser
                            ? const Color.fromARGB(255, 82, 82, 82)
                            : const Color.fromARGB(255, 153, 213,
                                155), // Fondo negro para el usuario, blanco para el bot
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        messageText,
                        style: TextStyle(
                          color: isUser
                              ? Colors.white
                              : Colors
                                  .black, // Texto blanco para el usuario, negro para el bot
                        ),
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
                  onPressed: _isConnected
                      ? () {
                          if (_controller.text.isNotEmpty) {
                            sendMessage(_controller.text);
                            _controller.clear();
                          }
                        }
                      : null,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
