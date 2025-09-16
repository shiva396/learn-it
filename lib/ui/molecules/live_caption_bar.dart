import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:learnit/ui/atoms/colors.dart';
import 'dart:async';

class TranscriptionSegment {
  final Duration timestamp;
  final String text;

  TranscriptionSegment({required this.timestamp, required this.text});
}

class LiveCaptionBar extends StatefulWidget {
  final VideoPlayerController videoController;
  final String? transcriptionAssetPath;

  const LiveCaptionBar({
    Key? key,
    required this.videoController,
    this.transcriptionAssetPath,
  }) : super(key: key);

  @override
  State<LiveCaptionBar> createState() => _LiveCaptionBarState();
}

class _LiveCaptionBarState extends State<LiveCaptionBar> {
  List<TranscriptionSegment> _segments = [];
  int _currentSegmentIndex = -1;
  Timer? _progressTimer;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTranscription();
    _startProgressMonitoring();
  }

  @override
  void dispose() {
    _progressTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadTranscription() async {
    if (widget.transcriptionAssetPath == null) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    try {
      final String content = await DefaultAssetBundle.of(
        context,
      ).loadString(widget.transcriptionAssetPath!);

      _segments = _parseTranscription(content);

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading transcription: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  List<TranscriptionSegment> _parseTranscription(String content) {
    final List<TranscriptionSegment> segments = [];
    final lines = content.split('\n');

    for (int i = 0; i < lines.length; i++) {
      final line = lines[i].trim();
      if (line.isEmpty) continue;

      // Check if line is a timestamp (HH:MM:SS format)
      if (RegExp(r'^\d{2}:\d{2}:\d{2}$').hasMatch(line)) {
        // Next line should be the text
        if (i + 1 < lines.length) {
          final text = lines[i + 1].trim();
          if (text.isNotEmpty) {
            final timestamp = _parseTimestamp(line);
            segments.add(
              TranscriptionSegment(timestamp: timestamp, text: text),
            );
          }
        }
      }
    }

    return segments;
  }

  Duration _parseTimestamp(String timeString) {
    final parts = timeString.split(':');
    final hours = int.parse(parts[0]);
    final minutes = int.parse(parts[1]);
    final seconds = int.parse(parts[2]);

    return Duration(hours: hours, minutes: minutes, seconds: seconds);
  }

  void _startProgressMonitoring() {
    _progressTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (widget.videoController.value.isInitialized) {
        _updateCurrentSegment();
      }
    });
  }

  void _updateCurrentSegment() {
    if (_segments.isEmpty) return;

    final currentPosition = widget.videoController.value.position;
    int newSegmentIndex = -1;

    // Find the current segment based on video position
    for (int i = 0; i < _segments.length; i++) {
      if (i == _segments.length - 1) {
        // Last segment
        if (currentPosition >= _segments[i].timestamp) {
          newSegmentIndex = i;
        }
      } else {
        // Check if current position is between this and next segment
        if (currentPosition >= _segments[i].timestamp &&
            currentPosition < _segments[i + 1].timestamp) {
          newSegmentIndex = i;
          break;
        }
      }
    }

    if (newSegmentIndex != _currentSegmentIndex) {
      setState(() {
        _currentSegmentIndex = newSegmentIndex;
      });
    }
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours.toString().padLeft(2, '0');
    final minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading ||
        _segments.isEmpty ||
        widget.transcriptionAssetPath == null) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 16.0),
        decoration: BoxDecoration(
          color: LColors.blue.withOpacity(0.4),

          border: Border(
            bottom: BorderSide(color: LColors.blue.withOpacity(0.3), width: 2),
          ),
        ),
        child: Center(
          child: Text(
            'No live captions available',
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 15,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 16.0),
      decoration: BoxDecoration(
        color: LColors.blue.withOpacity(0.6),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(8),
          bottomRight: Radius.circular(8),
        ),
        border: Border(
          bottom: BorderSide(color: LColors.blue.withOpacity(0.3), width: 2),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_currentSegmentIndex >= 0)
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 6.0,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    _formatDuration(_segments[_currentSegmentIndex].timestamp),
                    style: TextStyle(
                      color: LColors.blue,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10.0,
                    vertical: 4.0,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(6.0),
                  ),
                  child: const Text(
                    'LIVE',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ],
            ),
          if (_currentSegmentIndex >= 0) const SizedBox(height: 12),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child:
                _currentSegmentIndex >= 0
                    ? Text(
                      _segments[_currentSegmentIndex].text,
                      key: ValueKey(_currentSegmentIndex),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        height: 1.5,
                        shadows: [
                          Shadow(
                            color: Colors.black26,
                            offset: Offset(1, 1),
                            blurRadius: 2,
                          ),
                        ],
                      ),
                      // Show full caption without restrictions
                    )
                    : Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Center(
                        child: Text(
                          'Waiting for video to start...',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 14,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ),
          ),
        ],
      ),
    );
  }
}
