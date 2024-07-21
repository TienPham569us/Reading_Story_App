import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:logger/logger.dart';
import 'package:project_login/ViewModels/ContentStoryAudioViewModel.dart';
import 'package:project_login/Views/Components/ContentStoryAudioBottomAppBar.dart';
import 'package:project_login/Views/Components/ContentStoryAudioTopAppBar.dart';
import 'package:provider/provider.dart';

class ContentStoryAudioScreen extends StatefulWidget {
  final String storyTitle;
  final int chap;
  final String dataSource;
  final int pageNumber;
  final String name;

  const ContentStoryAudioScreen({
    super.key,
    required this.storyTitle,
    required this.chap,
    required this.name,
    required this.dataSource,
    required this.pageNumber
  });

  @override
  _ContentStoryAudioScreenState createState() => _ContentStoryAudioScreenState();
}
class _ContentStoryAudioScreenState extends State<ContentStoryAudioScreen> {
  late ContentStoryAudioViewModel _contentStoryAudioViewModel;
  bool isLoadingSuccess = true;
  AudioPlayer audioPlayer = AudioPlayer();
  bool isPlaying = false;
  double playbackSpeed = 1.0;
  double progress = 0.0;
  double duration = 0.0;

  @override
  void initState() {
    super.initState();
    _contentStoryAudioViewModel = Provider.of<ContentStoryAudioViewModel>(context, listen: false);
    _contentStoryAudioViewModel.name = widget.name;

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
        _contentStoryAudioViewModel.setDuration(duration.inSeconds.toInt());
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

    _fetchData();
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  void _fetchData() async {
    await Future.wait([
      _contentStoryAudioViewModel.fetchChapterPagination(
          widget.storyTitle, widget.pageNumber, widget.dataSource, true),
    ]);

    isLoadingSuccess = await _contentStoryAudioViewModel.fetchContentStoryAudio(
        widget.storyTitle, widget.chap, widget.dataSource);

    if (!isLoadingSuccess) {
      showMyDialog(widget.dataSource);
    } else {
      playMusicFromURL();
    }

    await Future.wait([
      _contentStoryAudioViewModel.fetchFormatList(),
    ]);

  }

  void playMusicFromURL() async {
    String url = _contentStoryAudioViewModel.contentStory!.content;

    try {
      await audioPlayer.play(UrlSource(url));

      setState(() {
        isPlaying = true;
      });
    } catch (e) {
      showMyDialog(widget.dataSource);
    }

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

  @override
  Widget build(BuildContext context) {
    return Consumer<ContentStoryAudioViewModel>(
        builder: (context, contentStoryAudioViewModel, _) {
          return Scaffold(
            extendBodyBehindAppBar: true,
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(kToolbarHeight),
              child: ContentStoryAudioTopAppBar(contentStoryAudioViewModel),
            ),
            body: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/background_home.png'),
                      fit: BoxFit.fill
                  )
              ),
              child: SafeArea(
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                      bottomLeft: Radius.circular(0),
                      bottomRight: Radius.circular(0),
                    ),
                    color: intToColor(
                        0xFFFFFFFF
                    ),
                  ),
                  child: contentStoryAudioViewModel.contentStory != null
                      && contentStoryAudioViewModel.contentStory?.content != null
                      ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image(
                              image: NetworkImage(contentStoryAudioViewModel.contentStory!.cover),
                              height: 101,
                              width: 84,
                              errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                return Image.asset(
                                  'assets/images/default_image.png',
                                  height: 101,
                                  width: 84,
                                );
                              },
                            ),
                            SizedBox(
                              width: 550,

                              child: Text(
                                contentStoryAudioViewModel.contentStory!.name,
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                style: const TextStyle(
                                  fontSize: 14,
                                  overflow: TextOverflow.ellipsis,
                                  color: Colors.black,
                                ),
                              ),
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
                      )

                      : const Center(child: CircularProgressIndicator()),
                ),
              ),
            ),
            bottomNavigationBar: _contentStoryAudioViewModel.contentStory != null
                ? ContentStoryAudioBottomAppBar(
                contentStoryAudioViewModel: contentStoryAudioViewModel,
              onChooseChapter: (index, pageNumber) {
                navigateToNewChap(index, pageNumber);
              },
              navigateToNextChap: () {
                navigateToNextChap();
              },
              navigateToPrevChap: () {
                navigateToPrevChap();
              })
                : null
            ,
          );
        }
    );
  }

  void showMyDialog(String chosenSource) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Tải thất bại'),
          content: Text(
              'Không thể tải truyện từ $chosenSource. Tải truyện từ ${_contentStoryAudioViewModel.currentSource} để thay thế'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
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

  void navigateToNextChap() {
    setState(() {
      // fetch next chapter pagination if current chapter is the last item of current chapter pagination
      if (_contentStoryAudioViewModel.currentChapNumber %
          _contentStoryAudioViewModel.chapterPagination.chapterPerPage == 0) {
        _contentStoryAudioViewModel.fetchChapterPagination(
            widget.storyTitle,
            ++_contentStoryAudioViewModel.currentPageNumber,
            _contentStoryAudioViewModel.currentSource,
            true);
      }

      // fetch new content
      _contentStoryAudioViewModel.fetchContentStoryAudio(
          widget.storyTitle,
          ++_contentStoryAudioViewModel.currentChapNumber,
          _contentStoryAudioViewModel.currentSource);
    });
  }

  // navigate to previous chapter
  void navigateToPrevChap() {
    setState(() {
      // fetch previous chapter pagination if current chapter is the first item of current chapter pagination
      if (_contentStoryAudioViewModel.currentChapNumber %
          _contentStoryAudioViewModel.chapterPagination.chapterPerPage == 1) {
        _contentStoryAudioViewModel.fetchChapterPagination(
            widget.storyTitle,
            --_contentStoryAudioViewModel.currentPageNumber,
            _contentStoryAudioViewModel.currentSource,
            true);
      }

      // fetch new content
      _contentStoryAudioViewModel.fetchContentStoryAudio(
          widget.storyTitle,
          --_contentStoryAudioViewModel.currentChapNumber,
          _contentStoryAudioViewModel.currentSource);
    });
  }

  // navigate to a certain chapter
  void navigateToNewChap(int index, int pageNumber) {
    // calculate page and chapter number
    _contentStoryAudioViewModel.currentPageNumber = pageNumber;
    _contentStoryAudioViewModel.currentChapNumber = (pageNumber - 1) *
        _contentStoryAudioViewModel.chapterPagination.chapterPerPage + index + 1;

    // fetch new content
    setState(() {
      _contentStoryAudioViewModel.fetchContentStoryAudio(
          widget.storyTitle,
          _contentStoryAudioViewModel.currentChapNumber,
          _contentStoryAudioViewModel.currentSource);
    });
  }
}
/*Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

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
              min: 0.5,
              max: 2.0,
              divisions: 6,
              onChanged: (double value) {
                changePlaybackSpeed(value);
              },
            ),
            Text('Playback Speed: ${playbackSpeed}x'),
          ],
        ),
      ),*/