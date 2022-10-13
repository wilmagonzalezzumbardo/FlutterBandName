import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';

import '../models/band.dart';
import '../services/sockets_services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Band> bands = [];
  /* [
    Band(id: DateTime.now().toString(), name: 'Sentidos Opuestos', votes: 1),
    Band(id: DateTime.now().toString(), name: 'Mecano', votes: 2),
    Band(id: DateTime.now().toString(), name: 'Elton Jonh', votes: 3),
    Band(id: DateTime.now().toString(), name: 'Adam Levine', votes: 4),
  ]; */
  @override
  void initState() {
    // TODO: implement initState
    final providerSocket = Provider.of<SocketService>(context, listen: false);
    //el listen se pone el false, ya que no se requiere redibujar nada cuando se inicia
    providerSocket.socket.on('active-bands', (payload) {
      this.bands = (payload as List).map((e) => Band.fromMap(e)).toList();
      setState(() {});
    });

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    final providerSocket = Provider.of<SocketService>(context, listen: false);
    //el listen se pone el false, ya que no se requiere redibujar nada cuando se inicia
    providerSocket.socket.off('active-bands');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /*
    Map<String, double> dataMap = {
      "Flutter": 5,
      "React": 3,
      "Xamarin": 2,
      "Ionic": 2,
    };
    */
    Map<String, double> dataMap = new Map();
    final List<Color> colorList = [Color.fromARGB(255, 177, 214, 241), Color.fromARGB(255, 90, 133, 175), Color.fromARGB(255, 202, 125, 151), Colors.yellow, Colors.red, Colors.purple ];
    final textController = new TextEditingController();
    final providerSocket = Provider.of<SocketService>(context);
    providerSocket.initConfig();
    this.bands.forEach((element) {
      dataMap.putIfAbsent(element.name, () => element.votes.toDouble());
    });
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Bandas de mùsica",
          style: TextStyle(color: Colors.black87, fontSize: 25),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        actions: [
          Container(
            margin: EdgeInsets.only(right: 10),
            child: /* providerSocket.cEstado == 'onLine'*/ providerSocket
                        .serverStatus ==
                    ServerStatus.onLine
                ? Icon(
                    Icons.check_circle,
                    color: Colors.green,
                  )
                : Icon(
                    Icons.check_circle,
                    color: Colors.red,
                  ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: bands.length,
              itemBuilder: (BuildContext context, int index) {
                return Dismissible(
                  onDismissed: (direction) {
                    /*
                    bands.removeWhere((element) => element.id == bands[index].id);
                    */
                    providerSocket.socket
                        .emit('delete-band', {'id': bands[index].id});
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
                      providerSocket.socket
                          .emit('vote-band', {'id': bands[index].id});
                    },
                  ),
                );
              },
            ),
          ),
          Container(
            width: double.infinity,
            height: 200,
            child: PieChart(
              dataMap: dataMap,
              chartType: ChartType.ring,
              baseChartColor: Colors.grey[300]!,
              colorList: colorList,
            ),
          ),
        ],
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
                            /*
                            bands.add(new Band(
                                id: DateTime.now().toString(),
                                name: textController.text,
                                votes: 0));
                            setState(() {});
                            */
                            providerSocket.socket.emit(
                                'new-band', {'name': textController.text});
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
                              /*
                              bands.add(new Band(
                                  id: DateTime.now().toString(),
                                  name: textController.text,
                                  votes: 0));
                              */
                              providerSocket.socket.emit(
                                  'new-band', {'name': textController.text});
                              /*
                              setState(() {});
                              */
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
