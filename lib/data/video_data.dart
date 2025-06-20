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
    title: '1. Parts of Speech - (Noun)',
    thumbnail: 'assets/images/thumbnails/adjective.png',
    duration: '5:30',
  ),
  VideoData(
    title: '2. Parts of Speech - (Pronoun)',
    thumbnail: 'assets/images/thumbnails/adjective.png',
    duration: '4:20',
  ),
  VideoData(
    title: '3. Parts of Speech - (Verb)',
    thumbnail: 'assets/images/thumbnails/adjective.png',
    duration: '6:10',
  ),
  // Add more videos as needed
];
