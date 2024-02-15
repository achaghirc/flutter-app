import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
          textAlign: TextAlign.center,
        ),
        Text(
          'now',
          style: GoogleFonts.nunito(
            fontSize: size ?? 55,
            fontWeight: FontWeight.w800,
            color: Theme.of(context).colorScheme.primary
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}