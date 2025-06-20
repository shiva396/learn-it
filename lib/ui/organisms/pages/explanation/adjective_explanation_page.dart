import 'package:flutter/material.dart';
import 'package:learnit/ui/atoms/colors.dart';
import 'package:learnit/ui/molecules/video_card.dart';
import 'package:learnit/data/video_data.dart';
import 'package:learnit/ui/organisms/pages/video_player_page.dart';

class AdjectiveExplanationPage extends StatelessWidget {
  const AdjectiveExplanationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adjective Explanation'),
        backgroundColor: LColors.blueDark,
        elevation: 0,
      ),
      backgroundColor: LColors.blueDark,
      body: ListView.builder(
        itemCount: videoList.length,
        itemBuilder: (context, index) {
          final video = videoList[index];
          return GestureDetector(
            onTap:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => VideoPlayerPage(
                          videoPath: 'assets/videos/adjective.mp4',
                          description: video.title,
                        ),
                  ),
                ),
            child: VideoCard(videoData: video),
          );
        },
      ),
    );
  }
}
