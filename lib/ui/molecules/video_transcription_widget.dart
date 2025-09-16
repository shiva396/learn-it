import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:learnit/ui/atoms/colors.dart';
import 'dart:async';

class TranscriptionSegment {
  final Duration timestamp;
  final String text;

  TranscriptionSegment({required this.timestamp, required this.text});
}

class VideoTranscriptionWidget extends StatefulWidget {
  final VideoPlayerController videoController;
  final String transcriptionAssetPath;

  const VideoTranscriptionWidget({
    Key? key,
    required this.videoController,
    required this.transcriptionAssetPath,
  }) : super(key: key);

  @override
  State<VideoTranscriptionWidget> createState() =>
      _VideoTranscriptionWidgetState();
}

class _VideoTranscriptionWidgetState extends State<VideoTranscriptionWidget> {
  List<TranscriptionSegment> _segments = [];
  int _currentSegmentIndex = -1;
  Timer? _progressTimer;
  final ScrollController _scrollController = ScrollController();
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
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadTranscription() async {
    try {
      final String content = await DefaultAssetBundle.of(
        context,
      ).loadString(widget.transcriptionAssetPath);

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
      // Removed auto-scroll functionality
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
    if (_isLoading) {
      return Container(
        padding: const EdgeInsets.all(16.0),
        child: const Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      );
    }

    if (_segments.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16.0),
        child: const Center(
          child: Text(
            'No transcription available',
            style: TextStyle(color: Colors.white70, fontSize: 16),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
        controller: _scrollController,
        itemCount: _segments.length,
        itemBuilder: (context, index) {
          final segment = _segments[index];
          final isActive = index == _currentSegmentIndex;

          return Container(
            margin: const EdgeInsets.symmetric(vertical: 4.0),
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color:
                  isActive ? LColors.blue.withOpacity(0.3) : Colors.transparent,
              borderRadius: BorderRadius.circular(8.0),
              border:
                  isActive ? Border.all(color: LColors.blue, width: 2.0) : null,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 26.0,
                  ),
                  decoration: BoxDecoration(
                    color:
                        isActive ? LColors.blue : Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  child: Text(
                    _formatDuration(segment.timestamp),
                    style: TextStyle(
                      color: isActive ? Colors.white : Colors.white70,
                      fontSize: 12,
                      fontWeight:
                          isActive ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
                const SizedBox(width: 12.0),
                Expanded(
                  child: Text(
                    segment.text,
                    style: TextStyle(
                      color: isActive ? Colors.white : Colors.white70,
                      fontSize: 16,
                      fontWeight:
                          isActive ? FontWeight.w600 : FontWeight.normal,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
