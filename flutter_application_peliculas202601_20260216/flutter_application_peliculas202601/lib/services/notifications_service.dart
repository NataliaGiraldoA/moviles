import 'package:flutter/material.dart';




class NotificationsService {




 static GlobalKey<ScaffoldMessengerState> messengerKey = GlobalKey<ScaffoldMessengerState>();




 static void showSnackbar( String message ) {

   final messengerState = messengerKey.currentState;
   if (messengerState == null) return;


   final snackBar = SnackBar(
     content: Text(
       message,
       style: const TextStyle(
         color: Colors.white,
         fontSize: 16,
         fontWeight: FontWeight.w600,
       ),
     ),
     backgroundColor: const Color(0xFF1A1A2E),
     behavior: SnackBarBehavior.floating,
     margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
     shape: RoundedRectangleBorder(
       borderRadius: BorderRadius.circular(12),
       side: const BorderSide(color: Color(0xFFE040FB), width: 1),
     ),
     duration: const Duration(seconds: 3),
   );


   messengerState
     ..hideCurrentSnackBar()
     ..showSnackBar(snackBar);


 }




}
