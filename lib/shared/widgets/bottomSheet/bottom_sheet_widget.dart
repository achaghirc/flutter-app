import 'package:flutter/material.dart';


class BottomSheetWidget {

  BottomSheetWidget.showModalBottomSheet(BuildContext context, Widget child, double maxHeight, double? minHeight, double? width, BoxDecoration? boxDecoration){
    showModalBottomSheet(
      context: context,
      isScrollControlled:true,
      isDismissible: true,
      builder: (BuildContext _) {
        return LayoutBuilder(
          builder: (context, _) {
            return AnimatedPadding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              duration: const Duration(milliseconds: 150),
              curve: Curves.easeOut,
              child: Container(
                decoration: boxDecoration,
                constraints: BoxConstraints(
                  maxHeight: maxHeight,
                  minHeight: minHeight ?? MediaQuery.of(context).size.height * 0.3,
                  minWidth: width ?? MediaQuery.of(context).size.width
                ),
                child: child
              ),
            );
          } 
        );
      },
    );
  }
  BottomSheetWidget.showDialogCenter(BuildContext context, Widget child){
    showDialog<void>(
      context: context,
      useSafeArea: true,
      builder: (BuildContext _) {
        return Center(
          child: LayoutBuilder(
            builder: (context, _) {
              return child;
            } 
          ),
        );
      },
    );
  }
    
}