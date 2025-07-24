import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e/screens/expenses.dart';
import 'package:e/model/data.dart';
import 'package:e/sign-login-screens/buttons.dart/button.dart';
import 'package:e/sign-login-screens/sign_in.dart';
import 'package:e/sign-login-screens/sign_up.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class StartupScreens extends StatefulWidget {
  const StartupScreens({super.key});

  @override
  State<StartupScreens> createState() => _StartupScreensState();
}

class _StartupScreensState extends State<StartupScreens> {
  void _gotosignIn(context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => SignIn()));
  }

  void _gotosignUp(context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => SignUp()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            bottom: 200,
            right: 20,
            left: 20,
            child: Hero(
              tag: 'hello',
              child: Lottie.asset('assets/json/gradient.json'),
            ),
          ),

          Positioned(
            bottom: 5,
            left: 16,
            right: 16,
            top: 40,
            child: Column(
              children: [
                Image.asset(
                  'assets/json/online-math-tutoring-abstract-concept-vector-illustration-math-private-lessons-reach-your-academic-goals-online-education-quarantine-homeschooling-qualified-teachers-abstract-metaphor.png',
                  width: 200,
                  height: 200,
                  fit: BoxFit.cover,
                ),
                Text(
                  '"Track smart. Spend wiser. Live freer."',
                  style: GoogleFonts.spaceMono(
                    fontSize: 24,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                Button(
                  gotopage: () {
                    _gotosignIn(context);
                  },
                  label: 'Log In',
                ),
                const SizedBox(height: 20),
                Button(
                  gotopage: () {
                    _gotosignUp(context);
                  },
                  label: 'Sign Up',
                ),
                const Spacer(),
                Text(
                  'Free. Private. Easy.',
                  style: GoogleFonts.spaceMono(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
