import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:provider/provider.dart';
import 'package:flutter_shake_animated/flutter_shake_animated.dart';
import 'package:saving_password/key.dart';
import 'package:saving_password/passwords.dart';
import 'package:saving_password/sql.dart';
import 'dataa.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class ver_ph extends StatefulWidget {
  var ver_id,gmail,pass,phone;
  final User=FirebaseFirestore.instance.collection("account");

  ver_ph({required this.ver_id,required this.phone,}){
  }
  @override
  State<ver_ph> createState() => _ver_phState();
}

class _ver_phState extends State<ver_ph> {
  @override
  SQLDB sql=SQLDB();
  var null_=true;
  Color accentPurpleColor = Color(0xFF6A53A1);
  Color primaryColor = Color(0xFF121212);
  Color accentPinkColor = Color(0xFFF99BBD);
  Color accentDarkGreenColor = Color(0xFF115C49);
  Color accentYellowColor = Color(0xFFFFB612);
  Color accentOrangeColor = Color(0xFFEA7A3B);
  Widget build(BuildContext context) {
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

    var dd=""; var sms="";
    final auth=FirebaseAuth.instance;
    final StreamController<bool> _verificationNotifier = StreamController<bool>.broadcast();
    @override
    void dispose() {
      _verificationNotifier.close();
      super.dispose();
    }
    var play=false,clear=false;
    return Consumer<dataa>(builder: (context, D, child) {
      return WillPopScope(onWillPop: ()async{
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => passwords(ln:D.ln),));
        return false;
      },
        child: Scaffold(resizeToAvoidBottomInset: false,
          body: Directionality(textDirection:D.ln?TextDirection.ltr:TextDirection.rtl,
            child: Container(
              // color: Color.fromRGBO(0,25,52,1),
              decoration: BoxDecoration(
              gradient:LinearGradient(
                  begin: Alignment.bottomCenter,end: Alignment.topCenter,
                  colors: [Colors.black,Color(0xff02182E),]),
            ),
              child: SingleChildScrollView(padding: EdgeInsets.only( bottom: MediaQuery.of(context).viewInsets.bottom),
                child: SizedBox(height:MediaQuery.of(context).size.height,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top:22),
                        child: Align(alignment:Alignment.topLeft,child: IconButton(onPressed: (){Navigator.of(context).pop();}, icon:Icon(color:Colors.white,Icons.arrow_back_ios_new))),
                      ),
                      SizedBox(height: 25,),
                      Image.asset("pic/bar-chart.png",height:200,),
                      Container( padding: EdgeInsets.only(top: 10, left: 10, right: 20),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            D.ln?
                            Row(
                              children: [
                                Text((AppLocalizations.of(context)!.verification),style: TextStyle(color:Color(0xfff8c520),fontSize: 35, fontWeight: FontWeight.bold),),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text((AppLocalizations.of(context)!.code),style: TextStyle(color:Colors.white,fontSize: 18, fontWeight: FontWeight.bold),),
                                ),
                              ],
                            ): Row(
                              children: [
                                Text((AppLocalizations.of(context)!.code),style: TextStyle(color:Color(0xfff8c520),fontSize: 35, fontWeight: FontWeight.bold),),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text((AppLocalizations.of(context)!.verification),style: TextStyle(color:Colors.white,fontSize: 18, fontWeight: FontWeight.bold),),
                                ),
                              ],
                            )
                            ,
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("${(AppLocalizations.of(context)!.sendsms)} ${widget.phone}", style: TextStyle(color: Colors.white,
                                      fontSize: 18, fontWeight: FontWeight.bold),),
                                ],
                              ),
                            ),SizedBox(height:40,),
                            ShakeWidget(
                              shakeConstant:ShakeCrazyConstant2(),duration: Duration(milliseconds:1000),
                              child: Container(
                                child: OtpTextField (
                                  numberOfFields: 6,
                                  borderColor: accentPurpleColor,
                                  focusedBorderColor: accentPurpleColor,

                                  styles: otpTextStyles,
                                  showFieldAsBox: false,
                                  borderWidth: 4.0,
                                  onCodeChanged: (String code) {
                                  },
                                  //runs when every textfield is filled
                                  onSubmit: (String verificationCode){
                                    setState(() {
                                      sms=verificationCode;
                                      D.ch_ver1(verificationCode);
                                    });
                                  },
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text((AppLocalizations.of(context)!.dontrecive),
                                    style: TextStyle(color:Colors.white,fontSize: 20),),
                                ),
                                TextButton(onPressed:null_?()async{
                                  setState(() {
                                    null_=false;
                                  });
                                  Timer? timer = Timer(Duration(seconds:15), (){
                                           setState(() {
                                              null_=true;
                                           });
                                   });
                                  await FirebaseAuth.instance.verifyPhoneNumber(
                                    phoneNumber: widget.phone,timeout: Duration(seconds: 30),
                                    verificationCompleted: (PhoneAuthCredential credential) {},
                                    verificationFailed: (FirebaseAuthException e) {},
                                    codeSent: (String verificationId, int? resendToken) {},
                                    codeAutoRetrievalTimeout: (String verificationId) {
                                      setState(() {
                                        widget.ver_id=verificationId;
                                      });
                                    },
                                  );
                                }:null,
                                    child: Text(
                                      (AppLocalizations.of(context)!.sendagain), style: TextStyle(color:null_?Colors.blueAccent:Colors.grey,fontSize: 18),))
                              ],
                            ),

                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Align(alignment: Alignment.center,
                                child:D.ver.toString().length==6?ElevatedButton(style:
                                ElevatedButton.styleFrom(
                                    fixedSize: Size(250, 50),
                                    shape: StadiumBorder(),
                                    backgroundColor: Color(0xffF8C520)),
                                    onPressed: () async{
                                      var isValid;
                                      try{
                                        PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: widget.ver_id, smsCode:D.ver);
                                        await auth.signInWithCredential(credential).then((value)async{
                                          _verificationNotifier.add(true);
                                          var res=await sql.updatelock({'phone':"${widget.phone}"});
                                          showDialog( context: context,
                                              builder: (BuildContext context) {dialogContext=context;
                                              return Container(
                                                height: 200,width: 200,
                                                child: AlertDialog(
                                                    insetPadding: EdgeInsets.all(4),
                                                    contentPadding: EdgeInsets.all(12),
                                                    shape: OutlineInputBorder(
                                                        borderSide: BorderSide.none),
                                                    backgroundColor:Colors.white,
                                                    title:   Image.asset("pic/verified.png",height: 100,),
                                                    content:Padding(padding:EdgeInsets.all(10),
                                                        child: Text((AppLocalizations.of(context)!.verifiedsuc),textAlign:TextAlign.center,style: TextStyle(fontWeight:FontWeight.bold,fontSize: 22),))),
                                              );});
                                            Timer? timer = Timer(Duration(milliseconds: 3000), (){
                                              Navigator.pop(dialogContext);
                                              Navigator.of(context).push(MaterialPageRoute(builder: (context) =>key(),));
                                            });
                                           });

                                      }catch(e){
                                        D.ch_ver1(0);
                                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) =>
                                           ver_ph(ver_id: widget.ver_id, phone: widget.phone),));
                                          }
                                      }, child: Text((AppLocalizations.of(context)!.confirm), style: TextStyle(fontWeight:FontWeight.bold,color: Colors
                                        .white, fontSize: 22),))
                                    :ElevatedButton(style:
                                ElevatedButton.styleFrom(shape: StadiumBorder(),
                                    fixedSize: Size(250, 50),
                                    side: BorderSide(),
                                    backgroundColor: Colors.blueGrey),
                                    onPressed:(){
                                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => verified(),));
                                    },child: Text((AppLocalizations.of(context)!.confirm), style: TextStyle(color: Colors.black, fontSize: 22),)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );});
  }
}