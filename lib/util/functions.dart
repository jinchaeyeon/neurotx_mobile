import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/src/provider.dart';
import 'package:sleepaid/data/ble_device.dart';
import 'package:sleepaid/page/realtime_signal_page.dart';
import 'package:sleepaid/provider/bluetooth_provider.dart';
import 'package:sleepaid/provider/data_provider.dart';
import '../app_routes.dart';
import 'app_colors.dart';
import 'dart:math';

Future<void> completedExit(BuildContext? context) async {
  try{
    if(context!=null){
      await context.read<BluetoothProvider>().destroyClient();
    }
  }catch(e){

  }

  if (Platform.isIOS) {
    exit(0);
  } else {
    await SystemNavigator.pop();
  }
}

/// 네트워크 연결 상태 체크하는 코드
Future<bool> checkNetworkState() async{
  bool result = await InternetConnectionChecker().hasConnection;
  if(result == true) {
    return true;
  } else {
    return false;
  }
}

showToast(String msg){
  Fluttertoast.showToast(msg: msg, gravity: ToastGravity.BOTTOM);
}

int bytesToInteger(List<int> bytes) {
  //byte to Uint8 변환
  var value = 0;
  for (var i = 0, length = bytes.length; i < length; i++) {
    value += (bytes[i] * pow(256, i)).toInt();
  }
  return value;
}

const String validEmail = r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
bool checkEmailPattern(String email) {
  RegExp validEmailStr = RegExp(validEmail);
  if (email.trim().isEmpty || !validEmailStr.hasMatch(email)) {
    return false;
  } else if (email.isEmpty) {
    return false;
  }
  return true;
}

void fieldFocusChange(BuildContext context, FocusNode? currentFocus, FocusNode? nextFocus) {
  currentFocus?.unfocus();
  FocusScope.of(context).requestFocus(nextFocus);
}

showSimpleAlertDialog(BuildContext context, String text) {
  // set up the button
  Widget okButton = TextButton(
    child: Text("확인", style: Theme.of(context).textTheme.headline3,),
    onPressed: () {
      Navigator.pop(context);
    },
  );
  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    content: Text(text),
    actions: [
      okButton,
    ],
  );
  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

/// 로딩, 로딩중 뒤로가기 처리
Widget getBaseWillScope(BuildContext context, Widget? body, {Function? onWillScope, String? routes}){
  return WillPopScope(
    onWillPop: () async{
      if(context.read<DataProvider>().isLoading){
        Fluttertoast.showToast(msg:"로딩중입니다");
        return false;
      }
      if(onWillScope!=null){
        await onWillScope();
        return true;
      }
      Navigator.pop(context);
      return true;
    },
    child: Stack(
        children: [
          if(body != null)Positioned(
            left: 0, right: 0, top: 0, bottom: 0,
            child: body,
          ),
          if(context.watch<DataProvider>().isLoading)Positioned(
            left: 0, right: 0, top: 0, bottom: 0,
            child: getLoading(context),
          ),
        ]
    )
  );
}

Widget getLoading(BuildContext context) {
  return Container(
      width: double.maxFinite,
      height: double.maxFinite,
      color: AppColors.backgroundGrey.withOpacity(0.5),
      child: const Center(
          child: CircularProgressIndicator(
            color: AppColors.borderGrey,
          )
      )
  );
}