import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/services.dart';
import 'package:learnit/ui/atoms/colors.dart';
import 'package:learnit/services/recent_activities_service.dart';
import 'package:learnit/ui/molecules/video_transcription_widget.dart';
import 'package:learnit/ui/molecules/live_caption_bar.dart';
import 'dart:async';

class VideoPlayerPage extends StatefulWidget {
  final String videoPath;
  final String description;
  final String? transcriptionPath;

  const VideoPlayerPage({
    Key? key,
    required this.videoPath,
    required this.description,
    this.transcriptionPath,
  }) : super(key: key);

  @override
  State<VideoPlayerPage> createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  late VideoPlayerController _controller;
  bool isLandscape = false;
  bool _showControls = true;
  Timer? _hideControlsTimer;
  bool _hasLoggedActivity = false;

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

  void _logVideoActivity() async {
    await RecentActivitiesService.logVideoWatched(widget.description);
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

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    final seconds = duration.inSeconds % 60;

    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    } else {
      return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
  }

  Widget _buildVideoWithControls(BuildContext context, bool isPortrait) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: _onScreenTapped,
        child: Stack(
          alignment: Alignment.center,
          children: [
            AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: VideoPlayer(_controller),
              ),
            ),
            if (_showControls)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius:
                        isPortrait
                            ? const BorderRadius.only(
                              bottomLeft: Radius.circular(8),
                              bottomRight: Radius.circular(8),
                            )
                            : null,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      VideoProgressIndicator(
                        _controller,
                        allowScrubbing: true,
                        colors: VideoProgressColors(
                          playedColor: Colors.red,
                          bufferedColor: Colors.grey,
                          backgroundColor: Colors.black,
                        ),
                      ),
                      // Duration display
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8.0,
                          vertical: 4.0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _formatDuration(_controller.value.position),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              _formatDuration(_controller.value.duration),
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.replay_5,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              final newPosition =
                                  _controller.value.position -
                                  const Duration(seconds: 5);
                              _controller.seekTo(newPosition);
                            },
                          ),
                          IconButton(
                            icon: Icon(
                              _controller.value.isPlaying
                                  ? Icons.pause
                                  : Icons.play_arrow,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              setState(() {
                                if (_controller.value.isPlaying) {
                                  _controller.pause();
                                } else {
                                  _controller.play();
                                  // Log video watching activity only once
                                  if (!_hasLoggedActivity) {
                                    _logVideoActivity();
                                    _hasLoggedActivity = true;
                                  }
                                }
                              });
                            },
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.forward_5,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              final newPosition =
                                  _controller.value.position +
                                  const Duration(seconds: 5);
                              _controller.seekTo(newPosition);
                            },
                          ),
                          if (!isPortrait)
                            IconButton(
                              icon: const Icon(
                                Icons.screen_rotation,
                                color: Colors.white,
                              ),
                              onPressed: _toggleOrientation,
                            ),
                          if (isPortrait)
                            IconButton(
                              icon: const Icon(
                                Icons.fullscreen,
                                color: Colors.white,
                              ),
                              onPressed: _toggleOrientation,
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar:
            isLandscape
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
              return Center(child: _buildVideoWithControls(context, false));
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
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        widget.transcriptionPath != null
                            ? Column(
                              children: [
                                LiveCaptionBar(
                                  videoController: _controller,
                                  transcriptionAssetPath:
                                      widget.transcriptionPath,
                                ),
                                Expanded(
                                  child: VideoTranscriptionWidget(
                                    videoController: _controller,
                                    transcriptionAssetPath:
                                        widget.transcriptionPath!,
                                  ),
                                ),
                              ],
                            )
                            : const Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Center(
                                child: Text(
                                  'No transcription available for this video.',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 16,
                                  ),
                                ),
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
