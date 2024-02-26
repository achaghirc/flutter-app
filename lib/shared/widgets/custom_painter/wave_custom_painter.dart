import 'package:flutter/material.dart';

class HeaderWavePainter extends CustomPainter {
  late BuildContext context;
  HeaderWavePainter({
    required this.context
  });
  
  @override
  void paint(Canvas canvas, Size size) {
    //paint == lapiz
    final paint = Paint();
    
    //Propiedades
    paint.color =  Theme.of(context).colorScheme.secondary;
    paint.style = PaintingStyle.fill;
    paint.strokeWidth = 5;

    final path = Path();
    //Si subo el valor de size.height * 0.2 puedo cambiar el punto de curvatura de la línea
    //Wave 2 sectores
    path.lineTo(0, size.height * 0.50);
    path.quadraticBezierTo(size.width * 0.25, size.height * 0.60, size.width * 0.5, size.height * 0.50);
    path.quadraticBezierTo(size.width * 0.75, size.height * 0.40, size.width, size.height * 0.50);
    path.lineTo(size.width, 0);
    
    //Wave 4 sectores
    //path.lineTo(0, size.height * 0.25);
    //path.quadraticBezierTo(size.width * 0.125, size.height * 0.28, size.width * 0.25, size.height * 0.25);
    //path.quadraticBezierTo(size.width * 0.375, size.height * 0.22, size.width * 0.50, size.height * 0.25);
    //path.quadraticBezierTo(size.width * 0.625, size.height * 0.28, size.width * 0.75, size.height * 0.25);
    //path.quadraticBezierTo(size.width * 0.9, size.height * 0.22, size.width, size.height * 0.25);
    //path.lineTo(size.width, 0);

    //Wave bottom two sectors.
    // path.moveTo(0, size.height);
    // path.lineTo(0, size.height * 0.75);
    // path.quadraticBezierTo(size.width * 0.25, size.height * 0.7, size.width * 0.5, size.height * 0.75);
    // path.quadraticBezierTo(size.width * 0.75, size.height * 0.8, size.width, size.height * 0.75);
    // path.lineTo(size.width, size.height);
    canvas.drawPath(path, paint);
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}