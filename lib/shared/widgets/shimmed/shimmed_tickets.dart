import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmedTicketsList extends StatelessWidget {
  final int size;
  const ShimmedTicketsList({
    super.key,
    required this.size
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: size,
      itemBuilder: (context, index) => Shimmer.fromColors(
        baseColor: Theme.of(context).colorScheme.inverseSurface,
        //baseColor: Colors.grey,
        highlightColor: Theme.of(context).colorScheme.onInverseSurface,
        period: const Duration(seconds: 3),
        child: ListTile(
          onTap: () {
          },
          title: SizedBox(height: 15, width: 10.0, child: Container(decoration: const BoxDecoration(color: Colors.black12))),
          leading: const Icon(
            Icons.local_activity_outlined
          ),
          trailing: Wrap(
              spacing: 10,
              children: [
                SizedBox(
                  height: 15.0,
                  width: 15.0,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.black12
                    )
                  )
                )
              ],
            ),
        )
      ),
    );
  }
}