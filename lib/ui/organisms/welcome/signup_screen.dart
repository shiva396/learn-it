// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, unused_local_variable, avoid_print, body_might_complete_normally_nullable

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:learnit/auth/auth_functions.dart';
import 'package:learnit/ui/atoms/colors.dart';
import 'package:learnit/ui/atoms/extensions.dart';
import 'package:learnit/ui/atoms/widgets.dart';
import 'package:learnit/ui/molecules/splash_card.dart';
import 'package:learnit/ui/organisms/pages/home_screen.dart';
import 'package:learnit/ui/organisms/welcome/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController password = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var hei = MediaQuery.of(context).size.height;
    var wid = MediaQuery.of(context).size.width;
    var asp = MediaQuery.of(context).size.aspectRatio;
    return Scaffold(
      extendBodyBehindAppBar: true,
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
              SizedBox(height: hei * 0.1),
              splashCard(context),
              customTextBox(
                asp,
                'Full Name',
                'Name',
                Icons.person_2,
                name,
                false,
                0,
              ),
              SizedBox(height: hei * 0.01),
              customTextBox(
                asp,
                'Email',
                'example@gmail.com',
                Icons.email,
                email,
                false,
                0,
              ),
              SizedBox(height: hei * 0.01),
              customTextBox(
                asp,
                'New Password',
                'Password',
                Icons.password_rounded,
                password,
                true,
                1,
              ),
              SizedBox(height: hei * 0.01),
              customTextBox(
                asp,
                'Confirm Password',
                'Confirm Password',
                Icons.password_rounded,
                confirmPassword,
                true,
                2,
              ),
              SizedBox(height: hei * 0.05),
              GestureDetector(
                onTap: () async {
                  print("You clicked me");
                  if (email.text.isNotEmpty &&
                      password.text.isNotEmpty &&
                      name.text.isNotEmpty &&
                      confirmPassword.text.isNotEmpty) {
                    if (email.text.isEmail &&
                        (password.text.length >= 6) &&
                        (password.text == confirmPassword.text)) {
                      UserCredential? userCredential;
                      try {
                        await setLoginState(true);
                        userCredential = await FirebaseAuth.instance
                            .createUserWithEmailAndPassword(
                              email: email.text.trim(),
                              password: password.text.trim(),
                            )
                            .then((value) {
                              createUser();
                              FirebaseAuth.instance.currentUser!
                                  .updateDisplayName(name.text.trim());
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => HomeScreen(),
                                ),
                                (Route<dynamic> route) => false,
                              );
                            });
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(e.toString()),
                            duration: Duration(seconds: 2),
                            backgroundColor: Colors.red,
                          ),
                        );
                        print(e.toString());
                      }
                    }
                  } else if (name.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Please enter your Name'),
                        duration: Duration(seconds: 2),
                        backgroundColor: Colors.red,
                      ),
                    );
                  } else if (email.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Please enter your Email'),
                        duration: Duration(seconds: 2),
                        backgroundColor: Colors.red,
                      ),
                    );
                  } else if (password.text == confirmPassword.text) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Please enter same password in both fields',
                        ),
                        duration: Duration(seconds: 2),
                        backgroundColor: Colors.red,
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Please enter all the Fields'),
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
                    width: wid * 0.4,
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
                      child: Text(
                        'SIGN UP',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: asp * 35,
                          fontFamily: 'mont2',
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: hei * 0.02),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account?',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: 'mont',
                    ),
                  ),
                  SizedBox(width: 3),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(
                        context,
                      ).push(MaterialPageRoute(builder: (context) => LogIn()));
                    },
                    child: Text(
                      'Log In',
                      style: TextStyle(
                        color: LColors.buttonDarkColor,
                        fontSize: 16,
                        fontFamily: 'mont3',
                      ),
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

  bool isPass1 = true;
  bool isPass2 = true;

  Column customTextBox(
    double asp,
    String upperText,
    String textHint,
    IconData icon,
    TextEditingController controller,
    bool isPassword,
    int a,
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
              prefixIcon: Icon(icon, color: LColors.buttonDarkColor),
              suffixIcon:
                  isPassword
                      ? GestureDetector(
                        onTap: () {
                          setState(() {
                            a == 1 ? isPass1 = !isPass1 : isPass2 = !isPass2;
                          });
                        },
                        child: Icon(
                          (a == 1 ? !isPass1 : !isPass2)
                              ? Icons.visibility_rounded
                              : Icons.visibility_off_rounded,
                          color: LColors.buttonDarkColor,
                        ),
                      )
                      : null,
              hintStyle: TextStyle(
                color: Color(0xFFEFEBE0).withOpacity(0.5),
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
            obscureText:
                isPassword
                    ? a == 1
                        ? isPass1
                        : isPass2
                    : false,
          ),
        ),
      ],
    );
  }

  Future createUser() async {
    final docUser = FirebaseFirestore.instance
        .collection(email.text.trim())
        .doc('result');
    final json = {
      'noun': 0,
      'verb': 0,
      'pronoun': 0,
      'adjective': 0,
      'adverb': 0,
      'preposition': 0,
      'conjunction': 0,
      'interjection': 0,
    };
    await docUser.set(json);
  }
}
