import 'package:flutter/material.dart';
class AppBarPop extends StatelessWidget {
 
  const AppBarPop({
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: Icon(
          Icons.arrow_back,
          color: Theme.of(context).colorScheme.secondary,
        )
      );
  }
}