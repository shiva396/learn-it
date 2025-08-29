import 'package:flutter/material.dart';
import 'package:learnit/ui/atoms/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String userName = 'Student';

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('userName') ?? 'Student';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LColors.blueDark,
      appBar: AppBar(
        backgroundColor: LColors.blueDark,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pushNamed(context, '/menu'),
          child: Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: CircleAvatar(
              backgroundColor: Colors.white.withOpacity(0.2),
              child: Icon(Icons.person, color: Colors.white),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 16),
              Text(
                'Learn-IT',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8),
              Text(
                'GRAMMAR MADE SIMPLE',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24),
              _HomeTile(
                color: LColors.blue,
                icon: Icons.menu_book,
                title: 'GRAMMAR',
                subtitle: 'Improve Your Grammar Skills',
                onTap: () => Navigator.pushNamed(context, '/grammar'),
                extra: Row(
                  children: [
                    Icon(Icons.article, color: Colors.white, size: 16),
                    SizedBox(width: 4),
                    Text(
                      'Articles',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                    SizedBox(width: 12),
                    Icon(
                      Icons.dashboard_customize,
                      color: Colors.white,
                      size: 16,
                    ),
                    SizedBox(width: 4),
                    Text(
                      'Text customization',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              _HomeTile(
                color: LColors.blueLight,
                icon: Icons.video_library,
                title: 'EXPLANATION',
                subtitle: 'Video Lessons',
                tag: 'NEW',
                tagColor: Colors.redAccent,
                onTap: () => Navigator.pushNamed(context, '/explanation'),
                extra: Row(
                  children: [
                    Icon(Icons.check, color: Colors.white, size: 16),
                    SizedBox(width: 4),
                    Text(
                      'Description',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                    SizedBox(width: 12),
                    Icon(Icons.check, color: Colors.white, size: 16),
                    SizedBox(width: 4),
                    Text(
                      'Transcript available',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              _HomeTile(
                color: LColors.exercises,
                icon: Icons.games,
                title: 'INTERACTIVE GAMES',
                subtitle: 'Fun games to practice grammar',
                tag: 'NEW',
                tagColor: Colors.greenAccent,
                onTap: () => Navigator.pushNamed(context, '/interactive_games'),
                extra: Row(
                  children: [
                    Icon(Icons.category, color: Colors.white, size: 16),
                    SizedBox(width: 4),
                    Text(
                      'Multiple topics',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                    SizedBox(width: 12),
                    Icon(Icons.star, color: Colors.white, size: 16),
                    SizedBox(width: 4),
                    Text(
                      'Interactive learning',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 16),
              _HomeTile(
                color: const Color(0xFF6366F1),
                icon: Icons.slideshow,
                title: 'Sliding Decks',
                subtitle: 'Interactive slide presentations',
                onTap: () => Navigator.pushNamed(context, '/slide_decks'),
              ),
              SizedBox(height: 16),

              _HomeTile(
                color: const Color.fromARGB(255, 27, 208, 196),
                icon: Icons.assignment,
                title: 'TESTS',
                subtitle: 'Test Your English Grammar',
                onTap: () => Navigator.pushNamed(context, '/tests'),
              ),
              SizedBox(height: 16),
              _HomeTile(
                color: LColors.highlight,
                icon: Icons.history,
                title: 'RECENT ACTIVITIES',
                subtitle: 'Track your learning journey',
                onTap: () => Navigator.pushNamed(context, '/recent_activities'),
              ),
              SizedBox(height: 32),
              // Text(
              //   'Recommended Videos',
              //   style: TextStyle(
              //     color: Colors.white,
              //     fontSize: 20,
              //     fontWeight: FontWeight.bold,
              //   ),
              // ),
              // SizedBox(height: 16),
              // Column(
              //   children:
              //       videoList
              //           .map((video) => VideoCard(videoData: video))
              //           .toList(),
              // ),
              // SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

class _HomeTile extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String title;
  final String subtitle;
  final String? tag;
  final Color? tagColor;
  final VoidCallback onTap;
  final Widget? extra;

  const _HomeTile({
    required this.color,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.tag,
    this.tagColor,
    this.extra,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
        ),
        padding: EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: Colors.white.withOpacity(0.2),
              child: Icon(icon, color: Colors.white),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      if (tag != null)
                        Container(
                          margin: EdgeInsets.only(left: 8),
                          padding: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: tagColor ?? Colors.redAccent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            tag!,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 14,
                    ),
                  ),
                  if (extra != null) ...[SizedBox(height: 8), extra!],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
