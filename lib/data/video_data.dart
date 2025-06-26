class VideoData {
  final String title;
  final String thumbnail;
  final String duration;

  VideoData({
    required this.title,
    required this.thumbnail,
    required this.duration,
  });
}

final List<VideoData> videoList = [
  VideoData(
    title: '1. What is adjective?',
    thumbnail: 'assets/images/thumbnails/adjective.png',
    duration: '5:30',
  ),
  VideoData(
    title: '2. Types of Adjectives',
    thumbnail: 'assets/images/thumbnails/adjective.png',
    duration: '4:20',
  ),
  VideoData(
    title: '3. Comparative and Superlative Adjectives',
    thumbnail: 'assets/images/thumbnails/adjective.png',
    duration: '6:10',
  ),

];
