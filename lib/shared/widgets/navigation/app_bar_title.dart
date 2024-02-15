import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
class AppBarTitle extends StatelessWidget {
  final String title;
  const AppBarTitle({
    super.key,
    required this.title
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: GoogleFonts.nunito(
        fontSize: 20,
      ),
    );
  }
}