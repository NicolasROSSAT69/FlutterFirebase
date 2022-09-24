import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestore_search/firestore_search.dart';
import 'package:flutter/material.dart';

class SearchMoviePage extends StatefulWidget {
  const SearchMoviePage({Key? key}) : super(key: key);

  @override
  _SearchMoviePageState createState() => _SearchMoviePageState();
}

class _SearchMoviePageState extends State<SearchMoviePage> {
  _SearchMoviePageState();

  List<Map<String, dynamic>> dataListFromSnapshot(QuerySnapshot querySnapshot) {
    return querySnapshot.docs.map((snapshot) {
      return snapshot.data() as Map<String, dynamic>;
    }).toList();
  }

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
    return FirestoreSearchScaffold(
      firestoreCollectionName: 'Movies',
      searchBy: 'name',
      scaffoldBody: const Center(),
      dataListFromSnapshot: dataListFromSnapshot,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final List<Map<String, dynamic>>? dataList = snapshot.data;
          if (dataList!.isEmpty) {
            return const Center(
              child: Text('No Results Returned'),
            );
          }
          return ListView.builder(
              itemCount: dataList.length,
              itemBuilder: (context, index) {
                final data = dataList[index];

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 100,
                            child: data['poster'] != ""
                                ? Image.network(data['poster'])
                                : const Text('Pas d\'image'),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      data['name'],
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text('Année : ${data['year'].toString()}'),
                                    Row(
                                      children: [
                                        for (final categorie
                                            in data['categories'])
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(right: 5),
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
                                        // IconButton(
                                        //   padding: EdgeInsets.zero,
                                        //   constraints: const BoxConstraints(),
                                        //   iconSize: 20,
                                        //   onPressed: () {
                                        //     //addLike(data['id'], data['likes']);
                                        //     //print(data.id);
                                        //   },
                                        //   icon: const Icon(Icons.thumb_up),
                                        // ),
                                        const SizedBox(width: 10),
                                        Text(data['likes'].toString() +
                                            ' likes'),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          // Column(
                          //   children: [
                          //     Padding(
                          //       padding: const EdgeInsets.all(15.0),
                          //       child: IconButton(
                          //         padding: EdgeInsets.zero,
                          //         constraints: const BoxConstraints(),
                          //         iconSize: 30,
                          //         onPressed: () {
                          //           Navigator.of(context).push(
                          //             MaterialPageRoute(
                          //               builder: (BuildContext context) {
                          //                 return UpdPage(
                          //                     idMovie: document.id,
                          //                     myObject: movie);
                          //               },
                          //               fullscreenDialog: true,
                          //             ),
                          //           );
                          //         },
                          //         icon: const Icon(Icons.edit),
                          //       ),
                          //     ),
                          //     Padding(
                          //       padding: const EdgeInsets.all(15.0),
                          //       child: IconButton(
                          //         padding: EdgeInsets.zero,
                          //         constraints: const BoxConstraints(),
                          //         iconSize: 30,
                          //         onPressed: () {
                          //           FirebaseFirestore.instance
                          //               .collection('Movies')
                          //               .doc(document.id)
                          //               .delete()
                          //               .then((value) {
                          //             print('Film supprimé');
                          //           });
                          //         },
                          //         icon: const Icon(Icons.delete),
                          //       ),
                          //     ),
                          //   ],
                          // ),
                        ],
                      ),
                    ),
                  ],
                );
              });
        }

        if (snapshot.connectionState == ConnectionState.done) {
          if (!snapshot.hasData) {
            return const Center(
              child: Text('No Results Returned'),
            );
          }
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
