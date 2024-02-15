import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moment_dart/moment_dart.dart';
import 'package:my_app/infraestructure/models/image/imageDTO.dart';
import 'package:my_app/presentation/providers/theme_provider.dart';
import 'package:shimmer/shimmer.dart';

class ShimmedEvents extends StatelessWidget {
  const ShimmedEvents({super.key});

  @override
  Widget build(BuildContext context) {
    List<ImageDTO> images = [];
    ImageDTO image = ImageDTO(title: 'title', type: 'type', data: Uint8List.fromList([1]));
    images.add(image);
    return Column(
            children: [
              Expanded(
                child: ListView.separated(
                  separatorBuilder: (context, index) {
                    return const SizedBox(
                      height: 10,
                    );
                  },
                  itemCount: 4,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    return CardEventShimmed(
                      titleCard: 'Default', 
                      subtitle: 'subtitle', 
                      startDate: '2022-10-29T20:00:00',
                      location: 'location',
                      images: images,
                    );
                  }
                )
              )
            ],
          );
  }
}


class CardEventShimmed extends ConsumerWidget {

  final String titleCard;
  final String subtitle;
  final String startDate;
  final String location;
  final List<ImageDTO> images;

  const CardEventShimmed({
    super.key,
    required this.titleCard,
    required this.subtitle,
    required this.startDate,
    required this.location,
    required this.images
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var isDarkMode = ref.read(themeNotifierProvider).isDarkMode;
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.95,
      height: MediaQuery.of(context).size.height * 0.25,
      child: Center(
        child: Card(
          elevation: 4,
          clipBehavior: Clip.hardEdge,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(8.0)
            )
          ),
          child: InkWell(
            onTap: () {},
            child: Stack(
                children: [
                  Container(
                    color:isDarkMode ? Theme.of(context).colorScheme.onSecondary : 
                    Theme.of(context).colorScheme.inverseSurface,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.95,
                    height: MediaQuery.of(context).size.height * 0.18,
                    child: Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Theme.of(context).colorScheme.onSecondary,
                      child:Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          ListTile(
                            title: SizedBox(height: 10, child: Container(decoration: const BoxDecoration(color: Colors.black12),)),
                            subtitle: SizedBox(height: 10, child: Container(decoration: const BoxDecoration(color: Colors.black12),)),
                          ),
                          CardInformation(information: Moment.parse(startDate, localization: MomentLocalizations.es()).LL, icon: Icons.calendar_month_outlined),
                          CardInformation(information: Moment.parse(startDate, localization: MomentLocalizations.es()).LT, icon: Icons.access_time),
                          CardInformation(information: location, icon: Icons.location_on_outlined)
                        ],
                      ),
                    ),
                  ),
                ] 
              ),
            ),
          ),
        ),
    );
  }
}

class CardInformation extends StatelessWidget {

  final String information;
  final IconData icon;

  const CardInformation({
    super.key,
    required this.information,
    required this.icon
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15.0,0,0,0),
      child: Row(
        children: [
          Icon(
            icon,
            color: Colors.white,
          ),
          const SizedBox(width: 10),
          SizedBox(height: 10, child: Container(decoration: const BoxDecoration(color: Colors.black12),))
        ],
      ),
    );
  }
}