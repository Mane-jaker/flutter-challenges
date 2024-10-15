import 'package:flutter/material.dart';
import 'package:flutter_challenges/core/utils/basic_models.dart';
import 'package:flutter_challenges/display/widgets/app_scaffold.dart';
import 'package:flutter_challenges/display/widgets/home/repository_tile.dart';
import 'package:flutter_challenges/display/widgets/home/student_card.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  static Route route() {
    return MaterialPageRoute(
      builder: (context) => const Home(),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Student> students = [
      Student(
        name: 'Ángel Manuel Bautista Vázquez',
        id: 'Matricula: 213347',
        tel: 'tel:9613599651',
        sms: 'sms:9613599651',
      ),
      Student(
        name: 'Carlos Esteban Rivera Perez',
        id: 'Matricula: 213530',
        tel: 'tel:9613286990',
        sms: 'sms:9613286990',
      ),
      Student(
        name: 'Rogelio Emanuel Roque Morales',
        id: 'Matricula: 213532',
        tel: 'tel:9512198832',
        sms: 'sms:9512198832',
      ),
    ];

    return const AppScaffold(
      title: 'Home',
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ListTile(
              leading: CircleAvatar(
                backgroundImage: AssetImage(
                    'assets/conejo.jpg'), // Ruta de tu imagen en assets
              ),
              title: Text('El papu:'),
              subtitle: Text('Jorge Brandon Chandomi Esponda'),
            ),
            Text(
              'Repository',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            RepositoryTile(
              text: 'Team:',
              link: 'https://github.com/Mane-jaker/flutter-challenges',
            ),
            RepositoryTile(
              text: 'Personal:',
              link:
                  'https://github.com/Mane-jaker/flutter-challenges/tree/mane',
            )
          ],
        ),
      ),
    );
  }
}
