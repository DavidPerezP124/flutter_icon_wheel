import 'package:flutter/material.dart';
import 'dart:math';
import 'package:vector_math/vector_math.dart' show radians;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: Scaffold(
        body: SizedBox.expand(
          child: RadialMenu(),
        ),
      ),
    );
  }
}

class RadialMenu extends StatefulWidget {
  createState() => _RadialMenuState();
}

class  _RadialMenuState extends State<RadialMenu> with SingleTickerProviderStateMixin{
  AnimationController controller;

   @override
   void initState(){
     super.initState();
     controller =AnimationController(duration: Duration(milliseconds: 900),vsync: this);
   }
   @override
   Widget build(BuildContext context){
     return RadialAnimation(controller: controller);
   }
}

class RadialAnimation extends StatelessWidget {
  
  RadialAnimation({ Key key, this.controller}) :

    scale = Tween<double>(
      begin: 1.2,
      end: 0.0,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.fastOutSlowIn
      ),
    ),

    translation = Tween<double>(
      begin: 0.0,
      end: 90.0,
    ).animate(
      CurvedAnimation(
        parent: controller, 
        curve: Curves.fastOutSlowIn
      ),
    ),

    rotation = Tween<double>(
      begin: 0.0,
      end: 360.0,
    ).animate(
      CurvedAnimation(
        parent: controller, 
        curve: Interval(
          0.0, 0.9,
          curve: Curves.easeOut,  
          ),
      ),
    ),

  super(key: key);
  final AnimationController controller;
  final Animation<double> scale;
  final Animation<double> translation;
  final Animation<double> rotation;
  build(context) {
    return AnimatedBuilder(
    animation : controller, 
    builder: (context, builder) {
      return Transform.rotate(
        angle: radians(rotation.value),
        child: Stack(
          alignment: Alignment.center,
          children: [
          _buildButton(102, color: Colors.deepOrange, icon:FontAwesomeIcons.facebook), 
          _buildButton(153, color: Colors.deepPurple, icon:FontAwesomeIcons.sms), 
          _buildButton(204, color: Colors.teal, icon:FontAwesomeIcons.bluetooth), 
          _buildButton(255, color: Colors.yellow, icon:FontAwesomeIcons.addressBook), 
          
            Transform.scale(
              scale:scale.value -1.2,
              child: FloatingActionButton(
                child: Icon(FontAwesomeIcons.undo),
                onPressed: _close,
                backgroundColor: Colors.red,
              ),
            ),
            Transform.scale(
              scale: scale.value,
              child: FloatingActionButton(
                  child: Icon(FontAwesomeIcons.shareAltSquare),
                  onPressed: _open,
                  backgroundColor: Colors.teal,
                )
            ),
          ],
        )
      );  
    });
  }

  _buildButton(double angle, { Color color, IconData icon}) {
    final double rad = radians(angle);
    return Transform(
      transform:  Matrix4.identity()..translate(
      (translation.value) * cos(rad),
      (translation.value) * sin(rad),
      ),
      child: FloatingActionButton(
        child: Icon(icon), backgroundColor: color, onPressed: _close
      )
    );

  }

  _open(){
    controller.forward();
  }

  _close(){
    controller.reverse();
  }
}