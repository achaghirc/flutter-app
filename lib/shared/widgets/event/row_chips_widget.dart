import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RowChipsWidget extends StatelessWidget {
  final String? publicRelationCode;
  const RowChipsWidget({
    this.publicRelationCode
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 30.0, // gap between adjacent chips
      runSpacing: 4.0, // gap between lines
      children: <Widget>[
        Chip(
          backgroundColor: Theme.of(context).colorScheme.secondary,
          side: BorderSide.none,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          label: Text(
            publicRelationCode ?? 'ADMIN',
            style: GoogleFonts.nunito(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.background
            ),
          ),
        ),
        Chip(
          backgroundColor: Theme.of(context).colorScheme.secondary,
          side: BorderSide.none,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          label: Text(
            'LINK',
            style: GoogleFonts.nunito(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.background
            ),
          ),
        ),
      ]
  );
  }
}