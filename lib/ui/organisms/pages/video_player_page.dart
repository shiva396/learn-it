import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/services.dart';
import 'package:learnit/ui/atoms/colors.dart';
import 'dart:async';

class VideoPlayerPage extends StatefulWidget {
  final String videoPath;
  final String description;

  const VideoPlayerPage({
    Key? key,
    required this.videoPath,
    required this.description,
  }) : super(key: key);

  @override
  State<VideoPlayerPage> createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  late VideoPlayerController _controller;
  bool isLandscape = false;
  bool _showControls = true;
  Timer? _hideControlsTimer;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(widget.videoPath)
      ..initialize().then((_) {
        setState(() {});
      });
    _controller.addListener(() {
      setState(() {});
    });
    _startHideControlsTimer();
  }

  @override
  void dispose() {
    // Always set orientation back to portrait when leaving this page
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    _controller.dispose();
    _hideControlsTimer?.cancel();
    super.dispose();
  }

  void _toggleOrientation() {
    if (isLandscape) {
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
      setState(() {
        isLandscape = false;
      });
    } else {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
      setState(() {
        isLandscape = true;
      });
    }
  }

  void _startHideControlsTimer() {
    _hideControlsTimer?.cancel();
    _hideControlsTimer = Timer(const Duration(seconds: 5), () {
      setState(() {
        _showControls = false;
      });
    });
  }

  void _onScreenTapped() {
    setState(() {
      _showControls = true;
    });
    _startHideControlsTimer();
  }

  Widget _buildVideoWithControls(BuildContext context, bool isPortrait) {
    return GestureDetector(
      onTap: _onScreenTapped,
      child: Stack(
        alignment: Alignment.center,
        children: [
          AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: VideoPlayer(_controller),
            ),
          ),
          if (_showControls)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  borderRadius: isPortrait
                      ? const BorderRadius.only(
                          bottomLeft: Radius.circular(20.0),
                          bottomRight: Radius.circular(20.0),
                        )
                      : null,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.shuffle, color: Colors.white),
                          onPressed: () {},
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.skip_previous, color: Colors.white),
                          onPressed: () {},
                        ),
                        const Spacer(),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 8,
                              ),
                            ],
                          ),
                          child: IconButton(
                            icon: Icon(
                              _controller.value.isPlaying
                                  ? Icons.pause
                                  : Icons.play_arrow,
                              color: Colors.orange,
                              size: 32,
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
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.skip_next, color: Colors.white),
                          onPressed: () {},
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.volume_up, color: Colors.white),
                          onPressed: () {},
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Slider(
                      value: _controller.value.position.inSeconds.toDouble(),
                      min: 0,
                      max: _controller.value.duration.inSeconds.toDouble(),
                      onChanged: (value) {
                        _controller.seekTo(Duration(seconds: value.toInt()));
                      },
                      activeColor: Colors.white,
                      inactiveColor: Colors.white.withOpacity(0.3),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: isLandscape
            ? null
            : AppBar(
                backgroundColor: LColors.blue,
                elevation: 0,
                title: Column(
                  children: [
                    Text(
                      'VIDEO PLAYER',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Watch and Learn',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                centerTitle: true,
              ),
        backgroundColor: isLandscape ? Colors.black : LColors.blueDark,
        body: OrientationBuilder(
          builder: (context, orientation) {
            final isPortrait = orientation == Orientation.portrait;
            if (!isPortrait) {
              return Center(
                child: _buildVideoWithControls(context, false),
              );
            } else {
              return Column(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(20.0),
                      bottomRight: Radius.circular(20.0),
                    ),
                    child: _buildVideoWithControls(context, true),
                  ),
                  Container(
                    color: LColors.blueDark,
                    child: TabBar(
                      tabs: [
                        Tab(text: 'Description'),
                        Tab(text: 'Transcription'),
                      ],
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.grey,
                      indicatorColor: Colors.red,
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            widget.description,
                            style: const TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            'Transcription content goes here.',
                            style: const TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
