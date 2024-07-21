import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class ReadOfflineAudio extends StatefulWidget{
  final String link;
  final Function(String) deleteDatabase;

  const ReadOfflineAudio({super.key, required this.link, required this.deleteDatabase});

  @override
  State<StatefulWidget> createState() {
    return _ReadOfflineAudioState();
  }
}

class _ReadOfflineAudioState extends State<ReadOfflineAudio> {

  bool isLoadingSuccess = true;
  AudioPlayer audioPlayer = AudioPlayer();
  late AudioCache audioCache;
  bool isPlaying = false;
  double playbackSpeed = 1.0;
  double progress = 0.0;
  double duration = 0.0;

  @override
  void initState() {
    super.initState();


    audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
      setState(() {
        isPlaying = state == PlayerState.playing;
      });
      if (state == PlayerState.paused ||
          state == PlayerState.completed) {
        setState(() {
          isPlaying = false;
        });
      }
    });

    audioPlayer.onDurationChanged.listen((Duration duration) {
      setState(() {
        this.duration = duration.inMilliseconds.toDouble();
        Logger logger = Logger();
        logger.i('duration: $duration');
        //logger.i('duration 2: ${_contentStoryAudioViewModel.getDuration()}');
      });
    });
    audioPlayer.onPositionChanged.listen((Duration position) {
      setState(() {
        progress = position.inMilliseconds.toDouble();
      });
    });

    playMusicFromURL();
    //_readFileContent();
  }

  // delete a file
  Future<void> deleteFile(String filePath) async {
    try {
      final file = File(filePath);

      if (await file.exists()) {
        await file.delete();
        widget.deleteDatabase(filePath);
      } else {
        print('File không tồn tại: $filePath');
      }
    } catch (e) {
      print('Lỗi khi xóa file: $e');
    }
  }

  // read content of .txt file
  Future<File?> _readFileContent() async {
    try {
      final file = File(widget.link);
      return file;
      /*setState(() {
        fileContent = content;
      });*/
    } catch (e) {
      print('Error reading file: $e');
    }
    return null;
  }
  @override
  void dispose() {
    audioPlayer.release();
    audioPlayer.dispose();
    super.dispose();
  }

  Future<Uri> _loadMP3File() async {
    final fileUri = Uri.parse(widget.link);
    return fileUri;
  }

  void playMusicFromURL() async {
    try {
      //File? mp3File = await _readFileContent();
      //Uri mp3Uri = await _loadMP3File();
      //audioCache.load(widget.link);
      //audioPlayer.setSourceDeviceFile(widget.link);
     // await audioPlayer.play(audioCache.load(widget.link));

      await audioPlayer.play(DeviceFileSource(widget.link));
      setState(() {
        isPlaying = true;
      });
    } catch (e) {
      showNotificationDialog("Không tim thấy video!");
    }

  }

  void showNotificationDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Thông báo'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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
    await audioPlayer.seek(currentPosition! + const Duration(seconds: 30));
  }

  void skipBackward() async {
    Duration? currentPosition = await audioPlayer.getCurrentPosition();
    await audioPlayer.seek(currentPosition! - const Duration(seconds: 30));
  }

  void showMyDialog(String chosenSource) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Tải thất bại'),
          content: const Text(
              'Không thể tải video'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  String _formatDuration(int durationInSeconds) {
    String twoDigits(int n) {
      if (n >= 10) return "$n";
      return "0$n";
    }

    Duration duration = Duration(seconds: durationInSeconds);

    int durationHour = duration.inHours;
    int durationMinute = duration.inMinutes.remainder(60);
    int durationSecond = duration.inSeconds.remainder(60);

    String hours = (durationHour).toString();
    String minutes = twoDigits(durationMinute);
    String seconds = twoDigits(durationSecond);


    if (durationHour <= 0 ) {
      if (durationMinute <= 0) {
        return "${seconds}s";
      }
      return "${minutes}m ${seconds}s";
    }
    return "${hours}h ${minutes}m ${seconds}s";
  }

  Color intToColor(int colorValue) {
    return Color(colorValue);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Image.asset('assets/images/back_icon.png'), // Icon bên trái
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.white,),
            onPressed: () async {
              await deleteFile(widget.link);
              if (context.mounted) {
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
      body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/background_home.png'),
                  fit: BoxFit.fill)),
          child: SafeArea(
            child: Container(
                width: double.infinity,
                height: double.infinity,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                      bottomLeft: Radius.circular(0),
                      bottomRight: Radius.circular(0),
                    ),
                    color: Colors.white
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child:  Center(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                            SizedBox(
                            width: 550,
                            ),
                            Slider(
                              value: progress,
                              min: 0.0,
                              max: duration,
                              activeColor: Colors.red,
                              inactiveColor: Colors.grey,
                              thumbColor: Colors.red,
                              onChanged: (double value) {
                                audioPlayer.seek(Duration(milliseconds: value.toInt()));
                              },
                            ),
                          Text(
                          '${_formatDuration((progress / 1000).floor())} / ${_formatDuration((duration / 1000).floor())}',
                          ),
                          Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                              ElevatedButton(
                                onPressed: isPlaying ? pauseMusic : playMusicFromURL,
                                child: Text(isPlaying ? 'Pause' : 'Play'),
                                ),
                              SizedBox(
                                width: 10,
                                ),
                              ElevatedButton(
                                onPressed: stopMusic,
                                child: const Text('Stop'),
                                ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                                IconButton(
                                  onPressed: skipBackward,
                                  icon: const Icon(Icons.replay_30),
                                ),
                                IconButton(
                                  onPressed: skipForward,
                                  icon: const Icon(Icons.forward_30),
                                ),
                              ],
                            ),
                          Slider(
                            value: playbackSpeed,
                            min: 0.25,
                            max: 2.0,
                            divisions: 7,
                            onChanged: (double value) {
                            changePlaybackSpeed(value);
                            },
                          ),
                          Text('Playback Speed: ${playbackSpeed}x'),
                          ],
                          ),
                  ),
                )
            ),
          )),
      ),
    );
  }
}