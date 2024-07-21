import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class AudioPlayerPage extends StatefulWidget {
  @override
  _AudioPlayerPageState createState() => _AudioPlayerPageState();
}

class _AudioPlayerPageState extends State<AudioPlayerPage> {
  late AudioPlayer audioPlayer;
  bool isPlaying = false;
  double playbackSpeed = 1.0;
  double progress = 0.0;
  double duration = 0.0;

  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer();
    audioPlayer.onDurationChanged.listen((Duration duration) {
      setState(() {
        this.duration = duration.inMilliseconds.toDouble();
      });
    });
    audioPlayer.onPositionChanged.listen((Duration position) {
      setState(() {
        progress = position.inMilliseconds.toDouble();
      });
    });
    audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
      setState(() {
        isPlaying = state == PlayerState.playing;
      });
    });
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  void playMusicFromURL() async {
    String url =
        'https://ia800308.us.archive.org/14/items/ThanBiKhoiPhucTuQuyHoBatDauTH/002-ThanBiKhoiPhucTuQuyHoBatDauTH.mp3';
    await audioPlayer.play(UrlSource(url));
    setState(() {
      isPlaying = true;
    });
  }

  void pauseMusic() async {
    await audioPlayer.pause();
    setState(() {
      isPlaying = false;
    });
  }

  void stopMusic() async {
    await audioPlayer.stop();
    setState(() {
      isPlaying = false;
      progress = 0.0;
    });
  }

  void changePlaybackSpeed(double speed) async {
    await audioPlayer.setPlaybackRate(speed);
    setState(() {
      playbackSpeed = speed;
    });
  }

  void skipForward() async {
    Duration? currentPosition = await audioPlayer.getCurrentPosition();
    await audioPlayer.seek(currentPosition! + Duration(seconds: 30));
  }

  void skipBackward() async {
    Duration? currentPosition = await audioPlayer.getCurrentPosition();
    await audioPlayer.seek(currentPosition! - Duration(seconds: 30));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Audio Player'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: isPlaying ? pauseMusic : playMusicFromURL,
              child: Text(isPlaying ? 'Pause' : 'Play'),
            ),
            ElevatedButton(
              onPressed: stopMusic,
              child: Text('Stop'),
            ),
            Slider(
              value: progress,
              min: 0.0,
              max: duration,
              onChanged: (double value) {
                audioPlayer.seek(Duration(milliseconds: value.toInt()));
              },
            ),
            Text(
              '${(progress / 1000).toStringAsFixed(0)} / ${(duration / 1000).toStringAsFixed(0)} seconds',
            ),
            Slider(
              value: playbackSpeed,
              min: 0.5,
              max: 2.0,
              divisions: 6,
              onChanged: (double value) {
                changePlaybackSpeed(value);
              },
            ),
            Text('Playback Speed: ${playbackSpeed}x'),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: skipBackward,
                  icon: Icon(Icons.replay_30),
                ),
                IconButton(
                  onPressed: skipForward,
                  icon: Icon(Icons.forward_30),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}