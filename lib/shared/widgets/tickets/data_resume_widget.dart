import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_app/presentation/providers/theme_provider.dart';

class DataResumeWidget extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    bool isDarkMode = ref.read(themeNotifierProvider).isDarkMode;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        icon != null ?
          Row(
            children: [
              CircleAvatar(
                backgroundColor: iconColor ?? Colors.white,
                child: Icon(
                  icon,
                  color: isDarkMode ? Theme.of(context).colorScheme.surface : Theme.of(context).colorScheme.inverseSurface,
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

