import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';
import 'main.dart';

void main() => runApp(VideoApp());

class VideoApp extends StatefulWidget {
  final String url;
  VideoApp({Key key, this.url}) : super(key: key);
  @override
  _VideoAppState createState() => _VideoAppState();
}

class _VideoAppState extends State<VideoApp> {
  VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(
      widget.url, //to access its parent class constructor or variable
    );

    _controller.addListener(() {
      setState(() {});
    });
    _controller.setLooping(true); //loop through video
    _controller.initialize(); //initialize the VideoPlayer
    _controller.play();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Video Player',
      home: Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            leading: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
                onPressed: () {
                  _controller.pause();
                  Navigator.pop(context);
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => MyApp()),
                  // );
                }),
          ),
          body: Stack(
            alignment: Alignment.bottomCenter,
            children: <Widget>[
              VideoPlayer(_controller),
              VodControls(controller: _controller),
              VideoProgressIndicator(_controller,
                  allowScrubbing: true, padding: EdgeInsets.all(20.0)),
            ],
          )),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}

class VodControls extends StatelessWidget {
  const VodControls({Key key, this.controller}) : super(key: key);
  final VideoPlayerController controller;

  String _printDuration(Duration duration) {
    if (duration != null) {
      String twoDigits(int n) => n.toString().padLeft(2, "0");
      String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
      String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
      return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
    } else
      return "00:00";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40.0,
      //width: 150.0,
      color: Colors.transparent,
      margin: EdgeInsets.fromLTRB(20, 50, 20, 50),
      child: Row(children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
              width: 200.0,
              color: Colors.transparent,
              child: Row(
                children: [
                  IconButton(
                      icon: Icon(
                        controller.value.isPlaying
                            ? Icons.pause
                            : Icons.play_arrow,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        controller.value.isPlaying
                            ? controller.pause()
                            : controller.play();
                      }),
                  Text(
                    _printDuration(controller.value.position) +
                        ' / ' +
                        _printDuration(controller.value.duration),
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white),
                  )
                ],
              )),
        ),
        Spacer(),
        Align(
          alignment: Alignment.centerRight,
          child: Container(
            width: 200.0,
            color: Colors.transparent,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                    icon: Icon(
                      Icons.volume_up,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      print('volume');
                    }),
                IconButton(
                    icon: Icon(
                      Icons.fullscreen,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      print('full screen');
                    })
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
