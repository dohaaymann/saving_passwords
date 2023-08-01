import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:saving_password/passwords.dart';

class add_data extends StatelessWidget {
  final user,pass,app; bool ln;
  add_data({required this.user,required this.pass,required this.app,required this.ln}){
    print(ln);
  }
  List l_acc=[];
  @override
  CollectionReference user0=FirebaseFirestore.instance.collection("acc");
  CollectionReference user1=FirebaseFirestore.instance.collection("acc").doc().collection("acc_data");
  var textapp=new TextEditingController();
  var textuser=new TextEditingController();
  var textpass=new TextEditingController();
  var textnote=new TextEditingController();
  Widget build(BuildContext context) {
    return Directionality(textDirection: ln?TextDirection.ltr:TextDirection.rtl,
      child: Scaffold(resizeToAvoidBottomInset: true,
        appBar: AppBar(backgroundColor: Colors.teal[900],
          title: Text((AppLocalizations.of(context)!.add)),
          actions: [
            TextButton(onPressed: ()async{
               var t=(DateTime.now().year.toString())+'/'+(DateTime.now().month.toString())+'/'+(DateTime.now().day.toString());
             try{var s= await user0.add({"account":"${textapp.text}","time":DateTime.now()});
             print("Id:${s.id}");
             await FirebaseFirestore.instance.collection("acc").doc(s.id).collection("acc_data").doc("D")
                 .set({"user":"${textuser.text}","pass":"${textpass.text}","time":t,"note":textnote.text});}catch(e){print(e);}
               Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
                   passwords(ln: ln)
               ));
            }, child:Text((AppLocalizations.of(context)!.done),style: TextStyle(color: Colors.white,fontSize: 18),))
          ],
        ),
        body:
        SingleChildScrollView(
          child:
          Column(
            mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
            children:[
              Container( width: double.maxFinite,
                decoration: BoxDecoration(color: Colors.teal[700],borderRadius: BorderRadius.circular(10)),margin: EdgeInsets.all(10),
                child:
                Column(mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container( height:80,decoration: BoxDecoration(color: Colors.transparent),padding: EdgeInsets.only(top: 10),
                        child:
                        Row(
                          children: [
                            Padding(padding: EdgeInsets.only(left: 15)),
                            SizedBox( width:340,
                                child: TextFormField(controller: textapp,
                                    decoration:InputDecoration( hintText: (AppLocalizations.of(context)!.add),
                                      enabledBorder:InputBorder.none,
                                    )
                                ))
                          ],
                        )),
                    Divider(thickness: 1),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 15,right: 10),
                          child: Text((AppLocalizations.of(context)!.user_Name),style: TextStyle(fontSize: 18)),
                        ),
                        SizedBox(width: 250,
                          child: TextField(controller: textuser,
                            // readOnly:true,
                              decoration:InputDecoration( hintText:(AppLocalizations.of(context)!.add_username),
                                contentPadding: EdgeInsets.only(left: 10,right: 5),enabledBorder:InputBorder.none,

                              )),
                        ),
                      ],
                    ),
                    Divider(),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 15,right: 17),
                          child: Text((AppLocalizations.of(context)!.password),style: TextStyle(fontSize: 18)),
                        ),
                        SizedBox(width: 250,
                          child: TextField(controller: textpass,
                            // readOnly:true,
                              decoration:InputDecoration(hintText:(AppLocalizations.of(context)!.add_password),
                                contentPadding: EdgeInsets.only(left: 10,right: 5),enabledBorder:InputBorder.none,
                              )),
                        ),
                      ],
                    ),Divider(height:7,color: Colors.transparent,)
                  ],
                ),

              ),
              Container(margin: EdgeInsets.only(left: 20,top: 30,bottom:5),
                  child: Text((AppLocalizations.of(context)!.notes),style: TextStyle(fontWeight: FontWeight.bold),)),
              Container(
                  decoration: BoxDecoration(color: Colors.white38,borderRadius: BorderRadius.circular(10)),height: 100,
                  padding: EdgeInsets.only(left: 10,bottom: 10,right: 10),
                  child:
                  TextFormField(controller: textnote,textAlign: TextAlign.right,
                      expands: true,maxLines: null,minLines: null,
                      decoration:InputDecoration(border: OutlineInputBorder(borderRadius:BorderRadius.circular(10)),
                          //  contentPadding: EdgeInsets.only(left: 10,right: 5),
                          label: Text((AppLocalizations.of(context)!.add_a_note),style: TextStyle()),disabledBorder:InputBorder.none
                      ))
              ),
            ],
          ),
        ),
      ),
    );
  }
}
