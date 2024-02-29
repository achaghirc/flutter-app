import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_app/shared/widgets/custom/gradient_text.dart';

class TextIconWidget extends StatelessWidget {
  final double? size;
  const TextIconWidget({
    super.key,
    this.size
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Out',
          style: GoogleFonts.nunito(
            fontSize: size ?? 55,
            fontWeight: FontWeight.w800
          ),
        ),
        GradientText(
            'now',
            gradient: const LinearGradient(colors: [
              Color.fromRGBO(86,204,255, 100),
              Color.fromRGBO(113,228,201, 100),
              Color.fromRGBO(143,255,140, 100),
            ]),
            style: GoogleFonts.nunito(
              fontSize: size ?? 65,
              fontWeight: FontWeight.bold,
              color: Colors.greenAccent
            ),
          ),
      ],
    );
  }
}