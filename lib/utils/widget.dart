import 'package:flutter/material.dart';

void ShowDialogLoading(context){
  showDialog(context: context, builder:(context){
    return const Center(
      child: CircularProgressIndicator(),
    );
  });
}


void DisplayMessage(BuildContext context, String message){
  showDialog(context: context, builder:(context){
    return AlertDialog(
      title: Text(message),
    );
  });
}