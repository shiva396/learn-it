import 'package:flutter/material.dart';
import 'package:learnit/ui/atoms/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with TickerProviderStateMixin {
  final TextEditingController _nameController = TextEditingController();
  AnimationController? _animationController;
  AnimationController? _floatingController;
  Animation<double>? _fadeAnimation;
  Animation<double>? _slideAnimation;
  Animation<double>? _floatingAnimation;

  @override
  void initState() {
    super.initState();

    // Main animation controller for fade and slide effects
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Floating animation controller for background elements
    _floatingController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat(reverse: true);

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController!,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _slideAnimation = Tween<double>(begin: 30.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _animationController!,
        curve: const Interval(0.2, 0.8, curve: Curves.easeOut),
      ),
    );

    _floatingAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _floatingController!, curve: Curves.easeInOut),
    );

    _animationController!.forward();
  }

  @override
  void dispose() {
    _animationController?.dispose();
    _floatingController?.dispose();
    super.dispose();
  }

  Future<void> _saveNameAndContinue() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userName', _nameController.text);
    Navigator.pushReplacementNamed(context, '/onboarding');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LColors.background,
      resizeToAvoidBottomInset: true,
      body: AnimatedBuilder(
        animation: Listenable.merge([
          _animationController!,
          _floatingController!,
        ]),
        builder: (context, child) {
          return Stack(
            children: [
              // Animated Background Elements
              _buildFloatingElements(),

              // Main Content
              SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 32.0,
                  ),
                  child: FadeTransition(
                    opacity: _fadeAnimation!,
                    child: Transform.translate(
                      offset: Offset(0, _slideAnimation!.value),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight:
                              MediaQuery.of(context).size.height -
                              MediaQuery.of(context).padding.top -
                              MediaQuery.of(context).padding.bottom -
                              64,
                        ),
                        child: IntrinsicHeight(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Top spacer
                              const SizedBox(height: 80),

                              // Logo Section
                              _buildLogoSection(),

                              const SizedBox(height: 32),

                              // App Name
                              Text(
                                'Learn-IT',
                                style: TextStyle(
                                  fontSize: 36,
                                  fontWeight: FontWeight.bold,
                                  color: LColors.blueDark,
                                  letterSpacing: -0.5,
                                ),
                              ),

                              const SizedBox(height: 8),

                              // Tagline
                              Text(
                                'GRAMMAR MADE SIMPLE',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: LColors.blue,
                                  letterSpacing: 1.5,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),

                              const SizedBox(height: 16),

                              // Subtitle
                              Text(
                                'Master English grammar with\ninteractive lessons and exercises',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: LColors.greyDark,
                                  height: 1.4,
                                  fontWeight: FontWeight.w400,
                                ),
                                textAlign: TextAlign.center,
                              ),

                              const SizedBox(height: 90),

                              // Welcome Text
                              Text(
                                'What should we call you?',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: LColors.black,
                                  fontWeight: FontWeight.w600,
                                ),
                                textAlign: TextAlign.center,
                              ),

                              const SizedBox(height: 24),

                              // Name Input Field
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: LColors.greyLight,
                                    width: 1.5,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: LColors.blue.withOpacity(0.08),
                                      blurRadius: 8,
                                      spreadRadius: 0,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: TextField(
                                  controller: _nameController,
                                  style: TextStyle(
                                    color: LColors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 18,
                                    ),
                                    hintText: 'Enter your name',
                                    hintStyle: TextStyle(
                                      color: LColors.grey,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 32),

                              // Continue Button
                              SizedBox(
                                width: double.infinity,
                                height: 56,
                                child: ElevatedButton(
                                  onPressed: () {
                                    if (_nameController.text
                                        .trim()
                                        .isNotEmpty) {
                                      _saveNameAndContinue();
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: LColors.blue,
                                    elevation: 0,
                                    shadowColor: Colors.transparent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                  child: Text(
                                    'Get Started',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                      letterSpacing: 0.3,
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 16),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildLogoSection() {
    return Transform.translate(
      offset: Offset(0, _floatingAnimation!.value * 5),
      child: Container(
        width: 140,
        height: 140,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: LColors.blue.withOpacity(
                0.15 + _floatingAnimation!.value * 0.05,
              ),
              blurRadius: 20 + _floatingAnimation!.value * 5,
              spreadRadius: 0,
              offset: Offset(0, 8 + _floatingAnimation!.value * 2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(20),
        child: Image.asset('assets/images/Learn-it.png', fit: BoxFit.contain),
      ),
    );
  }

  Widget _buildFloatingElements() {
    final floatingValue = _floatingAnimation?.value ?? 0.0;
    return Stack(
      children: [
        // Floating circles
        Positioned(
          top: 100 + floatingValue * 20,
          right: 30,
          child: _buildFloatingCircle(
            size: 60,
            color: LColors.blueLight.withOpacity(0.1),
          ),
        ),
        Positioned(
          top: 200 + floatingValue * -15,
          left: 20,
          child: _buildFloatingCircle(
            size: 40,
            color: LColors.blue.withOpacity(0.08),
          ),
        ),
        Positioned(
          bottom: 300 + floatingValue * 25,
          right: 50,
          child: _buildFloatingCircle(
            size: 80,
            color: LColors.grammar.withOpacity(0.06),
          ),
        ),
        Positioned(
          bottom: 150 + floatingValue * -20,
          left: 40,
          child: _buildFloatingCircle(
            size: 50,
            color: LColors.blueLight.withOpacity(0.12),
          ),
        ),
        // Floating shapes
        Positioned(
          top: 300 + floatingValue * 30,
          left: MediaQuery.of(context).size.width * 0.7,
          child: _buildFloatingShape(),
        ),
        Positioned(
          bottom: 400 + floatingValue * -25,
          left: MediaQuery.of(context).size.width * 0.1,
          child: Transform.rotate(
            angle: floatingValue * 0.5,
            child: _buildFloatingShape(),
          ),
        ),
      ],
    );
  }

  Widget _buildFloatingCircle({required double size, required Color color}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }

  Widget _buildFloatingShape() {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        color: LColors.blue.withOpacity(0.08),
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}
