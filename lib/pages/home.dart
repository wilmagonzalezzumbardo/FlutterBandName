import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/band.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Band> bands = [
    Band(id: DateTime.now().toString(), name: 'Sentidos Opuestos', votes: 1),
    Band(id: DateTime.now().toString(), name: 'Mecano', votes: 2),
    Band(id: DateTime.now().toString(), name: 'Elton Jonh', votes: 3),
    Band(id: DateTime.now().toString(), name: 'Adam Levine', votes: 4),
  ];
  @override
  Widget build(BuildContext context) {
    final textController = new TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Bandas de mùsica",
          style: TextStyle(color: Colors.black87, fontSize: 25),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: ListView.builder(
        itemCount: bands.length,
        itemBuilder: (BuildContext context, int index) {
          return Dismissible(
            onDismissed: (direction) {
              bands.removeWhere((element) => element.id == bands[index].id);
            },
            key: Key(bands[index].id),
            direction: DismissDirection.startToEnd,
            background: Container(
              padding: EdgeInsets.only(left: 20),
              color: Colors.red,
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Eliminando datos",
                    style: TextStyle(color: Colors.white),
                  )),
            ),
            child: ListTile(
              leading: CircleAvatar(
                child: Text(bands[index].name.substring(0, 2)),
                backgroundColor: Colors.blue[100],
              ),
              title: Text("${bands[index].id} - ${bands[index].name}"),
              trailing: Text("${bands[index].votes}"),
              onTap: () {
                print(bands[index].name);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        elevation: 1,
        onPressed: () {
          if (!Platform.isAndroid) {
            showCupertinoDialog(
                context: context,
                builder: (_) {
                  return CupertinoAlertDialog(
                    title: Text('Nueva banda, registre nombre'),
                    content: CupertinoTextField(
                      controller: textController,
                    ),
                    actions: [
                      CupertinoDialogAction(
                        isDefaultAction: true,
                        child: Text('AgregarIOS'),
                        onPressed: () {
                          if (textController.text.length > 1) {
                            bands.add(new Band(
                                id: DateTime.now().toString(),
                                name: textController.text,
                                votes: 0));
                            setState(() {});
                            Navigator.pop(context);
                          }
                        },
                      ),
                      CupertinoDialogAction(
                        isDestructiveAction: true,
                        child: Text('Cancelar'),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  );
                });
          } else {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text("Nueva banda, nombre: "),
                    content: TextField(
                      controller: textController,
                    ),
                    actions: [
                      MaterialButton(
                          elevation: 5,
                          child: Text("Agregar"),
                          textColor: Colors.blue,
                          onPressed: () {
                            if (textController.text.length > 1) {
                              bands.add(new Band(
                                  id: DateTime.now().toString(),
                                  name: textController.text,
                                  votes: 0));
                              setState(() {});
                              Navigator.pop(context);
                            }
                          }),
                    ],
                  );
                });
          }
        },
      ),
    );
  }
}
