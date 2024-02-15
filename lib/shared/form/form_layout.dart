import 'package:flutter/material.dart';


class FormLayout extends StatelessWidget {
  final List<Widget> children;
  static const columnGap = 0.0;
  static const padding =  0.0;
  const FormLayout({
    super.key,
    required this.children
    });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(padding),
          child: Column(
              children: <Widget>[
                for(int i = 0; i< children.length; i++) ...[
                  children[i],
                  if(i -1 < children.length) 
                    const SizedBox(
                      height: columnGap,
                    ),
                ],
              ]
            ),
          )
      ),
    );
  }
}