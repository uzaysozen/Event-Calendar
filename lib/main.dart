import 'package:countdown_app/screens/event_list.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AnimatedSplashScreen(
          duration: 2000,
          splash: Icon(Icons.calendar_month_outlined, color: Colors.white, size: 140,),
          nextScreen: EventList(),
          splashTransition: SplashTransition.fadeTransition,
          pageTransitionType: PageTransitionType.fade,
          backgroundColor: Colors.blueAccent),
      debugShowCheckedModeBanner: false,
    );
  }
}
