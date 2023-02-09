import 'package:fluttertoast/fluttertoast.dart';

class MyWidgets{


  dynamic showToast({required String message}){
      //ios uses uiAlertView, similar to those error dialogs i used in login/register
    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(
    //     content: Text(message)
    //   )
    // );
    Fluttertoast.showToast(msg: message, gravity: ToastGravity.TOP);
  }
}