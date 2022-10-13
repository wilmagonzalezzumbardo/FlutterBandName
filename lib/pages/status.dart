import 'dart:convert';

import 'package:fl_11_bandname/services/sockets_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StatusPage extends StatelessWidget {
  const StatusPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final providerSocket = Provider.of<SocketService>(context);
    //providerSocket.initConfig();

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Estado del servidor => ",
              style: TextStyle(fontSize: 20),
            ),
            Text(
              "${providerSocket.serverStatus1}",
              style: TextStyle(fontSize: 20),
            ),
            Text(
              "${providerSocket.cMensaje}",
              style: TextStyle(fontSize: 20),
            ),
            Text(
              "${providerSocket.cNombre}",
              style: TextStyle(fontSize: 20),
            ),
            Text(
              "${providerSocket.cMensaje2}",
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.access_alarm),
        onPressed: () {
          final Map<String,dynamic> mapa = {'nombre': 'Wilma', 'mensaje':'Este es el mensaje 1'};
          providerSocket.socket.emit("emitir-nuevo-mensaje",  {'nombre': 'hola', 'mensaje':'Mensaje1'});
          print("hola");
        },
      ),
    );
  }
}
