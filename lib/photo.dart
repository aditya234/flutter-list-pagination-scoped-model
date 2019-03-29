class PList {
  List<Photo> photos;

  PList({
    this.photos,
  });

  PList.fromJson(List<dynamic> parsedJson) {
    List<Photo> photos = new List<Photo>();
    print(parsedJson.length);
    parsedJson.forEach((pic){
      photos.add(Photo.fromJsonMap(pic));
    });
  }
}

class Photo {
  final String title;
  final String url;

  Photo.fromJsonMap(Map map)
      : title = map['title'],
        url = map['url'];
}
