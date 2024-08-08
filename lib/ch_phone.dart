import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import 'Ver_ph.dart';
import 'dataa.dart';
class ch_phone extends StatefulWidget {
  const ch_phone({Key? key}) : super(key: key);

  @override
  State<ch_phone> createState() => _ch_phoneState();
}

class _ch_phoneState extends State<ch_phone> {
  @override
  final auth=FirebaseAuth.instance;
  var _phone=TextEditingController();
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient:LinearGradient(
            begin: Alignment.bottomCenter,end: Alignment.topCenter,
            colors: [Colors.black,Color(0xff02182E),]),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(backgroundColor: Colors.transparent,elevation:0,
          automaticallyImplyLeading: false,
          leading: IconButton(onPressed: (){Navigator.of(context).pop();}, icon:Icon(Icons.arrow_back,size: 30,color: Colors.white,)),),

        body: Consumer<dataa>(builder:(context,D, child) {
         return SingleChildScrollView(
           child: Column(crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 SizedBox(height: 20,),
                 Align(alignment:Alignment.center,child: Image.asset("pic/log-in.png",height:250,)),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text((AppLocalizations.of(context)!.change),style:TextStyle(fontWeight:FontWeight.bold,fontSize:40,color: Color(0xfff8c520)),),
                    Padding(
                      padding: const EdgeInsets.only(top:8),
                      child: Text((AppLocalizations.of(context)!.phonenum),style:TextStyle(fontWeight:FontWeight.bold,fontSize:18,color:Colors.white,)),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left:18,right: 18),
                child: Text((AppLocalizations.of(context)!.enter_n_num),style:TextStyle(fontWeight:FontWeight.bold,fontSize:16,color:Colors.white,)),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(height: 80,
                  child: IntlPhoneField(style: TextStyle(color: Colors.white,fontSize:18),
                    controller: _phone,
                    decoration: InputDecoration(focusColor: Colors.yellow,
                      fillColor: Colors.white,labelStyle: TextStyle(color: Colors.white),
                      labelText: (AppLocalizations.of(context)!.phonenum),counterStyle: TextStyle(color: Colors.white),prefixStyle: TextStyle(color: Colors.white),
                      floatingLabelStyle: TextStyle(color: Colors.white),prefixIconColor: Colors.white,
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.yellow),
                      ),
                    ),
                    initialCountryCode: 'EG',
                    onChanged: (phone) {
                      setState(() {
                      });
                    },
                  ),
                ),
              ),
              _phone.text.length==10?Align(alignment:Alignment.center,
                child: ElevatedButton(onPressed: ()async{
                  late BuildContext dialogContext = context;
                  late BuildContext sdialogContext = context;
                  late BuildContext cdialogContext = context;
                  try {
                    await FirebaseAuth.instance.verifyPhoneNumber(
                      phoneNumber: "+20${_phone.text}",
                      verificationCompleted:(PhoneAuthCredential credential) async {print("done");},
                      verificationFailed: (FirebaseAuthException e) {
                        Timer? timer = Timer(Duration(milliseconds: 3000), (){
                          Navigator.pop(dialogContext);
                        });
                        showDialog(
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
                        }); },
                      codeAutoRetrievalTimeout: (String verificationId) {},
                    )
                        .catchError((err) {
                      Timer? timer = Timer(Duration(milliseconds: 3000), (){
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
                    Fluttertoast.showToast(
                        msg: "$e",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor:Color(0xfff4af36),
                        textColor: Colors.white,
                        fontSize: 16.0
                    );
                  }},
                  child:Text((AppLocalizations.of(context)!.verify),style: TextStyle(color: Colors.black,fontSize: 22,fontWeight: FontWeight.bold),),style:
                  ElevatedButton.styleFrom(shape: StadiumBorder(),
                      fixedSize: Size(250, 50),
                      side: BorderSide(),
                      backgroundColor:Color(0xfff8c520)
                  ),
                ),
              ):Align(alignment: Alignment.center,
                child: ElevatedButton(onPressed:
                    (){
                }
                  , child:Text((AppLocalizations.of(context)!.verify),style: TextStyle(color:Colors.black,fontSize: 22),),style:
                  ElevatedButton.styleFrom(shape: StadiumBorder(),
                      fixedSize: Size(250, 50),
                      side: BorderSide(),
                      backgroundColor:Colors.grey),),
              )
            ]),
         );}
        ), ),
    );
  }
}
