import 'package:flutter/material.dart';
import 'package:learnit/ui/atoms/colors.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LColors.background,
      appBar: AppBar(
        title: const Text(
          'About Learn-IT',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: LColors.blueDark,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),

            // App Logo and Info
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: LColors.blue.withOpacity(0.1),
                shape: BoxShape.circle,
                border: Border.all(color: LColors.blue, width: 3),
              ),
              child: Center(child: Text('📚', style: TextStyle(fontSize: 60))),
            ),

            const SizedBox(height: 24),

            Text(
              'Learn-IT',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: LColors.black,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'Grammar Made Simple',
              style: TextStyle(
                fontSize: 18,
                color: LColors.blue,
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 4),

            Text(
              'Version 2.0.0',
              style: TextStyle(fontSize: 14, color: LColors.grey),
            ),

            const SizedBox(height: 32),

            // App Description Card
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info_outline, color: LColors.blue),
                        const SizedBox(width: 8),
                        Text(
                          'About This App',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: LColors.black,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Learn-IT is your personal grammar companion designed to make learning English grammar fun, interactive, and effective. Our app helps you master the fundamentals of English grammar through engaging exercises, practical examples, and personalized learning paths.',
                      style: TextStyle(
                        fontSize: 16,
                        color: LColors.greyDark,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Features Card
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.star, color: LColors.blue),
                        const SizedBox(width: 8),
                        Text(
                          'Key Features',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: LColors.black,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildFeatureItem(
                      icon: Icons.school,
                      title: 'Interactive Learning',
                      description: 'Hands-on exercises and real-world examples',
                    ),
                    _buildFeatureItem(
                      icon: Icons.trending_up,
                      title: 'Progress Tracking',
                      description:
                          'Monitor your learning journey with detailed analytics',
                    ),
                    _buildFeatureItem(
                      icon: Icons.emoji_events,
                      title: 'Achievements',
                      description:
                          'Unlock badges and celebrate your milestones',
                    ),
                    _buildFeatureItem(
                      icon: Icons.local_fire_department,
                      title: 'Learning Streaks',
                      description: 'Build consistent learning habits',
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Developer Card
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.code, color: LColors.blue),
                        const SizedBox(width: 8),
                        Text(
                          'Development Team',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: LColors.black,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: LColors.blue.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.person,
                            color: LColors.blue,
                            size: 30,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Developed with ❤️',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: LColors.black,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Making grammar learning accessible to everyone',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: LColors.greyDark,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Contact & Legal Card
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.email, color: LColors.blue),
                    title: const Text('Contact Support'),
                    subtitle: const Text('Get help with your learning journey'),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: LColors.grey,
                    ),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Contact feature coming soon!'),
                          backgroundColor: LColors.highlight,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      );
                    },
                  ),
                  Divider(height: 1, color: LColors.greyLight),
                  ListTile(
                    leading: Icon(Icons.privacy_tip, color: LColors.blue),
                    title: const Text('Privacy Policy'),
                    subtitle: const Text('How we protect your data'),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: LColors.grey,
                    ),
                    onTap: () {
                      _showPrivacyDialog(context);
                    },
                  ),
                  Divider(height: 1, color: LColors.greyLight),
                  ListTile(
                    leading: Icon(Icons.description, color: LColors.blue),
                    title: const Text('Terms of Service'),
                    subtitle: const Text('App usage terms and conditions'),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: LColors.grey,
                    ),
                    onTap: () {
                      _showTermsDialog(context);
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Copyright
            Text(
              '© 2024 Learn-IT Team. All rights reserved.',
              style: TextStyle(fontSize: 12, color: LColors.grey),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 8),

            Text(
              'Made with Flutter 💙',
              style: TextStyle(fontSize: 12, color: LColors.grey),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: LColors.blue, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: LColors.black,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: TextStyle(fontSize: 13, color: LColors.greyDark),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showPrivacyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Text(
              'Privacy Policy',
              style: TextStyle(
                color: LColors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: SingleChildScrollView(
              child: Text(
                'Learn-IT respects your privacy. We collect minimal data necessary for app functionality:\n\n'
                '• Learning progress and statistics\n'
                '• App usage preferences\n'
                '• No personal information is shared with third parties\n'
                '• All data is stored locally on your device\n\n'
                'Your learning journey is private and secure.',
                style: TextStyle(color: LColors.greyDark, height: 1.5),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Got it', style: TextStyle(color: LColors.blue)),
              ),
            ],
          ),
    );
  }

  void _showTermsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Text(
              'Terms of Service',
              style: TextStyle(
                color: LColors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: SingleChildScrollView(
              child: Text(
                'By using Learn-IT, you agree to:\n\n'
                '• Use the app for educational purposes\n'
                '• Not attempt to reverse engineer the app\n'
                '• Provide feedback to help us improve\n'
                '• Respect the learning community\n\n'
                'Learn-IT is provided "as is" for educational use. We strive to provide accurate content and a great learning experience.',
                style: TextStyle(color: LColors.greyDark, height: 1.5),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Agree', style: TextStyle(color: LColors.blue)),
              ),
            ],
          ),
    );
  }
}
