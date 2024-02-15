import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmedRRPP extends StatelessWidget {
  
  const ShimmedRRPP({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
          baseColor: Colors.grey,
          highlightColor: Theme.of(context).colorScheme.secondary,
          child: ListTile(
            title: SizedBox(height: 10, child: Container(decoration: const BoxDecoration(color: Colors.black12),)),
            subtitle: SizedBox(height: 10, child: Container(decoration: const BoxDecoration(color: Colors.black12),)),
            leading: const CircleAvatar(
              radius: 30, // Image radius
              backgroundImage: AssetImage('assets/userIcons/menProfile.png'),
            ),
            trailing: Wrap(
              spacing: 5,
              children: [
                IconButton(onPressed: (){}, 
                icon: Icon(
                  Icons.highlight_remove_outlined,
                  color: Theme.of(context).iconTheme.color,
                  )
                )
              ],
            ),
          )
    );
  }
}