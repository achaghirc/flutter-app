import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmedDataResumeWidget extends StatelessWidget {
  final IconData? icon;
  const ShimmedDataResumeWidget({
    super.key,
    this.icon
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
          baseColor: Theme.of(context).colorScheme.inverseSurface,
          highlightColor: Theme.of(context).colorScheme.secondary,
          child: Row(
            children: [
              icon != null ?
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.white,
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
                  SizedBox(height: 10, width: MediaQuery.of(context).size.width * 0.18, child: Container(decoration: const BoxDecoration(color: Colors.black12))),
                  const SizedBox(height: 5),
                  SizedBox(height: 10, width: MediaQuery.of(context).size.width * 0.12, child: Container(decoration: const BoxDecoration(color: Colors.black12),)),
                ],
              )
            ],
          )
        );
  }
}