import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_app/infraestructure/models/events/event_dto.dart';

class InformationEventWidget extends StatelessWidget {
  final EventDTO event;
  const InformationEventWidget({
    super.key,
    required this.event
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [       
        Container(
          padding: const EdgeInsets.fromLTRB(11, 0, 0, 5),
          alignment: Alignment.centerLeft,
          child: Text(
            'Información',
            style: GoogleFonts.nunito(
              color: Theme.of(context).colorScheme.inverseSurface,
              fontSize: 18,
            ),
            textAlign: TextAlign.start,
          ),
        ),
        const Divider(
            endIndent: 10.0,
            indent: 10.0,
            height: 2,
        ),      
        ListTile(
          onTap: (){},
          leading: Wrap(
            spacing: 5,
            children: [
              Icon(
                Icons.location_on_outlined,
                color: Theme.of(context).iconTheme.color,
              )
            ]
          ),
          title: Text(
            '${event.ubicationTypeRoad}, ${event.ubicationNameRoad}, ${event.ubicationTown}',
            style: GoogleFonts.nunito(),
            ),
          trailing:  Wrap(
            spacing: 5,
            children: [
              Icon(
                Icons.arrow_forward,
                color: Theme.of(context).iconTheme.color,
              )
            ]
          ),
        ),
        const Divider(
            endIndent: 10.0,
            indent: 10.0,
            height: 2,
        ), 
        ListTile(
          onTap: (){},
          leading: Wrap(
            spacing: 5,
            children: [
              Icon(
                Icons.groups_outlined,
                color: Theme.of(context).iconTheme.color,
              )
            ]
          ),
          title: Text(
            'Mas información',
            style: GoogleFonts.nunito(),
            ),
          trailing:  Wrap(
            spacing: 5,
            children: [
              Icon(
                Icons.arrow_forward,
                color: Theme.of(context).iconTheme.color,
              )
            ]
          ),
        ),
      ],
    );
  }
}