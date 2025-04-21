import 'package:flutter/material.dart';
import 'package:todo/secondPage.dart';

class landingPage extends StatefulWidget {
  const landingPage({super.key,});



  @override
  State<landingPage> createState() => _landingPage();
}

class _landingPage extends State<landingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset("asset/test.jpg", fit: BoxFit.cover,),
          Center(
            child: Container(
              width: 200.0,
              height: 50.0,
              decoration: BoxDecoration(color: Colors.grey,borderRadius: BorderRadius.circular(50)),
              child: TextButton(onPressed: (){
                Navigator.of(context).push(_secondRoute());
              },
                child: Text("Welcome",style: TextStyle(color: Colors.white),),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Route _secondRoute(){
  return PageRouteBuilder(
    pageBuilder: (context,animation,secondaryAnimation)=> const secondPage(title: "Second"),
    transitionsBuilder: (context,animation,secondaryAnimation,child){
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween  = Tween(begin: begin,end: end).chain(CurveTween(curve: curve));

      return SlideTransition(position: animation.drive(tween), child: child);
    },
  );
}