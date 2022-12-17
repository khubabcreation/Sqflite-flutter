import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sqflite_again/DbHandler.dart';
import 'package:sqflite_again/NotesModel.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DbHelper? helper;
  late Future<List<NotesModel>> notesList;

  @override
  void initState() {
    super.initState();
    helper = DbHelper();
    loadData();
  }

  loadData() async {
    notesList = helper!.getNotesList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: FutureBuilder(
                  future: notesList,
                  builder: (context, AsyncSnapshot<List<NotesModel>> snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        reverse: true,
                        shrinkWrap: true,
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              helper!.update(NotesModel(
                                  id: snapshot.data![index].id!,
                                  title: 'update kar ',
                                  email: 'xskhubab@gmail.com',
                                  age: 11,
                                  description: 'no descriptioon'));
                              setState(() {
                                notesList = helper!.getNotesList();
                              });
                            },
                            child: Dismissible(
                              onDismissed: (DismissDirection direction) {
                                setState(() {
                                  helper!.delete(snapshot.data![index].id!);
                                  notesList = helper!.getNotesList();
                                  snapshot.data!.remove(snapshot.data![index]);
                                });
                              },
                              direction: DismissDirection.endToStart,
                              key: ValueKey<int>(snapshot.data![index].id!),
                              background: Container(
                                color: Colors.red,
                                child: Icon(Icons.delete_forever),
                              ),
                              child: SizedBox(
                                height: 100,
                                width: double.infinity,
                                child: Card(
                                  child: Text(
                                      snapshot.data![index].title.toString()),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    } else {
                      return CircularProgressIndicator();
                    }
                  }),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          helper!
              .insert(NotesModel(
                  title: 'khubab docs',
                  email: 'xskhubab@gmail.com',
                  age: 22,
                  description: 'meo meo'))
              .then((value) {
            print('data addeed');
            setState(() {
              notesList = helper!.getNotesList();
            });
          }).onError((error, stackTrace) {
            print(error.toString());
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
