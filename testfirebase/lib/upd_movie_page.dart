import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UpdPage extends StatefulWidget {
  final String idMovie;
  final myObject;
  const UpdPage({Key? key, required this.idMovie, this.myObject})
      : super(key: key);

  @override
  _UpdPageState createState() => _UpdPageState(id: idMovie, myObj: myObject);
}

class _UpdPageState extends State<UpdPage> {
  final String id;
  final myObj;

  _UpdPageState({required this.id, this.myObj});

  final nameController = TextEditingController();
  final yearController = TextEditingController();
  final posterController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modification du film'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
                side: const BorderSide(color: Colors.white30, width: 1.5),
              ),
              title: Row(
                children: [
                  const Text('Nom: '),
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                      ),
                      controller: nameController..text = myObj['name'],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
                side: const BorderSide(color: Colors.white30, width: 1.5),
              ),
              title: Row(
                children: [
                  const Text('Année: '),
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                      ),
                      controller: yearController..text = myObj['year'],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
                side: const BorderSide(color: Colors.white30, width: 1.5),
              ),
              title: Row(
                children: [
                  const Text('Poster: '),
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                      ),
                      controller: posterController..text = myObj['poster'],
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
              ),
              onPressed: () {
                FirebaseFirestore.instance
                    .collection('Movies')
                    .doc(id)
                    .update({
                      'name': nameController.value.text,
                      'year': yearController.value.text,
                      'poster': posterController.value.text
                    })
                    .then((value) => print("Film modifié"))
                    .catchError((error) => print(
                        "Erreur lors de la modification du film: $error"));
                Navigator.pop(context);
              },
              child: const Text('Modifier'),
            ),
          ],
        ),
      ),
    );
  }
}
