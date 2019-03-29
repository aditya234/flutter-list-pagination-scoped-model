import 'package:flutter/material.dart';
import 'package:flutter_listeners_test/photo_list_scoped_model.dart';
import 'package:flutter_listeners_test/photo_list_stream.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Photo Streamer',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
//      home: PhotoListStream(),
      home: PhotoListScopedModel(),
    );
  }
}
