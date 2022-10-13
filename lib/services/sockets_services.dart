import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus { onLine, offLine, connecting, wilma, nuevoMensaje }

class SocketService extends ChangeNotifier {
  ServerStatus serverStatus = ServerStatus.onLine;
  late IO.Socket socket;
  String cMensaje = '';
  String cNombre = '';
  String cMensaje2 = '';
  String cEstado = '';

  //constructor, es el inicio de la clase y se va a ejecutar apenas se llame
  SocketService() {
    print("en el constructor");

    this.initConfig();
  }

  ServerStatus get serverStatus1 => this.serverStatus;

  IO.Socket get socket1 => this.socket;

  void initConfig() {
    print("INI en el initConfig");
    this.socket = IO.io('http://192.168.1.80:3001', {
      'transports': ['websocket'],
      'autoConnect': true,
    });
    print("FIN en el initConfig");

    this.socket.on('connect', (_) {
      print(' INI connect');
      socket.emit('mensaje', 'test desde el connect.... del init config');
      this.serverStatus = ServerStatus.onLine;
      print(' FIN connect');
      this.cEstado = 'onLine';
      notifyListeners();
    });
    this.socket.on('disconnect', (_) {
      print('INI desconectado,... del init config');
      this.serverStatus = ServerStatus.offLine;
      print('FIN desconectado,... del init config');
      this.cEstado = 'offLine';
      notifyListeners();
    });

    this.socket.on('emitir-nuevo-mensaje', (payload) {
      print('INI EMITIR NUEVO MENSAJE,... del init config');
      print(payload);
      print(payload['mensaje']);
      print(payload['nombre']);
      print('sockets_services.dart-> emitir-nuevo-mensaje');
      this.serverStatus = ServerStatus.nuevoMensaje;
      this.cMensaje = payload['mensaje'];
      this.cNombre = payload['nombre'];
      print(this.cMensaje);
      print(this.cNombre);
      print('INI EMITIR NUEVO MENSAJE,... del init config');
      if (payload.containsKey('mensaje2')) {
        this.cMensaje2 = payload['mensaje2'];
      } else {
        this.cMensaje2 = "No vino el mensaje2";
      }
      notifyListeners();
    });

    this.socket.on('active-bands', (payload) 
    {
      
    });
  }
}
