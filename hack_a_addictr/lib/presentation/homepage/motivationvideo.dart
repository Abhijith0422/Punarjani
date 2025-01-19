// ignore_for_file: library_private_types_in_public_api, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/services.dart';

class MotivationVideo extends StatefulWidget {
  final String videoUrl;
  final String title;

  const MotivationVideo(
      {super.key, required this.videoUrl, required this.title});

  @override
  _MotivationVideoState createState() => _MotivationVideoState();
}

class _MotivationVideoState extends State<MotivationVideo> {
  late VideoPlayerController _controller;
  bool _isMuted = false;
  bool _isAppBarVisible = true;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
        _hideAppBar();
      });
  }

  void _hideAppBar() {
    Future.delayed(const Duration(seconds: 3), () {
      if (_controller.value.isPlaying) {
        setState(() {
          _isAppBarVisible = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.pause();
    _controller.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  void _enterFullScreen() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            FullScreenVideoPlayer(controller: _controller, title: widget.title),
      ),
    ).then((_) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _isAppBarVisible
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
        onTap: () {
          setState(() {
            _isAppBarVisible = !_isAppBarVisible;
          });
          if (_isAppBarVisible) {
            _hideAppBar();
          }
        },
        child: _controller.value.isInitialized
            ? Stack(
                children: [
                  Center(
                    child: AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    ),
                  ),
                  Positioned(
                    bottom: 30,
                    left: 10,
                    right: 10,
                    child: VideoProgressIndicator(
                      _controller,
                      allowScrubbing: true,
                    ),
                  ),
                  Positioned(
                    bottom: 30,
                    left: 60,
                    child: IconButton(
                      icon: Icon(
                        _controller.value.isPlaying
                            ? Icons.pause
                            : Icons.play_arrow,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        setState(() {
                          _controller.value.isPlaying
                              ? _controller.pause()
                              : _controller.play();
                        });
                      },
                    ),
                  ),
                  Positioned(
                    bottom: 30,
                    left: 10,
                    child: IconButton(
                      icon: Icon(
                        _isMuted ? Icons.volume_off : Icons.volume_up,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        setState(() {
                          _isMuted = !_isMuted;
                          _controller.setVolume(_isMuted ? 0 : 1);
                        });
                      },
                    ),
                  ),
                  Positioned(
                    bottom: 30,
                    right: 10,
                    child: IconButton(
                      icon: const Icon(Icons.fullscreen),
                      onPressed: _enterFullScreen,
                    ),
                  ),
                ],
              )
            : const Center(child: CircularProgressIndicator()),
      ),
    );
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
  bool _isAppBarVisible = true;

  @override
  void initState() {
    super.initState();
    _hideAppBar();
  }

  void _hideAppBar() {
    Future.delayed(const Duration(seconds: 3), () {
      if (widget.controller.value.isPlaying) {
        setState(() {
          _isAppBarVisible = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _isAppBarVisible
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
        onTap: () {
          setState(() {
            _isAppBarVisible = !_isAppBarVisible;
          });
          if (_isAppBarVisible) {
            _hideAppBar();
          }
        },
        child: Stack(
          children: [
            Center(
              child: AspectRatio(
                aspectRatio: widget.controller.value.aspectRatio,
                child: VideoPlayer(widget.controller),
              ),
            ),
            Positioned(
              bottom: 30,
              left: 10,
              right: 10,
              child: VideoProgressIndicator(
                widget.controller,
                allowScrubbing: true,
              ),
            ),
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
                    widget.controller.value.isPlaying
                        ? widget.controller.pause()
                        : widget.controller.play();
                  });
                },
              ),
            ),
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
