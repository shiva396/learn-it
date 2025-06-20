// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, avoid_print, unused_local_variable

import 'package:flutter/material.dart';
import 'package:learnit/auth/auth_functions.dart';
import 'package:learnit/ui/atoms/colors.dart';
import 'package:learnit/ui/atoms/extensions.dart';
import 'package:learnit/ui/atoms/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:learnit/ui/molecules/splash_card.dart';
import 'package:learnit/ui/organisms/pages/home_screen.dart';
import 'package:learnit/ui/organisms/welcome/signup_screen.dart';

class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var hei = MediaQuery.of(context).size.height;
    var wid = MediaQuery.of(context).size.width;
    var asp = MediaQuery.of(context).size.aspectRatio;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      backgroundColor: Color(0xFF171617),
      body: Container(
        child: SingleChildScrollView(
          physics: ScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: hei * 0.06),
              splashCard(context),
              SizedBox(height: hei * 0.07),
              customTextBox(
                asp,
                'Email address',
                'Enter your email',
                Icons.email,
                email,
                false,
              ),
              SizedBox(height: hei * 0.009),
              customTextBox(
                asp,
                'Password',
                'Enter the Password',
                Icons.password_rounded,
                password,
                true,
              ),
              SizedBox(height: hei * 0.05),
              GestureDetector(
                onTap: () async {
                  if (email.text.isNotEmpty && password.text.isNotEmpty) {
                    print("Passed 1");
                    if (email.text.isEmail && (password.text.length >= 6)) {
                      print("Passed 2");
                      try {
                        UserCredential? userCredential;
                        await setLoginState(true);
                        userCredential = await FirebaseAuth.instance
                            .signInWithEmailAndPassword(
                              email: email.text,
                              password: password.text,
                            )
                            .then(
                              (value) =>
                                  Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                      builder: (context) => HomeScreen(),
                                    ),
                                    (Route<dynamic> route) => false,
                                  ),
                            );
                      } catch (e) {
                        print(e);
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Please enter valid email and password',
                          ),
                          duration: Duration(seconds: 2),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Please fill all the fields'),
                        duration: Duration(seconds: 2),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 30.0,
                    right: 30.0,
                    bottom: 20.0,
                  ),
                  child: Container(
                    width: wid * 0.5,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Color.fromARGB(255, 0, 53, 211),
                      ),
                      gradient: LinearGradient(
                        colors: [
                          Color.fromARGB(255, 40, 95, 188).withOpacity(0.4),
                          Color.fromARGB(255, 39, 36, 202).withOpacity(0.3),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    child: Center(
                      child: text('LOG IN', asp * 35, LColors.iconColor, 2),
                    ),
                  ),
                ),
              ),
              SizedBox(height: hei * 0.01),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  text(
                    'Don\'t have an Account? ',
                    asp * 30,
                    Color(0xFFEFEBE0),
                    2,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushNamed('/signup');
                    },
                    child: text(
                      'Sign Up',
                      asp * 30,
                      LColors.buttonDarkColor,
                      3,
                    ),
                  ),
                ],
              ),
              SizedBox(height: hei * 0.05),
            ],
            
          ),
        ),
      ),
    );
  }

  bool isPass = true;

  Column customTextBox(
    double asp,
    String upperText,
    String textHint,
    IconData icon,
    TextEditingController controller,
    bool isPassword,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(left: 30.0, bottom: 10.0),
          child: text(upperText, asp * 30, LColors.iconColor, 2),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 30.0, right: 30.0, bottom: 20.0),
          child: TextField(
            controller: controller,
            style: TextStyle(color: Colors.white, fontSize: 12),
            cursorColor: Color(0xFFEFEBE0),
            decoration: InputDecoration(
              hintText: textHint,
              prefixIcon: Icon(icon, color: LColors.iconColor),
              suffixIcon:
                  isPassword
                      ? GestureDetector(
                        onTap: () {
                          setState(() {
                            isPass = !isPass;
                          });
                        },
                        child: Icon(
                          !isPass
                              ? Icons.visibility_rounded
                              : Icons.visibility_off_rounded,
                          color: LColors.buttonDarkColor,
                        ),
                      )
                      : null,
              hintStyle: TextStyle(
                color: Color.fromARGB(255, 203, 201, 195).withOpacity(0.6),
                fontFamily: 'mont2',
                fontSize: asp * 30,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Color(0xFFEFEBE0)),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Color(0xFFEFEBE0)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Color(0xFFEFEBE0)),
              ),
            ),
            obscureText: isPassword ? isPass : false,
          ),
        ),
      ],
    );
  }
}
