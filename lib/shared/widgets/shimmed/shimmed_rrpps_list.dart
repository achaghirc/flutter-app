import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmedRRPPSList extends StatelessWidget {
  
  final int size;
  
  const ShimmedRRPPSList({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: size + 1,
      // Important code
      itemBuilder: (context, index) => Shimmer.fromColors(
          baseColor: Theme.of(context).colorScheme.inverseSurface,
          highlightColor: Theme.of(context).colorScheme.onInverseSurface,
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
          )),
    );
  }
}