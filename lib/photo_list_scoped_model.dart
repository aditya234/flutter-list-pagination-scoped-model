import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_listeners_test/photo.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;

class PhotoListScopedModel extends StatefulWidget {
  @override
  _PhotoListScopedModelState createState() => _PhotoListScopedModelState();
}

class _PhotoListScopedModelState extends State<PhotoListScopedModel> {
  PhotoModel model = PhotoModel();
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset) {
        print('Controller at bottom');
        model.fetchPhotos();
      }
    });
    model.addListener(() {
      print('Change Occured');
    });
    model.fetchPhotos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Photo Streams"),
      ),
      body: ScopedModel(
        model: model,
        child: Center(
          child: ScopedModelDescendant<PhotoModel>(
            builder: (context, child, modelInstance) {
              print('LENGTH IN BUILD - ${model.photoList.length}');
              if (model.photoList.length > 0) {
                return ListView(
                  controller: scrollController,
                  children: _getChildList(model.photoList),
                );
              }
              return Container();
            },
          ),
        ),
      ),
    );
  }

  Widget _makeElement(Photo photo) {
    return Container(
        padding: EdgeInsets.all(5.0),
        child: Padding(
          padding: EdgeInsets.only(top: 200.0),
          child: Column(
            children: <Widget>[
              Image.network(photo.url, width: 150.0, height: 150.0),
              Text(photo.title),
            ],
          ),
        ));
  }

  _getChildList(List<Photo> photoList) {
    List<Widget> widgetList = [];
    photoList.forEach((listElement) {
      widgetList.add(_makeElement(listElement));
    });
    if (widgetList.length > 0) {
      widgetList.add(Center(
        child: CircularProgressIndicator(),
      ));
    }
    return widgetList;
  }
}

//Scoped model
class PhotoModel extends Model {
  List<Photo> photoList = [];

  fetchPhotos() async {
    String url = "https://jsonplaceholder.typicode.com/photos";
    var client = http.Client();

    var response = await client.get(Uri.parse(url));
    print('RESPONSE - ${response.body.length}');
    List pList = json.decode(response.body);
    int listLength = photoList.length;
    print('CURRENT LENGTH - $listLength');
    for (int index = listLength; index < (listLength + 5); index++) {
      photoList.add(Photo.fromJsonMap(pList[index]));
    }
    notifyListeners();
  }
}
