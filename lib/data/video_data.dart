class VideoData {
  final String title;
  final String videoPath;
  final String thumbnail;
  final String duration;

  VideoData({
    required this.title,
    required this.videoPath,
    required this.thumbnail,
    required this.duration,
  });
}

final List<VideoData> videoList = [
  VideoData(
    title: '1. What is adjective?',
    videoPath: 'assets/videos/adjective.mp4',
    thumbnail: 'assets/images/thumbnails/adjective.png',
    duration: '5:30',
  ),
  VideoData(
    title: '2. Types of Adjectives',
     videoPath: 'assets/videos/adjective.mp4',
    thumbnail: 'assets/images/thumbnails/adjective.png',
    duration: '4:20',
  ),
  VideoData(
    title: '3. Comparative and Superlative Adjectives',
     videoPath: 'assets/videos/adjective.mp4',
    thumbnail: 'assets/images/thumbnails/adjective.png',
    duration: '6:10',
  ),

];
