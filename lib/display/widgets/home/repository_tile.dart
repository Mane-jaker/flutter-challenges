import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class RepositoryTile extends StatelessWidget {
  const RepositoryTile({
    super.key,
    required this.text,
    required this.link,
  });

  final String text;
  final String link;

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw 'No se pudo abrir el enlace: $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(text),
      trailing: GestureDetector(
        onTap: () => _launchUrl(link),
        child: const FaIcon(
          FontAwesomeIcons.github,
          color: Colors.black,
        ),
      ),
    );
  }
}
