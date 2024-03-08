import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_app/shared/widgets/custom/text_icon_widget.dart';


class PrivacityPolicyWidget extends StatelessWidget {
  const PrivacityPolicyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          horizontalTitleGap: 0,
          leading: IconButton(
            onPressed: (){
              context.pop();
            }, 
            icon: const Icon(Icons.arrow_back_outlined)
          ),
          title: const TextIconWidget(size: 55),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Duis lacinia nunc nulla, sed molestie nunc ornare et. Aliquam sit amet luctus velit, et bibendum purus. Nam quis molestie augue. Proin sit amet consectetur nisl, vel sagittis velit. Praesent libero mauris, iaculis ultrices congue vel, placerat in risus. Nullam quis dictum justo. Vestibulum varius dolor nisl. In at quam auctor, aliquam magna et, pretium magna. Ut sit amet mi efficitur, accumsan leo non, congue nibh.\nQuisque sit amet ex in diam euismod pellentesque. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Fusce porttitor ut ex id varius. Sed non erat mi. Nulla egestas, massa a posuere ultricies, elit libero egestas ex, vitae faucibus augue nibh quis ante. Donec vitae tincidunt lorem. Praesent vitae dapibus purus. Morbi a arcu in neque sollicitudin pretium porttitor sit amet urna. Fusce consectetur gravida augue, sed accumsan velit. Sed luctus venenatis quam, ac semper nisi fermentum at. Nunc vel nisi lobortis, fermentum dolor at, convallis tortor. Donec varius vestibulum tristique.\nProin cursus dui gravida efficitur maximus. Praesent aliquet lobortis suscipit. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Sed sodales semper commodo. Aenean sed auctor felis. Proin pretium sodales lacus. Cras eu lectus nec tellus sagittis accumsan consequat vulputate eros. Cras sed tempus urna, fermentum laoreet nunc. Aenean eu ipsum ornare, pulvinar mauris non, commodo nibh.',
            style: GoogleFonts.nunito(),
          ),
        )
      ],
    );
  }
}