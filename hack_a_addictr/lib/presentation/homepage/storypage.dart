// ignore_for_file: library_private_types_in_public_api

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/services.dart';
import 'dart:async';

import '../../theme/theme.dart';

class StoryPage extends StatefulWidget {
  final String title;
  final String content;

  const StoryPage({super.key, required this.title, required this.content});

  @override
  _StoryPageState createState() => _StoryPageState();
}

class _StoryPageState extends State<StoryPage> {
  late VideoPlayerController _controller;
  bool _isMuted = false;
  bool _showControls = true;
  Timer? _hideTimer;
  // Function to retrieve data from recovery-stories collection
  Future<List<Map<String, dynamic>>> getRecoveryStories() async {
    final QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('recovery-stories').get();
    return snapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  }

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(
        'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4')) // Replace with your video URL
      ..initialize().then((_) {
        setState(() {});
        _startHideTimer();
      })
      ..addListener(() {
        if (_controller.value.hasError) {
          setState(() {});
        }
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    _hideTimer?.cancel();
    super.dispose();
  }

  void _toggleMute() {
    setState(() {
      _isMuted = !_isMuted;
      _controller.setVolume(_isMuted ? 0 : 1);
    });
  }

  void _toggleControls() {
    setState(() {
      _showControls = !_showControls;
      if (_showControls) {
        _startHideTimer();
      } else {
        _hideTimer?.cancel();
      }
    });
  }

  void _startHideTimer() {
    _hideTimer?.cancel();
    _hideTimer = Timer(const Duration(seconds: 3), () {
      setState(() {
        _showControls = false;
      });
    });
  }

  void _enterFullScreen() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FullScreenVideoPlayer(
            controller: _controller, title: 'MOTIVATION STORY'),
      ),
    ).then((_) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(builder: (context, themeprovider, _) {
      return SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Container(
              height: 80,
              width: MediaQuery.of(context).size.width,
              color: themeprovider.themeData.brightness == Brightness.dark
                  ? const Color(0xFFEAE0C8)
                  : const Color(0xFFFF4400),
              child: Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(50, 15, 10, 10),
                    child: Icon(
                      CupertinoIcons.book_fill,
                      size: 30,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text('MOTIVATION STORY',
                      style: TextStyle(
                          decoration: TextDecoration.none,
                          color: themeprovider.themeData.brightness !=
                                  Brightness.dark
                              ? Colors.white
                              : Colors.black,
                          fontSize: 25,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            Expanded(
              child: Container(
                width: MediaQuery.of(context).size.width,
                color: themeprovider.themeData.brightness != Brightness.dark
                    ? const Color(0xFFEAE0C8)
                    : const Color(0xFFFF4400),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(30.0),
                  child: Column(
                    children: [
                      Text(
                        widget.title,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 20,
                          height: 2,
                          color: themeprovider.themeData.brightness ==
                                  Brightness.dark
                              ? Colors.white
                              : Colors.black,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.none,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      _controller.value.isInitialized
                          ? GestureDetector(
                              onTap: _toggleControls,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  AspectRatio(
                                    aspectRatio: _controller.value.aspectRatio,
                                    child: VideoPlayer(_controller),
                                  ),
                                  if (_showControls)
                                    IconButton(
                                      icon: Icon(
                                        _controller.value.isPlaying
                                            ? Icons.pause
                                            : Icons.play_arrow,
                                        color: Colors.white,
                                        size: 50,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          if (_controller.value.isPlaying) {
                                            _controller.pause();
                                          } else {
                                            _controller.play();
                                            _startHideTimer();
                                          }
                                        });
                                      },
                                    ),
                                  if (_showControls)
                                    Positioned(
                                      bottom: 2,
                                      left: 10,
                                      child: Row(
                                        children: [
                                          IconButton(
                                            icon: Icon(
                                              _isMuted
                                                  ? Icons.volume_off
                                                  : Icons.volume_up,
                                              color: Colors.white,
                                            ),
                                            onPressed: _toggleMute,
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.fullscreen),
                                            color: Colors.white,
                                            onPressed: _enterFullScreen,
                                          ),
                                        ],
                                      ),
                                    ),
                                ],
                              ),
                            )
                          : _controller.value.hasError
                              ? Container(
                                  height: 200,
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  color: Colors.black,
                                  child: const Center(
                                    child: Text(
                                      'Error loading video',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                )
                              : Container(
                                  height: 200,
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  color: Colors.black,
                                  child: const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        widget.content,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 17,
                          height: 2,
                          color: themeprovider.themeData.brightness ==
                                  Brightness.dark
                              ? Colors.white
                              : Colors.black,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.none,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}

class FullScreenVideoPlayer extends StatefulWidget {
  final VideoPlayerController controller;
  final String title;

  const FullScreenVideoPlayer(
      {super.key, required this.controller, required this.title});

  @override
  _FullScreenVideoPlayerState createState() => _FullScreenVideoPlayerState();
}

class _FullScreenVideoPlayerState extends State<FullScreenVideoPlayer> {
  bool _showControls = true;
  Timer? _hideTimer;

  @override
  void initState() {
    super.initState();
    _startHideTimer();
  }

  void _toggleControls() {
    setState(() {
      _showControls = !_showControls;
      if (_showControls) {
        _startHideTimer();
      } else {
        _hideTimer?.cancel();
      }
    });
  }

  void _startHideTimer() {
    _hideTimer?.cancel();
    _hideTimer = Timer(const Duration(seconds: 3), () {
      setState(() {
        _showControls = false;
      });
    });
  }

  @override
  void dispose() {
    _hideTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _showControls
          ? AppBar(
              automaticallyImplyLeading: true,
              iconTheme: const IconThemeData(color: Colors.white),
              title: Text(widget.title,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins')),
              backgroundColor: Colors.transparent,
            )
          : null,
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: _toggleControls,
        child: Stack(
          children: [
            Center(
              child: AspectRatio(
                aspectRatio: widget.controller.value.aspectRatio,
                child: VideoPlayer(widget.controller),
              ),
            ),
            if (_showControls)
              Positioned(
                bottom: 30,
                left: 10,
                right: 10,
                child: VideoProgressIndicator(
                  widget.controller,
                  allowScrubbing: true,
                ),
              ),
            if (_showControls)
              Positioned(
                bottom: 30,
                left: 60,
                child: IconButton(
                  icon: Icon(
                    widget.controller.value.isPlaying
                        ? Icons.pause
                        : Icons.play_arrow,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      if (widget.controller.value.isPlaying) {
                        widget.controller.pause();
                      } else {
                        widget.controller.play();
                        _startHideTimer();
                      }
                    });
                  },
                ),
              ),
            if (_showControls)
              Positioned(
                bottom: 30,
                left: 10,
                child: IconButton(
                  icon: Icon(
                    widget.controller.value.volume == 0
                        ? Icons.volume_off
                        : Icons.volume_up,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    widget.controller
                        .setVolume(widget.controller.value.volume == 0 ? 1 : 0);
                  },
                ),
              ),
            if (_showControls)
              Positioned(
                bottom: 30,
                right: 10,
                child: IconButton(
                  icon: const Icon(Icons.fullscreen_exit),
                  color: Colors.white,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
