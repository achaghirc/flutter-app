import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DataResumeWidget extends StatelessWidget {
  final String title;
  final dynamic value;
  final Color color;
  final Color? iconColor;
  final IconData? icon;
  
  const DataResumeWidget({
    super.key,
    required this.title,
    required this.value,
    required this.color,
    this.iconColor,
    this.icon
    
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        icon != null ?
          Row(
            children: [
              CircleAvatar(
                backgroundColor: iconColor ?? Colors.white,
                child: Icon(
                  icon
                )
              ),
              const SizedBox(
                width: 5,
              ),
            ],
          )
        : 
        const SizedBox(
          width: 5,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: GoogleFonts.nunito(
                fontSize: 12,
                color: color,
                fontWeight: FontWeight.w800
              ),
            ),
            Text(
              '$value',
              style: GoogleFonts.nunito(
                color: color
              ),
            )
          ],
        )
      ],
    );
  }
}

