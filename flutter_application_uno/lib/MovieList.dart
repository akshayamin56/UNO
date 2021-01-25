import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart' show rootBundle;
import 'AppModels.dart';
import 'dart:async';
import 'dart:convert';
import 'VodPlayScreen.dart';
import 'VOD.dart';

class MovieList extends StatefulWidget {
  MovieList({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MovieListState createState() => new _MovieListState();
}

class _MovieListState extends State<MovieList> {
  bool readDataFromHttp = true;
  Future<String> getFileData(String path) async {
    return await rootBundle.loadString(path);
  }

  Future<List<MoviesModel>> _getMoviesData() async {
    var jsonData;
    var url = 'https://demouno.erxproducts.com/movielist';

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

    List<MoviesModel> moviesModels = [];
    for (var u in jsonData) {
      MoviesModel moviesModel = MoviesModel(u["MovieName"], u["Artists"],
          u["PosterImageUrl"], u["ThumbnailimageUrl"], u["MovieUrl"]);
      moviesModels.add(moviesModel);
    }
    return moviesModels;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: Colors.black,
        title: Text('Movies'),
        leading: Icon(Icons.movie),
        bottom: PreferredSize(
            child: Container(
              color: Colors.white,
              height: 2.0,
            ),
            preferredSize: Size.fromHeight(4.0)),
      ),
      body: Container(
        child: FutureBuilder(
          future: _getMoviesData(),
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
                                                '${snapshot.data[index].movieUrl}')),
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
