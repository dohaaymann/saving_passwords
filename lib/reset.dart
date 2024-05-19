import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:flutter_shake_animated/flutter_shake_animated.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:passcode_screen/circle.dart';
import 'package:passcode_screen/keyboard.dart';
import 'package:passcode_screen/passcode_screen.dart';
import 'package:provider/provider.dart';
import 'package:saving_password/passwords.dart';
import 'package:saving_password/sql.dart';

import 'dataa.dart';
class reset extends StatefulWidget {
  var ver_id,phone;

  reset({required this.ver_id,required this.phone,}){
    print(phone);
  }

  @override
  State<reset> createState() => _resetState();
}
SQLDB sql=SQLDB();
class _resetState extends State<reset> {
  @override
  final StreamController<bool> _verificationNotifier = StreamController<bool>.broadcast();
  bool isAuthenticated = false;

  @override
  void dispose() {
    _verificationNotifier.close();
    super.dispose();
  }
  var l;
  var enteredpass="";
  var storedpass="";
  final auth=FirebaseAuth.instance;
  // final User=FirebaseFirestore.instance.collection("account");
  var _phone=TextEditingController();
  Color accentPurpleColor = Color(0xFF6A53A1);
  Color primaryColor = Color(0xFF121212);
  Color accentPinkColor = Color(0xFFF99BBD);
  Color accentDarkGreenColor = Color(0xFF115C49);
  Color accentYellowColor = Color(0xFFFFB612);
  Color accentOrangeColor = Color(0xFFEA7A3B);
  var otpController = TextEditingController();
  Widget build(BuildContext context) {
    _showLockScreenverify(BuildContext context,
        {required bool opaque,
          required CircleUIConfig circleUIConfig,
          required KeyboardUIConfig keyboardUIConfig,
          required Widget cancelButton,
          required List<String> digits}) {
      var t="Verify your new Passcode";
      Navigator.push(
          context,
          PageRouteBuilder(
            opaque: opaque,
            pageBuilder: (context, animation, secondaryAnimation) => PasscodeScreen(
              title: Text(
                (AppLocalizations.of(context)!.ver_pass),
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 28),
              ),
              circleUIConfig: circleUIConfig,
              keyboardUIConfig: keyboardUIConfig,
              passwordEnteredCallback:(String enteredPasscode)async {
                bool isValid =enteredpass.toString()==enteredPasscode.toString();
                if(isValid)
                {
                  var res=await sql.updatetoall({"stored":"$enteredPasscode"});
                  print(res);
                  Navigator.of(context).pop();
                  print("Validdddddddddddd");
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) =>passwords(ln:l)));
                  setState(() {
                    this.isAuthenticated = true;
                    storedpass=enteredPasscode;
                  });
                }else{
                  setState(() {
                    t="passcodes did not match,Try again";
                  });
                }
                _verificationNotifier.add(isValid);
              },
              cancelButton: cancelButton,
              deleteButton: Text(
                (AppLocalizations.of(context)!.delete),
                style: const TextStyle(fontSize: 16, color: Colors.white),
                semanticsLabel: 'Delete',
              ),
              shouldTriggerVerification: _verificationNotifier.stream,
              backgroundColor: Colors.black.withOpacity(0.8),
              cancelCallback:(){ Navigator.maybePop(context);},
              digits: digits,
              passwordDigits:5,
            ),
          ));
    }
    _showLockScreenset(BuildContext context,
        {required bool opaque,
          required CircleUIConfig circleUIConfig,
          required KeyboardUIConfig keyboardUIConfig,
          required Widget cancelButton,
          required List<String> digits}) {
      Navigator.push(
          context,
          PageRouteBuilder(
            opaque: opaque,
            pageBuilder: (context, animation, secondaryAnimation) => PasscodeScreen(
              title: Text(
                (AppLocalizations.of(context)!.set_p),
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 28),
              ),
              circleUIConfig: circleUIConfig,
              keyboardUIConfig: keyboardUIConfig,
              passwordEnteredCallback:(String enteredPasscode) {setState(() {
                enteredpass=enteredPasscode;
              });
              print(enteredpass);
              print(enteredPasscode);
              Navigator.pop(context);
               _showLockScreenverify(
                context,
                opaque: false,
                cancelButton: Text(
                  (AppLocalizations.of(context)!.cancel),
                  style: const TextStyle(fontSize: 16, color: Colors.white,),
                  semanticsLabel: 'Cancel',
                ), circleUIConfig:CircleUIConfig(), keyboardUIConfig:KeyboardUIConfig(), digits: [],
              );
              },
              cancelButton: cancelButton,
              deleteButton: Text(
                (AppLocalizations.of(context)!.delete),
                style: const TextStyle(fontSize: 16, color: Colors.white),
                semanticsLabel: 'Delete',
              ),
              shouldTriggerVerification: _verificationNotifier.stream,
              backgroundColor:Colors.black.withOpacity(0.8),
              cancelCallback:(){ Navigator.maybePop(context);},
              digits: digits,
              passwordDigits:5,
              bottomWidget: ElevatedButton(onPressed: ()async{
                var res=await sql.updatetoall({'stored':""});
                print(res);
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => passwords(ln:l),));
              },child: Text((AppLocalizations.of(context)!.removeLock)),),
            ),
          ));
    }
    var D=Provider.of<dataa>(context);
    late BuildContext dialogContext = context;
    TextStyle? createStyle(Color color) {
      ThemeData theme = Theme.of(context);
      return theme.textTheme.displaySmall?.copyWith(color: color);
    }  var otpTextStyles = [
      createStyle(accentPurpleColor),
      createStyle(accentYellowColor),
      createStyle(accentDarkGreenColor),
      createStyle(accentOrangeColor),
      createStyle(accentPinkColor),
      createStyle(accentPurpleColor),
    ];
    var otpController = TextEditingController();

    var dd="";
    final auth=FirebaseAuth.instance;
    var play=false,clear=false;
    return Consumer(builder: (context, value, child) {
      return Scaffold(resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(padding: EdgeInsets.only( bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            decoration: BoxDecoration(
              gradient:LinearGradient(
                  begin: Alignment.bottomCenter,end: Alignment.topCenter,
                  colors: [Colors.black,Color(0xff02182E),]),
            ), child: SizedBox(height: MediaQuery.of(context).size.height,
              child: Column(children: [
                SizedBox(height: 25,),
              Row(children: [IconButton(onPressed: () {
                Navigator.of(context).pop();
              }, icon: Icon(Icons.arrow_back_ios_new,color: Colors.white,))
              ],),
              SizedBox(height:30,),
              Image.asset("pic/smartphone.png",height: 240,),

              Container(
                  padding: EdgeInsets.only(top:20, left: 10, right: 20),
                  child:
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(
                      (AppLocalizations.of(context)!.resetpass),
                      style: TextStyle(color: Colors.white,
                          fontSize: 35,
                          fontWeight: FontWeight.bold),
                    ), Padding(
                      padding: const EdgeInsets.only(left:8),
                      child: Text(
                       "${(AppLocalizations.of(context)!.authenticate)} ${widget.phone}. "
                        , style: TextStyle(color: Colors.white70, fontSize: 17),),
                    ),
                    Padding(padding: EdgeInsets.all(4)),
                    ShakeWidget(autoPlay: play,
                      shakeConstant: ShakeCrazyConstant2(),
                      duration: Duration(milliseconds: 500),
                      child: OtpTextField(clearText: clear,
                        numberOfFields: 6,
                        borderColor: accentPurpleColor,
                        focusedBorderColor: accentPurpleColor,
                        styles: otpTextStyles,
                        showFieldAsBox: false,
                        borderWidth: 4.0,
                        onCodeChanged: (String code) {
                          D.ch_ver1(code);
                          print("____________________$code");
                        },
                        //runs when every textfield is filled
                        onSubmit: (String verificationCode) async {
                          D.ch_ver1(verificationCode);
                        },
                      ),
                    ),
                    SizedBox(height: 30,),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Align(
                        alignment: Alignment.center,
                        child: D.ver.toString().length==6?ElevatedButton(onPressed: () async {
                          l=D.ln;
                          late BuildContext dialogContext = context;
                          String smsCode = '${D.ver}';
                          try{
                            PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: widget.ver_id, smsCode:smsCode);
                           await auth.signInWithCredential(credential).then((value)async{
                              // var res=await sql.update({'phone':"$phone"},"id=1");
                              // print(res);verified

                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => passwords(ln: D.ln),)).then((value){
                                _showLockScreenset(
                                  context,
                                  opaque: false,
                                  cancelButton: Text(
                                    (AppLocalizations.of(context)!.cancel),
                                    style: const TextStyle(fontSize: 16, color: Colors.white,),
                                    semanticsLabel: 'Cancel',
                                  ), circleUIConfig:CircleUIConfig(), keyboardUIConfig:KeyboardUIConfig(), digits: [],
                                );});
                              });

                          }catch(e){
                            print("+++++++++++++++++++++++++++++++++++++++");
                            D.ch_ver1(0);
                            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) =>
                                reset(ver_id: widget.ver_id, phone: widget.phone),));
                          }
                        },
                          child: Text("${(AppLocalizations.of(context)!.continu)}",
                            style: TextStyle(fontWeight:FontWeight.bold,fontSize: 24, color: Colors.black),),
                          style: ElevatedButton.styleFrom(
                            shape: StadiumBorder(),
                              fixedSize: Size(200, 50),
                              side: BorderSide(),
                              backgroundColor: Color(0xffF8C520)),
                        ):ElevatedButton( style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent,
                            shape: StadiumBorder(),
                            fixedSize: Size(200, 50),
                            side: BorderSide(),
                            ),
                            onPressed: null, child:Text((AppLocalizations.of(context)!.continu),
                          style: TextStyle(fontWeight:FontWeight.bold,fontSize:24, color: Colors.black),),),
                      ),
                    )
                  ])),


          ]),
            ),
          ),
        ),
      );
    });
  }
}

