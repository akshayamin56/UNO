import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart' show rootBundle;
import 'AppModels.dart';
import 'dart:async';
import 'dart:convert';
import 'VodPlayScreen.dart';

class AudioBookList extends StatefulWidget {
  AudioBookList({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _AudioBookListState createState() => new _AudioBookListState();
}

class _AudioBookListState extends State<AudioBookList> {
  bool readDataFromHttp = true;
  Future<String> getFileData(String path) async {
    return await rootBundle.loadString(path);
  }

  Future<List<AudioBookModel>> _getAudioBookData() async {
    var jsonData;
    var url = 'https://demouno.erxproducts.com/booklist/AudioBook';

    if (readDataFromHttp) {
      Map<String, String> headers = new HashMap();
      headers.putIfAbsent('Content-Type', () => 'application/json');

      try {
        final response = await http.get(url, headers: headers);

        if (response.statusCode == 200) {
          // If the server did return a 200 OK response,
          // then parse the JSON.
          print(response.headers);
          jsonData = json.decode(response.body);
        } else {
          // If the server did not return a 200 OK response,
          // then throw an exception.
          print("error");
          throw Exception('Failed to json data');
        }
      } on Exception catch (e) {
        print(e.toString());
      }
    }

    List<AudioBookModel> audioBookModels = [];
    for (var u in jsonData) {
      AudioBookModel audioBookModel = AudioBookModel(u["BookName"], u["Author"],
          u["PosterImageUrl"], u["BookImageUrl"], u["TrackUrl"]);
      audioBookModels.add(audioBookModel);
    }
    return audioBookModels;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: Colors.black,
        title: Text('Audio Books'),
        leading: Icon(Icons.music_note),
        bottom: PreferredSize(
            child: Container(
              color: Colors.white,
              height: 2.0,
            ),
            preferredSize: Size.fromHeight(4.0)),
      ),
      body: Container(
        child: FutureBuilder(
          future: _getAudioBookData(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data == null) {
              return Container(child: Center(child: Text("Loading...")));
            } else {
              return Container(
                  margin: EdgeInsets.symmetric(horizontal: 20.0),
                  height: 300.0,
                  child: ListView.builder(
                    padding: EdgeInsets.only(
                        top: 10, bottom: 10, left: 10, right: 10),
                    itemCount: snapshot.data.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                          padding: EdgeInsets.all(10.0),
                          child: Column(
                            children: <Widget>[
                              InkWell(
                                child: Container(
                                    width: 160.0,
                                    height: 200.0,
                                    child: Image.network(
                                        '${snapshot.data[index].thumbnailimageUrl}',
                                        fit: BoxFit.fitWidth)),
                                onTap: () {
                                  print("tapped on container");
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => VideoApp(
                                            url:
                                                '${snapshot.data[index].trackUrl}')),
                                  );
                                },
                              ),
                              Text(
                                '${snapshot.data[index].title}',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white.withOpacity(1.0)),
                              ),
                            ],
                          ));
                    },
                  ));
            }
          },
        ),
      ),
    );
  }
}
