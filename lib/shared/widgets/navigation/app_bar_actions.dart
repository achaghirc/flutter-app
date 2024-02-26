import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppBarActions extends StatelessWidget {
  const AppBarActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 0.0, 5.0, 0.0),
            child: IconButton(
              onPressed: (){
                context.push('/profile');
              }, 
              icon: Icon(
                Icons.account_circle_outlined,
                size: 30
              )
            ),
          ),
      ],
    );
  }
}