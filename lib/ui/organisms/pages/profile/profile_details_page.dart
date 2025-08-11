import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:learnit/ui/atoms/colors.dart';

class ProfileDetailsPage extends StatefulWidget {
  const ProfileDetailsPage({super.key});

  @override
  State<ProfileDetailsPage> createState() => _ProfileDetailsPageState();
}

class _ProfileDetailsPageState extends State<ProfileDetailsPage> {
  final TextEditingController _nameController = TextEditingController();
  bool _isLoading = true;
  DateTime? _joinDate;
  String _currentName = '';
  int _selectedAvatarIndex = 0;

  // Available avatar icons - Nice character emojis
  final List<String> _avatarEmojis = [
    '👦', // Boy
    '👧', // Girl
    '🦸‍♂️', // Male Superhero (Superman-like)
    '🦸‍♀️', // Female Superhero
    '👨‍🎓', // Male Student
    '👩‍🎓', // Female Student
    '🧑‍💻', // Technologist
    '👨‍🏫', // Male Teacher
    '👩‍🏫', // Female Teacher
    '🧙‍♂️', // Male Wizard
    '🧙‍♀️', // Female Wizard
    '👨‍🚀', // Male Astronaut
    '👩‍🚀', // Female Astronaut
    '🦄', // Unicorn
    '🐱', // Cat
    '🐶', // Dog
    '🐸', // Frog
    '🦊', // Fox
    '🐺', // Wolf
    '🐻', // Bear
    '🐼', // Panda
    '🐨', // Koala
    '🦁', // Lion
    '🐯', // Tiger
  ];

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _currentName = prefs.getString('userName') ?? 'Grammar Explorer';
      _nameController.text = _currentName;
      _selectedAvatarIndex = prefs.getInt('selectedAvatar') ?? 0;

      // Get join date or set it if it doesn't exist
      final joinDateString = prefs.getString('joinDate');
      if (joinDateString != null) {
        _joinDate = DateTime.parse(joinDateString);
      } else {
        _joinDate = DateTime.now();
        prefs.setString('joinDate', _joinDate!.toIso8601String());
      }

      _isLoading = false;
    });
  }

  Future<void> _saveUserData() async {
    if (_nameController.text.trim().isEmpty) {
      _showErrorDialog('Name cannot be empty');
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userName', _nameController.text.trim());
    await prefs.setInt('selectedAvatar', _selectedAvatarIndex);

    setState(() {
      _currentName = _nameController.text.trim();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Profile updated successfully!'),
        backgroundColor: LColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );

    Navigator.pop(context, true); // Return true to indicate profile was updated
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Row(
              children: [
                Icon(Icons.error_outline, color: LColors.error),
                const SizedBox(width: 8),
                const Text('Error'),
              ],
            ),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK', style: TextStyle(color: LColors.blue)),
              ),
            ],
          ),
    );
  }

  String _formatJoinDate() {
    if (_joinDate == null) return 'Unknown';

    final now = DateTime.now();
    final difference = now.difference(_joinDate!);

    if (difference.inDays < 1) {
      return 'Today';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks week${weeks > 1 ? 's' : ''} ago';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return '$months month${months > 1 ? 's' : ''} ago';
    } else {
      final years = (difference.inDays / 365).floor();
      return '$years year${years > 1 ? 's' : ''} ago';
    }
  }

  void _showAvatarSelection() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          height:
              MediaQuery.of(context).size.height * 0.6, // Set explicit height
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: LColors.greyLight,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Choose Your Avatar',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: LColors.black,
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.0,
                  ),
                  itemCount: _avatarEmojis.length,
                  itemBuilder: (context, index) {
                    final isSelected = index == _selectedAvatarIndex;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedAvatarIndex = index;
                        });
                        Navigator.pop(context);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color:
                              isSelected
                                  ? LColors.blue.withOpacity(0.2)
                                  : LColors.surface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color:
                                isSelected ? LColors.blue : LColors.greyLight,
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            _avatarEmojis[index],
                            style: TextStyle(fontSize: 32),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: LColors.background,
        appBar: AppBar(
          title: const Text(
            'Profile Details',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: LColors.blueDark,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: LColors.background,
      appBar: AppBar(
        title: const Text(
          'Profile Details',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: LColors.blueDark,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        // actions: [
        //   TextButton(
        //     onPressed: _saveUserData,
        //     child: Text(
        //       'Save',
        //       style: TextStyle(
        //         color: Colors.white,
        //         fontWeight: FontWeight.bold,
        //         fontSize: 16,
        //       ),
        //     ),
        //   ),
        // ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Avatar Section
            Center(
              child: Column(
                children: [
                  GestureDetector(
                    onTap: _showAvatarSelection,
                    child: Stack(
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: LColors.blue.withOpacity(0.1),
                            shape: BoxShape.circle,
                            border: Border.all(color: LColors.blue, width: 3),
                          ),
                          child: Center(
                            child: Text(
                              _avatarEmojis[_selectedAvatarIndex],
                              style: const TextStyle(fontSize: 50),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              color: LColors.blue,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: const Icon(
                              Icons.edit,
                              size: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _currentName,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: LColors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Member since ${_formatJoinDate()}',
                    style: TextStyle(fontSize: 14, color: LColors.grey),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap avatar to change',
                    style: TextStyle(
                      fontSize: 12,
                      color: LColors.grey.withOpacity(0.8),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Profile Form
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: LColors.greyLight.withOpacity(0.5)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Personal Information',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: LColors.greyDark,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Name Field
                    Text(
                      'Full Name',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: LColors.greyDark,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        hintText: 'Enter your full name',
                        hintStyle: TextStyle(color: LColors.grey),
                        prefixIcon: Icon(
                          Icons.person_outline,
                          color: LColors.blue,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: LColors.greyLight),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: LColors.greyLight),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: LColors.blue, width: 2),
                        ),
                        filled: true,
                        fillColor: LColors.surface,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 22),

            // Account Information
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: LColors.greyLight.withOpacity(0.5)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info_outline, color: LColors.blue, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Account Information',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: LColors.greyDark,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),

                    _buildInfoRow(
                      icon: Icons.calendar_today,
                      label: 'Join Date',
                      value:
                          _joinDate != null
                              ? '${_joinDate!.day}/${_joinDate!.month}/${_joinDate!.year}'
                              : 'Unknown',
                    ),

                    const SizedBox(height: 14),

                    _buildInfoRow(
                      icon: Icons.phone_android,
                      label: 'Platform',
                      value: 'Mobile App',
                    ),

                    const SizedBox(height: 14),

                    _buildInfoRow(
                      icon: Icons.verified_user,
                      label: 'Account Type',
                      value: 'Free User',
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Save Button
            Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: LColors.blue.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: _saveUserData,
                style: ElevatedButton.styleFrom(
                  backgroundColor: LColors.blue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.save, size: 20),
                    const SizedBox(width: 8),
                    const Text(
                      'Save Changes',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
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

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: LColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: LColors.greyLight.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: LColors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(icon, color: LColors.blue, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: LColors.greyDark,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              color: LColors.greyDark,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
