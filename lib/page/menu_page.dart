import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:sleepaid/app_routes.dart';
import 'package:sleepaid/data/local/app_dao.dart';
import 'package:sleepaid/main.dart';
import 'package:sleepaid/provider/bluetooth_provider.dart';
import 'package:sleepaid/util/app_colors.dart';
import 'package:sleepaid/util/app_strings.dart';
import 'package:sleepaid/util/statics.dart';
import 'package:sleepaid/widget/base_stateful_widget.dart';
import 'package:sleepaid/widget/custom_switch_button.dart';
import 'package:provider/provider.dart';


class MenuPage extends BaseStatefulWidget {
  static const ROUTE = "/Menu";

  const MenuPage({Key? key}) : super(key: key);

  @override
  MenuState createState() => MenuState();
}

class MenuState extends State<MenuPage>
    with SingleTickerProviderStateMixin{

  Map<String, Function> listeners  = {};
  bool isDarkMode = false;
  @override
  void initState() {
    isDarkMode = AppDAO.isDarkMode;
    super.initState();
  }

  @override
  Widget build(BuildContext context){
    initListeners(context);

    return Scaffold(
        appBar: appBar(context, '설정', isRound: false,),
        extendBody: false,
        resizeToAvoidBottomInset: true,
        body: SafeArea(
            child: Container(
                width: double.maxFinite,
                height: double.maxFinite,
                alignment: Alignment.topCenter,
                decoration: BoxDecoration(
                    border: Border(top: BorderSide(color:AppColors.borderGrey.withOpacity(0.4), width:1))
                ),
                child: Column(
                  children: [
                    ...getButtons(context),
                  ],
                )
            )
        )
    );
  }


  List<Widget> getButtons(BuildContext context) {
    List<Widget> buttons = [];
    for (var title in AppStrings.menuStrings) {
      Widget subWidget = const SizedBox.shrink();
      if(title == AppStrings.menu_bluetooth_connect){
        subWidget = Text(_getConnectedDeviceText(context),
            overflow: TextOverflow.ellipsis,
            style:const TextStyle(fontSize: 12, color:AppColors.subTextBlack, fontWeight: FontWeight.bold));
      }else if(title == AppStrings.menu_version_info){
        subWidget = Text(AppDAO.appVersion,
            style:const TextStyle(fontSize: 12, color:AppColors.subTextBlack, fontWeight: FontWeight.bold));
      }else if(title == AppStrings.menu_dark_mode){
        subWidget = CustomSwitchButton(
          value: isDarkMode,
          onChanged: (value) async {
            await listeners[title]!(context);
          },
        );
      }
      Widget button = Container();
      if(title == AppStrings.menu_dark_mode){
        button = Container(
            height: 60,
            decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color:AppColors.borderGrey.withOpacity(0.4), width:1))
            ),
            padding: const EdgeInsets.only(left: 18, right: 18),
            width: double.maxFinite,
            child: Row(
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: Theme.of(context).textSelectionTheme.selectionColor,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Expanded(child: SizedBox.shrink()),
                  subWidget
                ]
            )
        );
      }else{
        button = InkWell(
            onTap:() async {
              if(title != AppStrings.menu_dark_mode){
                await listeners[title]!(context);
              }
            },
            child: Container(
                height: 60,
                decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(color:AppColors.borderGrey.withOpacity(0.4), width:1))
                ),
                padding: const EdgeInsets.only(left: 18, right: 18),
                width: double.maxFinite,
                child: Row(
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          color: Theme.of(context).textSelectionTheme.selectionColor,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Expanded(child: SizedBox.shrink()),
                      // Expanded(child: subWidget)
                      subWidget
                    ]
                )
            )
        );
      }
      buttons.add(button);
    }

    return buttons;
  }

  void initListeners(BuildContext context) {
    listeners = {
      AppStrings.menu_bluetooth_connect: (context) async{
        Navigator.pushNamed(context, Routes.bluetoothConnect);
      },
      AppStrings.menu_version_info: (context)async{

      },
      AppStrings.menu_push_notificatin: (context)async{
        Navigator.pushNamed(context, Routes.push);
      },

      AppStrings.menu_dark_mode: (context) async {
        if (AppDAO.isDarkMode) {
          await AppDAO.setDarkMode(false);
          isDarkMode = false;
          SleepAIDApp.of(context)?.changeTheme();
        } else{
          await AppDAO.setDarkMode(true);
          isDarkMode = true;
          SleepAIDApp.of(context)?.changeTheme();
        }
      },
      AppStrings.menu_logout: (BuildContext context) async {
        await context.read<BluetoothProvider>().clearBluetooth();
        await AppDAO.clearAllData();
        Navigator.pushReplacementNamed(context, Routes.loginList);
      },
    };
  }

  String _getConnectedDeviceText(BuildContext context) {
    String text = "";
    if(context.watch<BluetoothProvider>().deviceNeck!=null
        && context.watch<BluetoothProvider>().deviceNeck?.id != ""){
      text = "${context.watch<BluetoothProvider>().deviceNeck?.deviceName}(목) ";
    }
    if(context.watch<BluetoothProvider>().deviceForehead != null
        && context.watch<BluetoothProvider>().deviceForehead?.id != ""){
      text = text + "${context.watch<BluetoothProvider>().deviceForehead?.deviceName}(이마) ";
    }
    return text;
  }
}