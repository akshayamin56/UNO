import 'package:flutter/material.dart';
import 'AudioBookList.dart';
import 'MovieList.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter layout demo',
      home: Scaffold(
        appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.menu),
              color: Colors.white,
              onPressed: () {},
            ),
            title: Text('UNO'),
            actions: [
              IconButton(icon: Icon(Icons.favorite), onPressed: () {}),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: IconButton(
                  icon: Icon(Icons.search),
                  color: Colors.white,
                  onPressed: () {},
                ),
              )
            ],
            backgroundColor: Colors.black87),
        body: Column(
          children: <Widget>[
            Expanded(child: MovieList()),
            Expanded(child: AudioBookList())
          ],
        ),
        // body: Center(
        //   child: HomePage(),
        // ),
      ),
    );
  }
}
