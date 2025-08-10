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
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = true;
  DateTime? _joinDate;
  String _currentName = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _currentName = prefs.getString('userName') ?? 'Grammar Explorer';
      _nameController.text = _currentName;
      _emailController.text = prefs.getString('userEmail') ?? '';

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
    await prefs.setString('userEmail', _emailController.text.trim());

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
        actions: [
          TextButton(
            onPressed: _saveUserData,
            child: Text(
              'Save',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
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
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: LColors.blue.withOpacity(0.1),
                      shape: BoxShape.circle,
                      border: Border.all(color: LColors.blue, width: 3),
                    ),
                    child: Icon(Icons.person, size: 50, color: LColors.blue),
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
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Profile Form
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
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
                        color: LColors.black,
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
                        fillColor: LColors.background,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Email Field
                    Text(
                      'Email Address (Optional)',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: LColors.greyDark,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: 'Enter your email address',
                        prefixIcon: Icon(
                          Icons.email_outlined,
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
                        fillColor: LColors.background,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Account Information
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Account Information',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: LColors.black,
                      ),
                    ),
                    const SizedBox(height: 16),

                    _buildInfoRow(
                      icon: Icons.calendar_today,
                      label: 'Join Date',
                      value:
                          _joinDate != null
                              ? '${_joinDate!.day}/${_joinDate!.month}/${_joinDate!.year}'
                              : 'Unknown',
                    ),

                    const SizedBox(height: 12),

                    _buildInfoRow(
                      icon: Icons.phone_android,
                      label: 'Platform',
                      value: 'Mobile App',
                    ),

                    const SizedBox(height: 12),

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
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _saveUserData,
                style: ElevatedButton.styleFrom(
                  backgroundColor: LColors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 3,
                ),
                child: const Text(
                  'Save Changes',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
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
    return Row(
      children: [
        Icon(icon, color: LColors.blue, size: 20),
        const SizedBox(width: 12),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: LColors.greyDark,
            fontWeight: FontWeight.w500,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            color: LColors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
