import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      title: 'Flutter Firebase',
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bibliothèque de films'),
      ),
      body: const SingleChildScrollView(
        child: MoviesInformation(),
      ),
    );
  }
}

class MoviesInformation extends StatefulWidget {
  const MoviesInformation({Key? key}) : super(key: key);
  @override
  _MoviesInformationState createState() => _MoviesInformationState();
}

class _MoviesInformationState extends State<MoviesInformation> {
  final Stream<QuerySnapshot> _moviesStream =
      FirebaseFirestore.instance.collection('Movies').snapshots();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _moviesStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Erreur');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Chargement");
        }

        return Column(
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> movie =
                document.data()! as Map<String, dynamic>;
            return ListTile(
              title: Text(movie['name']),
              subtitle: Text(movie['poster']),
            );
          }).toList(),
        );
      },
    );
  }
}
