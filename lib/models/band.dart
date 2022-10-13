import 'package:flutter/material.dart';

class Band {
  String id;
  String name;
  int votes;

  Band({
      required this.id,
      required this.name,
      required this.votes,
    });

  //los sockets respondernan con mapas...

  factory Band.fromMap(Map<String, dynamic> obj)
  {
    return Band(
      id:     obj.containsKey('id')     ? obj['id']      : 'no-id',
      name:   obj.containsKey('name')   ? obj['name']    : 'no-name',
      votes:  obj.containsKey('votes')  ? obj['votes']   : '0',
    );
  }


}
