import 'dart:async';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:passcode_screen/circle.dart';
import 'package:passcode_screen/keyboard.dart';
import 'package:passcode_screen/passcode_screen.dart';
import 'package:provider/provider.dart';
import 'package:saving_password/ch_phone.dart';
import 'package:saving_password/passwords.dart';
import 'package:saving_password/sql.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'Ver_ph.dart';
import 'dataa.dart';
var enteredpass="";
var storedpass="";
class key extends StatefulWidget {
  const key();

  @override
  State<key> createState() => _keyState();
}
SQLDB sql=SQLDB();
class _keyState extends State<key> {
  @override
 
  final auth=FirebaseAuth.instance;
  var _phone=TextEditingController();

  @override
  var phonenum="";
  selectphone()async{
    var res=await sql.selectphone();
    var y=res.toList().first;
    for (final e in y.entries) {
      setState(() {
        phonenum=e.value.toString();});
    }
  } selectstored()async{
    var res=await sql.selectstored();
    var y=res.toList().first;
    for (final e in y.entries) {
      setState(() {
        storedpass=e.value.toString();});
    }  print(phonenum);
    print(storedpass);
  }
  void initState() {

    selectphone();
    selectstored();
    super.initState();
  }
  Widget build(BuildContext context) {
    var D=Provider.of<dataa>(context);
    return phonenum.length==0?Scaffold(resizeToAvoidBottomInset:false,
      backgroundColor:Color(0xff02182E),
      appBar: AppBar(elevation: 0,backgroundColor:Color(0xff02172C),),
      body:Container(width: double.infinity,height: double.infinity, decoration: BoxDecoration(
        gradient:LinearGradient(
            begin: Alignment.bottomCenter,end: Alignment.topCenter,
            colors: [Colors.black,Color(0xff02182E),]),
      ),
        // decoration:
        // BoxDecoration(
        //   image: DecorationImage(
        //     image: AssetImage("pic/mix2.jpeg"),
        //     fit: BoxFit.cover,colorFilter: ColorFilter.mode(Colors.black12, BlendMode.color),
        //   ),
        // ),
        child: SingleChildScrollView(padding: EdgeInsets.only( bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Align(alignment: Alignment.center,child:Image.asset("pic/login.png",height: 250,) ,),
            ), Padding(
              padding: const EdgeInsets.all(15),
              child: Text((AppLocalizations.of(context)!.youcanaddlock),style: TextStyle(color:Colors.white70,fontSize:18),),
            ),
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(height: 80,
                child: IntlPhoneField(
                  style: TextStyle(color: Colors.white,fontSize:18),
                  controller: _phone,initialValue: auth.currentUser?.phoneNumber,
                  dropdownTextStyle: TextStyle(color:Colors.white,fontSize:18),
                  decoration: InputDecoration(focusColor: Colors.redAccent,enabledBorder:
                  OutlineInputBorder(
                    borderSide: BorderSide(width: 3, color: Colors.white),
                  ),
                    fillColor: Colors.white,labelStyle: TextStyle(color: Colors.white),
                    labelText: (AppLocalizations.of(context)!.phonenum),counterStyle: TextStyle(color: Colors.white),prefixStyle: TextStyle(color: Colors.white),
                    floatingLabelStyle: TextStyle(color: Colors.white),prefixIconColor: Colors.white,
                    border: OutlineInputBorder(
                      borderSide: BorderSide(),
                    ),
                  ),
                  initialCountryCode: 'EG',
                  onChanged: (phone) {
                    D.ch_ph(phone.completeNumber);
                    print("------------${phone.completeNumber}");
                  },
                ),
              ),
            ),
            _phone.text.length==10?ElevatedButton(onPressed: ()async{
              print(_phone.text);
              late BuildContext dialogContext = context;
              late BuildContext sdialogContext = context;
              late BuildContext cdialogContext = context;
              try {
                print("--------------------+20${_phone.text}");
                await FirebaseAuth.instance.verifyPhoneNumber(
                  phoneNumber: "+20${_phone.text}",
                  verificationCompleted:(PhoneAuthCredential credential) async {print("done");},
                  verificationFailed: (FirebaseAuthException e) {
                    Timer? timer = Timer(Duration(milliseconds: 3000), (){
                      print("//////////////////////////////////////////////////////");
                      Navigator.pop(dialogContext);
                    });
                    print(("//////////////////$e"));
                    showDialog(
                      //
                        context: context,
                        builder: (BuildContext context) {dialogContext = context;
                        return AlertDialog(
                            insetPadding: EdgeInsets.all(4),
                            contentPadding: EdgeInsets.all(12),
                            shape: OutlineInputBorder(
                                borderSide: BorderSide.none),
                            backgroundColor: Color(0xfff4af36),
                            content: Text(
                              (AppLocalizations.of(context)!.incorrect),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.black),
                            ));
                        });
                  },
                  codeSent: (String verificationId, int? resendToken) {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          cdialogContext = context;
                          return Container( color:Colors.black45,height:double.infinity,child: Center(child:
                          SizedBox(height:50,width:50,child: CircularProgressIndicator(color: Colors.white,strokeWidth:7,))));});

                    Timer(Duration(seconds: 3), (){
                      Navigator.pop(cdialogContext);
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ver_ph(
                          ver_id: verificationId.toString(),
                          phone:"+20${_phone.text}",
                        ),
                      ));
                    });
                    print("==============================${D.ph}");

                  },
                  codeAutoRetrievalTimeout: (String verificationId) {},
                )
                    .catchError((err) {
                  Timer? timer = Timer(Duration(milliseconds: 3000), (){
                    print("//////////////////////////////////////////////////////");
                    Navigator.pop(dialogContext);
                  });
                  return showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        dialogContext=context;
                        return AlertDialog(
                            insetPadding: EdgeInsets.all(4),
                            contentPadding: EdgeInsets.all(12),
                            shape: OutlineInputBorder(
                                borderSide: BorderSide.none),
                            backgroundColor: Colors.black,
                            // backgroundColor:Color.fromRGBO(103, 0, 92,4),
                            content: Text(
                              err.message,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.white),
                            ));
                      });
                });
              } catch (e) {
                print("%%%%%%%%%%%%%%5$e");
                print(D.ph);
              }},
              child:Text((AppLocalizations.of(context)!.verify),style: TextStyle(color: Colors.black,fontSize: 22,fontWeight: FontWeight.bold),),style:
              ElevatedButton.styleFrom(shape: StadiumBorder(),
                  fixedSize: Size(250, 50),
                  side: BorderSide(),
                  backgroundColor:Color(0xfff8c520)
              ),
            ):ElevatedButton(onPressed:
                (){print(D.ph);
            // print(_phone.text);
            //  Container( color:Colors.black45,height:double.infinity,child: Center(child:
            // SizedBox(height:50,width:50,child: CircularProgressIndicator(color: Colors.white,strokeWidth:7,))));
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ver_ph(
                ver_id: "verificationId.toString()",
                phone:"+20${D.ph}",
              ), ));
             }
              , child:Text((AppLocalizations.of(context)!.verify),style: TextStyle(fontSize: 22),),style:
              ElevatedButton.styleFrom(shape: StadiumBorder(),
                  fixedSize: Size(250, 50),
                  side: BorderSide(),
                  backgroundColor:Colors.grey),)
          ],),
        ),
      ),


    ):verified();
  }
}

class verified extends StatefulWidget {
  const verified({Key? key}) : super(key: key);

  @override
  State<verified> createState() => _verifiedState();
}

class _verifiedState extends State<verified> {
  @override
  final StreamController<bool> _verificationNotifier = StreamController<bool>.broadcast();
  bool isAuthenticated = false;
var l;
  @override
  void dispose() {
    _verificationNotifier.close();
    super.dispose();
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
                semanticsLabel: (AppLocalizations.of(context)!.cancel),
              ), circleUIConfig:CircleUIConfig(), keyboardUIConfig:KeyboardUIConfig(), digits: [],
            );
              },
            cancelButton: cancelButton,
            deleteButton: Text(
              (AppLocalizations.of(context)!.delete),
              style: const TextStyle(fontSize: 16, color: Colors.white),
              semanticsLabel: (AppLocalizations.of(context)!.delete),
            ),
            shouldTriggerVerification: _verificationNotifier.stream,
            backgroundColor:Colors.black.withOpacity(0.8),
            cancelCallback:(){ Navigator.maybePop(context);},
            digits: digits,
            passwordDigits:5,
            // bottomWidget: _passcodeRestoreButton(),
          ),
        ));
  } _showLockScreenverify(BuildContext context,
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
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) =>
                        passwords(ln:l)
                    ));
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
              semanticsLabel:(AppLocalizations.of(context)!.delete),
            ),
            shouldTriggerVerification: _verificationNotifier.stream,
            backgroundColor: Colors.black.withOpacity(0.8),
            cancelCallback:(){ Navigator.maybePop(context);},
            digits: digits,
            passwordDigits:5,
            // bottomWidget: _passcodeRestoreButton(),
          ),
        ));
  }
  _showLockScreenreset(BuildContext context,
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
              (AppLocalizations.of(context)!.enter_n_pass),
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 28),
            ),
            circleUIConfig: circleUIConfig,
            keyboardUIConfig: keyboardUIConfig,
            passwordEnteredCallback:(String enteredPasscode) async{
              setState(() {
              storedpass=enteredPasscode;
            }); var res=await sql.updatetoall({"stored":"$enteredPasscode"});
              print(res);
              print("done");
              Navigator.of(context).pop();
            },
            cancelButton: cancelButton,
            deleteButton: Text(
              (AppLocalizations.of(context)!.delete),
              style: const TextStyle(fontSize: 16, color: Colors.white),
              semanticsLabel:(AppLocalizations.of(context)!.delete),
            ),
            shouldTriggerVerification: _verificationNotifier.stream,
            backgroundColor: Colors.black.withOpacity(0.8),
            cancelCallback:(){ Navigator.maybePop(context);},
            digits: digits,
            passwordDigits:5,
            // bottomWidget: _passcodeRestoreButton(),
          ),
        ));
  } _showLockScreenpass(BuildContext context,
      {required bool opaque,required String te,
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
              '$te',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 28),
            ),
            circleUIConfig: circleUIConfig,
            keyboardUIConfig: keyboardUIConfig,
            passwordEnteredCallback:(String enteredPasscode) {
              bool isValid=storedpass.toString()==enteredPasscode.toString();
             if(isValid){
               Navigator.of(context).pop();
               _showLockScreenreset(
                 context,
                 opaque: false,
                 cancelButton: Text(
                   (AppLocalizations.of(context)!.cancel),
                   style: const TextStyle(fontSize: 16, color: Colors.white,),
                   semanticsLabel: (AppLocalizations.of(context)!.cancel),
                 ), circleUIConfig:CircleUIConfig(), keyboardUIConfig:KeyboardUIConfig(), digits: [],
               );
             }
             _verificationNotifier.add(isValid);
            },
            cancelButton: cancelButton,
            deleteButton: Text(
              (AppLocalizations.of(context)!.delete),
              style: const TextStyle(fontSize: 16, color: Colors.white),
              semanticsLabel:(AppLocalizations.of(context)!.delete),
            ),
            shouldTriggerVerification: _verificationNotifier.stream,
            backgroundColor: Colors.black.withOpacity(0.8),
            cancelCallback:(){ Navigator.maybePop(context);},
            digits: digits,
            passwordDigits:5,
            // bottomWidget: _passcodeRestoreButton(),
          ),
        ));
  }
  Widget build(BuildContext context) {
    return
      WillPopScope(onWillPop: ()async{
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => passwords(ln:true),));
        return false;
      },
        child: Consumer<dataa>(builder: (context,D, child) {
       return Scaffold(
          body:
          Container(width: double.infinity,height: double.infinity,
              decoration: BoxDecoration(
              gradient:LinearGradient(
              begin: Alignment.topCenter,end: Alignment.bottomCenter,
              colors: [
                Color(0xfff4af36),Color(0xff02182E),Colors.black,]),
       ),
              child: Column(children: [
                Padding(
                  padding: const EdgeInsets.only(top:30,left:8,right: 8),
                  child: Align(alignment:D.ln?Alignment.topLeft:Alignment.topRight,child: IconButton(onPressed: (){
                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => passwords(ln:D.ln),));
                  }, icon: Icon(Icons.arrow_back_ios,size:30,color: Colors.white,))),
                ),
                SizedBox(height:20,),
               Image.asset("pic/giphy (1).gif",height: 350,),
                SizedBox(height:60,),
               storedpass.length==5?ElevatedButton(onPressed:()async {
                 l=D.ln;
                 showDialog(context: context, builder:(context) {
                   return SizedBox(height: 40,width: 200,
                     child: AlertDialog( backgroundColor: Color.fromRGBO(0,25,52,1),contentPadding: EdgeInsets.all(0),
                         shape:UnderlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                         title: Text((AppLocalizations.of(context)!.removeLock),textAlign: TextAlign.center,style: TextStyle(color:Colors.white,fontSize: 20,fontWeight: FontWeight.bold),),
                         actions:[
                           Column(
                             children:[
                               Row( mainAxisAlignment: MainAxisAlignment.spaceAround,
                                 children: [
                                   Container(margin:EdgeInsetsDirectional.only(top: 1,end: 5),child: ElevatedButton(style:
                                   ElevatedButton.styleFrom(backgroundColor: Color(0xfff4af36)),
                                       onPressed: (){
                                         Navigator.pop(context);
                                       },
                                       child:Text((AppLocalizations.of(context)!.cancel),textAlign: TextAlign.center,style: TextStyle(fontSize: 20),))),
                                   Container( margin:EdgeInsetsDirectional.only(top: 1,end: 5),child: ElevatedButton(
                                       style: ElevatedButton.styleFrom(backgroundColor: Color(0xfff4af36)),
                                       onPressed: () async{
                                         setState(() async {
                                         var res=await sql.updatetoall({'stored':''});
                                         // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Key(),));
                                         print(res);
                                         });

                                       },
                                       child:Text((AppLocalizations.of(context)!.remove),textAlign: TextAlign.center,style: TextStyle(fontSize: 20),))),
                                 ],)],
                           ),
                         ]
                     ),
                   );});

               }, child:Text((AppLocalizations.of(context)!.removepa),style: TextStyle(color:Colors.black,fontWeight:FontWeight.bold,fontSize: 22),),style:
               ElevatedButton.styleFrom(shape: StadiumBorder(),
                   fixedSize: Size(300, 50),
                   side: BorderSide(),
                   backgroundColor:Color(0xfff8c520))):
               ElevatedButton(onPressed: (){
                 print(storedpass);
                 print(enteredpass);
                 _showLockScreenset(
                   context,
                   opaque: false,
                   cancelButton: Text(
                     (AppLocalizations.of(context)!.cancel),
                     style: const TextStyle(fontSize: 16, color: Colors.white,),
                     semanticsLabel: (AppLocalizations.of(context)!.cancel),
                   ), circleUIConfig:CircleUIConfig(), keyboardUIConfig:KeyboardUIConfig(), digits: [],
                 );

               }, child:Text((AppLocalizations.of(context)!.addpass),style: TextStyle(color:Colors.black,fontWeight:FontWeight.bold,fontSize: 22),),style:
               ElevatedButton.styleFrom(shape: StadiumBorder(),
                   fixedSize: Size(300, 50),
                   side: BorderSide(),
                   backgroundColor:Color(0xfff8c520))) ,

                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: storedpass.length==5?ElevatedButton(onPressed: (){
                    print(storedpass);
                    print(enteredpass);
                    _showLockScreenpass(
                      context,te: (AppLocalizations.of(context)!.enter_o_pass),
                      opaque: false,
                      cancelButton: Text(
                        (AppLocalizations.of(context)!.cancel),
                        style: const TextStyle(fontSize: 16, color: Colors.white,),
                        semanticsLabel:(AppLocalizations.of(context)!.cancel),
                      ), circleUIConfig:CircleUIConfig(), keyboardUIConfig:KeyboardUIConfig(), digits: [],
                    );
                  }, child:Text((AppLocalizations.of(context)!.resetpass),style: TextStyle(fontWeight:FontWeight.bold,color:Colors.black,fontSize: 22),),style:
               ElevatedButton.styleFrom(shape: StadiumBorder(),
                     fixedSize: Size(300, 50),
                     side: BorderSide(),
                     backgroundColor: Color(0xfff8c520),))
                :ElevatedButton(onPressed: null,child:Text((AppLocalizations.of(context)!.resetpass),style: TextStyle(fontWeight:FontWeight.bold,color:Colors.black,fontSize: 22),),style:
                ElevatedButton.styleFrom(shape: StadiumBorder(),
                  fixedSize: Size(300, 50),
                  side: BorderSide(),
                  backgroundColor: Colors.white70,)),),

                ElevatedButton(onPressed: (){
                 print(storedpass);
                 print(enteredpass);
                 Navigator.of(context).push(MaterialPageRoute(builder: (context) => ch_phone(),));
                }, child:Text((AppLocalizations.of(context)!.ch_ph),style: TextStyle(color:Colors.black,fontWeight:FontWeight.bold,fontSize: 22),),style:
               ElevatedButton.styleFrom(shape: StadiumBorder(),
                   fixedSize: Size(300, 50),
                   side: BorderSide(),
                   backgroundColor:  Color(0xfff8c520),)),
    ],)),
    );},
        ),
      );
  }
}
