import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:saving_password/passwords.dart';
import 'package:saving_password/sql.dart';
import 'animations/fade_through_transition.dart';
import 'dataa.dart';
class add_data extends StatefulWidget {
  bool ln;
  add_data({required this.ln}){
    print("**********");
    print(ln);
  }
  @override
  State<add_data> createState() => _add_dataState();
}

class _add_dataState extends State<add_data> {
  @override
  var textapp=new TextEditingController();
  var textuser=new TextEditingController();
  var textpass=new TextEditingController();
  var textnote=new TextEditingController();
  var texturl=new TextEditingController();
  SQLDB sql=SQLDB();
  Widget build(BuildContext context) {
    (context as Element).markNeedsBuild();
    var D=Provider.of<dataa>(context);
    return Directionality(textDirection: D.ln?TextDirection.ltr:TextDirection.rtl,
        child: Consumer<dataa>(builder: (context,D, child) {
          return  Scaffold(resizeToAvoidBottomInset: true,
            appBar: AppBar(backgroundColor: Color(0xff02182E),elevation: 0,
              title: Text((AppLocalizations.of(context)!.neww),style: TextStyle(fontSize:22,fontWeight: FontWeight.bold),),
              actions: [
                (textuser.text.isNotEmpty&&textapp.text.isNotEmpty)?InkWell(onTap: ()async{ var logo='pic/logo/lock.png';
                    if(textapp.text=='Facebook'||textapp.text=='facebook'||textapp.text=='face'||textapp.text=="فيسبوك"||textapp.text=="فيس"){
                      logo=("pic/logo/face.png");
                    }
                    else if(textapp.text=='github'||textapp.text=='Github'||textapp.text=='git'||textapp.text=="Git"||textapp.text=="جيت هوب"){
                      logo="pic/logo/github.png";
                    }else if(textapp.text=='Instagram'||textapp.text=='instagram'||textapp.text=='insta'||textapp.text=="Insta"||textapp.text=="انستجرام"||textapp.text=="انستا") {
                      logo="pic/logo/3955024.png";
                    }else if(textapp.text=='Google'||textapp.text=='google'||textapp.text=='Gmail'||textapp.text=="gmail"||textapp.text=="جوجل"||textapp.text=="جيميل") {
                      logo="pic/logo/google.png";
                    }else if(textapp.text=='Snapchat'||textapp.text=='snapchat'||textapp.text=='سناب شات'||textapp.text=="اسناب شات"||textapp.text=="اسناب") {
                      logo="pic/logo/snap.png";
                    }else if(textapp.text=='Twitter'||textapp.text=='twitter'||textapp.text=='x'||textapp.text=="X"||textapp.text=="تويتر"||textapp.text=="إكس"||textapp.text=="اكس") {
                      logo="pic/logo/Twiiter.png";
                    }else if(textapp.text=='Pinterest'||textapp.text=='pinterest'||textapp.text=='بينترست') {
                      logo="pic/logo/pinterest.png";
                    }else if(textapp.text=='Microsoft'||textapp.text=='microsoft'||textapp.text=="مايكروسوفت") {
                      logo="pic/logo/microsoft (1).png";
                    }else if(textapp.text=='Linked in'||textapp.text=='Linkedin'||textapp.text=='linked in'||textapp.text=='linkedin'||textapp.text=="لينكد ان"||textapp.text=="لينكدان") {
                      logo="pic/logo/linkedin.png";
                    }else{
                      logo="pic/logo/lock.png";
                    }
                  var t=(DateTime.now().year.toString())+'/'+(DateTime.now().month.toString())+'/'+(DateTime.now().day.toString());
                  var res=await sql.insert(textapp.text, textuser.text, textpass.text,textnote.text,texturl.text,logo);
                  print(res);
                  late BuildContext dialogContext = context;
                  if(res>0){
                    Timer? timer = Timer(Duration(milliseconds: 3000), (){
                      Navigator.pop(dialogContext);
                    });
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                      return passwords(ln:D.ln
                      );}));
                    D.bapp=true;
                    D.buser=true;
                    D.bpass=true;
                    return showDialog(
                        context: context,
                        builder: (BuildContext context) {dialogContext=context;
                        return
                          AlertDialog(insetPadding:EdgeInsets.all(120),
                              titlePadding: EdgeInsets.only(top:10,bottom:10),
                              shape: OutlineInputBorder(
                                  borderSide: BorderSide.none),
                              backgroundColor: Color(0xfff4af36),
                              title: Text(
                                (AppLocalizations.of(context)!.done), textAlign: TextAlign.center,
                                style: TextStyle(fontWeight: FontWeight.bold,
                                    fontSize:20,
                                    color: Colors.black),)
                          );
                        });
                  }
                },
                  child: Container(alignment: Alignment.center,width:70,
                      decoration: BoxDecoration(color: Color(0xfff4af36),borderRadius:D.ln? BorderRadius.only(bottomLeft: Radius.circular(30)):
                      BorderRadius.only(bottomRight: Radius.circular(30))),
                      child:Text((AppLocalizations.of(context)!.done),style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black,fontSize: 20),)),
                ):TextButton(onPressed: null, child: Text((AppLocalizations.of(context)!.done),style: TextStyle(color: Colors.grey,fontSize: 18)))


              ],
            ),
            body:
            Directionality(textDirection:!D.ln?TextDirection.rtl:TextDirection.ltr,
              child: Container(width: double.infinity,height: double.infinity,
                // color:  Color(0xff02182E),
                decoration: BoxDecoration(
                  gradient:LinearGradient(
                      begin: Alignment.bottomLeft,end: Alignment.topCenter,
                      colors: [Colors.black,Color(0xff02182E),]),
                ),
                child: SingleChildScrollView(
                  child:
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
                      children:[
                        Container( width: double.maxFinite,
                          decoration: BoxDecoration(color: Color(0xfff4af36),borderRadius: BorderRadius.circular(10)),margin: EdgeInsets.all(10),
                          child:
                          Column(mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Container( height:80,decoration: BoxDecoration(color: Colors.transparent),padding: EdgeInsets.only(top: 10),
                                  child:
                                  Row(
                                    children: [
                                      Padding(padding: EdgeInsets.only(left: 15)),
                                      SizedBox( width:340,
                                          child: TextField(
                                              onTapOutside: (v){FocusManager.instance.primaryFocus?.unfocus();},
                                              style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25),
                                              controller: textapp,
                                                  onChanged: (x){setState(() {
                                                    textapp.text=x;
                                                  });
                                              },
                                              decoration:InputDecoration( hintText: (AppLocalizations.of(context)!.add),
                                                border:InputBorder.none,
                                              )
                                          ))
                                    ],
                                  )),
                              Divider(thickness: 1),
                              Row(
                                children: [
                                  Container(margin: EdgeInsets.only(left: 8,right: 8),
                                    child: Text((AppLocalizations.of(context)!.user_Name),style: TextStyle(color:Colors.black,
                                        fontWeight:FontWeight.w800,fontSize: 18)),
                                  ),
                                  Expanded(
                                    child: TextField(onTapOutside: (v){FocusManager.instance.primaryFocus?.unfocus();},
                                        controller: textuser,style: TextStyle(fontSize: 18),onChanged: (x){setState(() {
                                          textuser.text=x;
                                        });
                                          if(x.startsWith(" ")&&x.endsWith(" ")){
                                            D.buser=true;
                                          }
                                          else if(x==" "){
                                            D.buser=true;
                                          }
                                          else{
                                            D.buser=false;
                                          }
                                        },
                                        decoration:InputDecoration( hintText:(AppLocalizations.of(context)!.add_username),
                                          contentPadding: EdgeInsets.only(left: 10,right: 5),border:InputBorder.none,

                                        )),
                                  ),
                                ],
                              ),
                              Divider(),
                              Row(
                                children: [
                                  Container(margin: EdgeInsets.only(left: 8,right:10),width:90,
                                    child: Text((AppLocalizations.of(context)!.password),style: TextStyle(color:Colors.black,fontWeight:FontWeight.bold,fontSize:18)),
                                  ),
                                  Expanded(
                                    child: TextField(controller: textpass,style: TextStyle(fontSize: 18),onTapOutside: (v){FocusManager.instance.primaryFocus?.unfocus();},
                                        onChanged: (x){
                                          if(x.startsWith(" ")&&x.endsWith(" ")){
                                            D.bpass=true;
                                          }
                                          else if(x==" "){
                                            D.bpass=true;
                                          }
                                          else{
                                            D.bpass=false;
                                          }
                                        },
                                        decoration:InputDecoration(hintText:(AppLocalizations.of(context)!.add_password),
                                          contentPadding: EdgeInsets.only(left: 10,right: 5),border:InputBorder.none,
                                        )),
                                  ),
                                ],
                              ),Divider(height:7,color: Colors.transparent,) ,
                            ],
                          ),

                        ),
                        Align(alignment:Alignment.topLeft,
                          child: Container(decoration: BoxDecoration(color:Color(0xfff4af36),borderRadius: BorderRadius.only(topRight: Radius.circular(25),topLeft: Radius.circular(25)))
                              ,padding:EdgeInsets.only(left: 16,right: 16,top: 8,bottom:4) ,
                              margin: EdgeInsets.only(left: 20,top:8),
                              child: Text((AppLocalizations.of(context)!.website),style: TextStyle(color:Colors.black,fontWeight: FontWeight.bold,fontSize: 20),)),
                        ),
                        Container(
                          decoration: BoxDecoration(color:Colors.white,borderRadius: BorderRadius.circular(10)),
                          margin: EdgeInsets.only(left: 10,bottom: 10,right: 10),
                          child:
                          TextFormField( onTapOutside: (v){FocusManager.instance.primaryFocus?.unfocus();},controller: texturl,
                              decoration:InputDecoration(floatingLabelBehavior: FloatingLabelBehavior.never,
                                  suffixIcon:IconButton(onPressed:(){
                                    print(textapp.text.isEmpty);
                                    print(textuser.text.isEmpty);
                                  }, icon:FaIcon(FontAwesomeIcons.chrome)),
                                  border: OutlineInputBorder(borderRadius:BorderRadius.circular(10)),
                                  label: Text("example.com",style: TextStyle(fontSize:19)),disabledBorder:InputBorder.none
                              )),
                        ),
                        Align(alignment:Alignment.topLeft,
                          child: Container(decoration: BoxDecoration(color:Color(0xfff4af36),borderRadius: BorderRadius.only(topRight: Radius.circular(25),topLeft: Radius.circular(25)))
                              ,padding:EdgeInsets.only(left: 16,right: 16,top: 8,bottom:4) ,
                              margin: EdgeInsets.only(left: 20,top:8),
                              child: Text((AppLocalizations.of(context)!.notes),style: TextStyle(color:Colors.black,fontWeight: FontWeight.bold,fontSize: 20),)),
                        ),
                        Container(
                          decoration: BoxDecoration(color:Colors.white,borderRadius: BorderRadius.circular(10)),height: 100,
                          margin: EdgeInsets.only(left: 10,bottom: 10,right: 10),
                          child:
                          TextFormField( onTapOutside: (v){FocusManager.instance.primaryFocus?.unfocus();},controller: textnote,
                              expands: true,maxLines: null,minLines: null,textAlign: TextAlign.right,
                              decoration:InputDecoration(floatingLabelBehavior: FloatingLabelBehavior.never,border: OutlineInputBorder(borderRadius:BorderRadius.circular(10)),
                                  label: Text((AppLocalizations.of(context)!.add_a_note),style: TextStyle(fontSize:19)),disabledBorder:InputBorder.none
                              )),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ); },)
    );
  }
}


