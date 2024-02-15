import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class SearchWidget extends StatelessWidget {

  final TextEditingController searchController;
  final FocusNode? focusNode;
  final String placeholder;
  final ValueChanged<String>? onChanged;
  final Function? onClear;
  final GestureTapCallback? onTap;
  final OutlineInputBorder? outlineInputDecoration;
  final OutlineInputBorder? focusBorder;
  
  const SearchWidget({
    super.key, 
    required this.searchController,
    this.focusNode,
    required this.placeholder,
    required this.onChanged,
    required this.onTap,
    this.onClear,
    this.outlineInputDecoration,
    this.focusBorder
    });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(0),
        child: TextFormField(
          controller: searchController,
          focusNode: focusNode,
          cursorColor: Theme.of(context).colorScheme.secondary,
          keyboardType: TextInputType.text,
          onChanged: onChanged,
          validator: (value) {
              if(value == ''){
                return 'Rellene el campo';
              }
              return null;
          },
          style: GoogleFonts.nunito(
            color: Theme.of(context).colorScheme.secondary
          ),  
          onTap: onTap,
          decoration: InputDecoration(
            enabledBorder: outlineInputDecoration,
            suffixIcon: FadeIn(
              duration: const Duration(milliseconds: 200),
              animate: searchController.text != "",
              child: IconButton(
                icon: Icon(
                    Icons.close_outlined,
                  color: Theme.of(context).colorScheme.secondary,  
                ),
                onPressed: () {
                  onClear!();
                  searchController.text = "";
                },
              ),
            ),
            focusedBorder: focusBorder,
            labelText: placeholder,
            labelStyle: GoogleFonts.nunito()
          ),
        ),
      ),
    );
  }
}