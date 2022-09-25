import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'add_movie_page.dart';
import 'upd_movie_page.dart';
import 'search_movie_page.dart';

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
      theme: ThemeData.light(),
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
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return const AddPage();
                  },
                  fullscreenDialog: true,
                ),
              );
            },
            icon: const Icon(Icons.add)),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return const SearchMoviePage();
                    },
                    fullscreenDialog: true,
                  ),
                );
              },
              icon: const Icon(Icons.search)),
        ],
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

  void addLike(String docID, int likes) {
    var newLiks = likes + 1;
    try {
      FirebaseFirestore.instance.collection('Movies').doc(docID).update({
        'likes': newLiks,
      }).then((value) {
        print('Like ajouté');
      });
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _moviesStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Erreur');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Chargement ...");
        }

        return Column(
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> movie =
                document.data()! as Map<String, dynamic>;
            return Padding(
              padding: const EdgeInsets.all(10),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    SizedBox(
                      width: 100,
                      child: movie['poster'] != ""
                          ? Image.network(movie['poster'])
                          : const Text('Pas d\'image'),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                movie['name'],
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              Text('Année : ${movie['year'].toString()}'),
                              Row(
                                children: [
                                  for (final categorie in movie['categories'])
                                    Padding(
                                      padding: const EdgeInsets.only(right: 5),
                                      child: Chip(
                                        backgroundColor: Colors.lightBlue,
                                        label: Text(
                                          categorie,
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                    iconSize: 20,
                                    onPressed: () {
                                      addLike(document.id, movie['likes']);
                                    },
                                    icon: const Icon(Icons.thumb_up),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(movie['likes'].toString() + ' likes'),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            iconSize: 30,
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (BuildContext context) {
                                    return UpdPage(
                                        idMovie: document.id, myObject: movie);
                                  },
                                  fullscreenDialog: true,
                                ),
                              );
                            },
                            icon: const Icon(Icons.edit),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            iconSize: 30,
                            onPressed: () {
                              FirebaseFirestore.instance
                                  .collection('Movies')
                                  .doc(document.id)
                                  .delete()
                                  .then((value) {
                                print('Film supprimé');
                              });
                            },
                            icon: const Icon(Icons.delete),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
