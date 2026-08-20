import 'package:flutter/material.dart';
import 'package:margnetra_super_app/pages/splash_screen/splash_screen.dart';

class RoadAndCar extends StatelessWidget {
  final double width;
   RoadAndCar({super.key, required this.width});

  @override
  Widget build(BuildContext context) {
    return  SizedBox(
                      height: width * 0.31,
                      width: double.infinity,
                      child: CustomPaint(
                        painter: RoadPainter( 
                          progress:  width * 0.31,
                        ),
                      ),
                    );
  }
}