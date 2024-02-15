import 'package:flutter/material.dart';
import 'package:my_app/shared/widgets/shimmed/shimmed_data_resume_widget.dart';
import 'package:shimmer/shimmer.dart';

class ShimmedUserEventInfo extends StatelessWidget {
  final int size;
  const ShimmedUserEventInfo({super.key, required this.size});

  buildListTile(size){
    List<Widget> widgets = [];

    for(int i = 0; i<size; i++){
      Widget w = ListTile(
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
      );
      widgets.add(w);
    }
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Theme.of(context).colorScheme.onSecondary,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const CircleAvatar(
                    radius: 25, // Image radius
                    backgroundImage: AssetImage('assets/userIcons/menProfile.png'),
                ),
                const SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: 20, width: MediaQuery.of(context).size.width * 0.26, child: Container(decoration: const BoxDecoration(color: Colors.black12))),
                    const SizedBox(height: 5,),
                    SizedBox(height: 15,  width: MediaQuery.of(context).size.width * 0.20,child: Container(decoration: const BoxDecoration(color: Colors.black12))),
                  ],
                )
              ],
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.015,
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ShimmedDataResumeWidget(icon: Icons.local_activity_outlined),
                ShimmedDataResumeWidget(icon: Icons.local_activity_outlined),
                ShimmedDataResumeWidget(icon: Icons.local_activity_outlined),
              ],
            ),
          ),
          size > 0 ? (
            Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.09,
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(11, 0, 0, 5),
                  alignment: Alignment.centerLeft,
                  child: SizedBox(height: 15, width: 65.0, child: Container(decoration: const BoxDecoration(color: Colors.black12)))
                ),
                const Divider(
                  endIndent: 10.0,
                  indent: 10.0,
                  height: 2,
                ),
                Column(children: buildListTile(size))
              ],
            )           
          )
          : const SizedBox()
        ],
      ),
    );
  }
}

