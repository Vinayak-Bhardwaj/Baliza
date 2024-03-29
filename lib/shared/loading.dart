import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        height: size.height,
        width: double.infinity,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Center(
              child: SpinKitChasingDots(color: Color(0xFF6F35A5), size: 50.0),
            ),
          ],
        ),
        color: Color(0xFFF1E6FF),
        //child:
      ),
    );
  }
}
