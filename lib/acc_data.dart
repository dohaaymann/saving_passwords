import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
//import 'package:image_picker/image_picker.dart';
import 'package:saving_password/passwords.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
List image_list=[];
bool b=true,a=false,w=true;
var username,password,note,image_get,n=1;
String? Url,URL;
String? t;
var textapp=new TextEditingController();
var textuser=new TextEditingController();
var textpass=new TextEditingController();
var textnote=new TextEditingController();
var textimage=new TextEditingController();

var textm=new TextEditingController();
class acc_data extends StatelessWidget {

  var image,image2,image3;
   _pickFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);
    if (result == null) return;
    var image =result.files.first;
    var image2 =result.files.first.path;
    print(image2);
    try{
      var Store=FirebaseStorage.instance.ref();
      var r_name=Random().nextInt(100000);
      final pathh="files/$r_name${image!.name}";
      final file=File(image!.path!);
       final upload_photo= await Store.child(pathh).putFile(file);
       final d=await Store.child(pathh).getDownloadURL();
       print(d);
    }
    catch(e){print("ERROR: $e");}

  }
  get_image()async{
     var ref=await FirebaseStorage.instance.ref().child("files").listAll();
      ref.items.forEach((element) {
        print("_______________________");
        print(element);
      });
  }

  void messagestream() async{
    await for(var snapshot in FirebaseFirestore.instance.collection("acc").doc(Id).collection("acc_data").snapshots()){
      for(var mess in snapshot.docs){
        print("username:${mess.get("user")}");
       print("passwaord:${mess.get("pass")}");
       print("Url:${mess.get("image")}");
        URL=mess.get("image");
       print("time:${mess.get("time")}");
       print("note:${mess.get("note")}");

      }
    }
  }
  void getdata() async{
    var c= await FirebaseFirestore.instance.collection("acc").doc(Id).collection("acc_data").get();
    c.docs.forEach((element) {
      for(var mess in c.docs){
       textuser.text=(mess.get("user"));
       textpass.text=(mess.get("pass"));
       textm.text=mess.get("time");
       textnote.text=mess.get("note");
       URL=mess.get("image");
       textimage.text=mess.get("image");
       Url=URL;
      }
    });
  }

  final app,Id;bool ln;
  acc_data({required this.app,required this.Id,required this.ln}){
    getdata();
   messagestream();
    Url=URL;
    //(context as Element).markNeedsBuild();
    print("Textimage:${textimage.text}");
    print("Urlllll:$Url");
    print("URlllll:$URL");
  }
  List l_acc=[];
  @override
  CollectionReference user0=FirebaseFirestore.instance.collection("acc");
  CollectionReference user1=FirebaseFirestore.instance.collection("acc").doc().collection("acc_data");
  var Store=FirebaseStorage.instance.ref();
  Widget build(BuildContext context) {
    return
      Directionality(
        textDirection:ln?TextDirection.ltr:TextDirection.rtl,
        child: Scaffold(resizeToAvoidBottomInset: true,
         appBar: AppBar(backgroundColor: Colors.teal[900],
           leading: IconButton(onPressed: (){
             Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
                 passwords(ln: ln)
             ));
         }, icon: Icon(Icons.arrow_back)),
           title: Text(app),automaticallyImplyLeading: false,
           actions: [
             TextButton(onPressed: ()async{
               if(textuser.text==username){
                 print("errorrrrrrrrrrrrrrrrrrrrrrr");
               }else{
               try{
                 t=(DateTime.now().year.toString())+'/'+(DateTime.now().month.toString())+'/'+(DateTime.now().day.toString());
               await FirebaseFirestore.instance.collection("acc").doc(Id).collection("acc_data").doc("D").
              update({"user":textuser.text,"pass":textpass.text,"time":t,"note":textnote.text,"image":Url});

               }
           catch(e){print("Error: $e");}
               Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
                   passwords(ln:ln
                   ),));
             }},
                 child: Text((AppLocalizations.of(context)!.save),style: TextStyle(color: Colors.white,fontSize: 18),))
           ],
         ),
         body:
         SingleChildScrollView(
           child: Column(
             mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
             children:[
               // Url != null ? image_storage(Id: Id,)
               //                 : Text(
               //               "No Image",
               //               style: TextStyle(fontSize: 20),
               //             ),
               view(app: app,pass:password,user: username,time: t),
               Column(
                 children: [
               Container(
                   margin: EdgeInsets.only(left: 20,top: 30,bottom:5),
                   child: Text((AppLocalizations.of(context)!.notes),style: TextStyle(fontWeight: FontWeight.bold),)),
               Container(
                   decoration: BoxDecoration(color: Colors.white38,borderRadius: BorderRadius.circular(10)),height: 100,
                   padding: EdgeInsets.only(left: 10,bottom: 10,right: 10),
                   child:
                   TextFormField(controller: textnote,onChanged: ((value) {
                     value=textnote.text;
                   }),
                       expands: true,maxLines: null,minLines: null,textAlign: TextAlign.right,
                       decoration:InputDecoration(border: OutlineInputBorder(borderRadius:BorderRadius.circular(10)),
                           label: Text((AppLocalizations.of(context)!.add_a_note),style: TextStyle()),disabledBorder:InputBorder.none
                   )),
               ),Container(alignment: Alignment.centerRight,margin: EdgeInsets.only(right: 10),
                 child: ElevatedButton(
                               onPressed: ()async {
                                 try{  final result = await FilePicker.platform.pickFiles(allowMultiple: false);
                                 if (result == null) return;
                                 var image =result.files.first;
                                 final file=File(image!.path!);
                                 print("fileeeeeeee:$file");
                                   var Store=await FirebaseStorage.instance.ref();
                                   var r_name=Random().nextInt(100000);
                                   final pathh="files/$r_name${image!.name}";
                                   final upload= await Store.child(pathh).putFile(file);
                                    Url=await Store.child(pathh).getDownloadURL();
                                    (context as Element).markNeedsBuild();
                                 await FirebaseFirestore.instance.collection("acc").doc(Id).collection("acc_data").doc("D").
                                 update({"user":textuser.text,"pass":textpass.text,"time":t,"note":textnote.text,"image":Url});
                                   print("URLLLLLLLLLLLLLLLLLLLLLL:$Url");
                                 }
                                 catch(e){print("ERROR: $e");}
                               },
                               child: Text('Upload Photo'),
                             ),
               ),
                   // Padding(
                   //           padding: c
                   //           onst EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                   //           child: ClipRRect(
                   //             borderRadius: BorderRadius.circular(8),
                   //             child: Image.network("https://firebasestorage.googleapis.com/v0/b/saving-password.appspot.com/o/files%2F16074IMG_20230723_225707.jpg?alt=media&token=0bedd517-81a5-4ac1-bb7a-f68e3140fdc0",
                   //                     fit: BoxFit.cover,
                   //                     width: MediaQuery.of(context).size.width,
                   //                     height: 300,
                   //             )
                   //           ),
                   //         )
                 ],),ElevatedButton(onPressed: (){print("Url:$Url");
                  // image_list.clear();

              // print(image_list[0]);
                   print(image_list);
               print("Textimage:${textimage.text}");
               }, child: Text("print")),
                 Url!="" ?
                image_storage(Id: Id,Url: Url,)
                :Text("Emptyyy"),
             ] ),
         ),
    ),
      );
  }
}


class view extends StatelessWidget {
  @override
  var user, pass, app,time;

  view({required this.user, required this.pass, required this.app,required this.time});

  Widget build(BuildContext context) {
    return Container(width: double.maxFinite,
      decoration: BoxDecoration(
          color: Colors.teal[700], borderRadius: BorderRadius.circular(10)),
      margin: EdgeInsets.only(right: 10,left: 10,top: 10),
      child:
      Column(mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(height: 80,
              decoration: BoxDecoration(color: Colors.transparent),
              padding: EdgeInsets.only(top: 10),
              child:
              Row(
                children: [
                  Padding(padding: EdgeInsets.only(left: 10))
                  ,Container(margin: EdgeInsets.all(0),width: 70,height: 70
                      ,alignment:Alignment.center,decoration: BoxDecoration(color: Colors.blueGrey[200],
                          borderRadius: BorderRadius.circular(20)),
                      child:  Icon(Icons.lock_open_outlined,size: 30,color: Colors.teal[900],)
                  ),
                  Padding(padding: EdgeInsets.only(left: 10)),
                  Column(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(app, style: TextStyle(fontSize: 25,color: Colors.white)),
                      Padding(padding: EdgeInsets.all(2)),
                      Row(
                        children: [
                          Text((AppLocalizations.of(context)!.last_modified), style: TextStyle(fontSize: 12,color: Colors.white)),
                         Padding(padding: EdgeInsets.only(left: 7)),
                          SizedBox(height: 20,
                              width:100,child: TextFormField(style: TextStyle(fontSize: 12),
                                controller: textm,
                                readOnly: true,onChanged: (value) {
                                value = textm.text;
                              },
                                  decoration: InputDecoration(
                                   // contentPadding: EdgeInsets.only(left: 5, right: 0),
                                    enabledBorder: InputBorder.none,
                                  )
                              ))
                        ],
                      ),
                    ],),
                ],
              )),
          Divider(),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 10),
                child: Text((AppLocalizations.of(context)!.user_Name), style: TextStyle(fontSize: 18,color: Colors.white)),
              ),
              SizedBox(width: 250,
                child: TextField(controller: textuser,
                    onChanged: (value) {
                  value = username;
                },
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(left: 10, right: 5),
                      enabledBorder: InputBorder.none,
                    )),
              ),
            ],
          ),
          Divider(),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 17),
                child: Text((AppLocalizations.of(context)!.password), style: TextStyle(fontSize: 18,color: Colors.white)),
              ),
              SizedBox(width: 250,
                child: TextField(controller: textpass,
                    onChanged: (value) {
                      value = password;
                    },
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(left: 10, right: 5),
                      enabledBorder: InputBorder.none,
                    )),
              ),
            ],
          ), Divider(height: 7,)
        ],
      ),
    );
  }
}




class image_storage extends StatelessWidget {
  var Id,Url;
  image_storage({required this.Id,required this.Url,});
  @override
  Widget build(BuildContext context) {
    CollectionReference user1= FirebaseFirestore.instance.collection("acc").doc(Id).collection("acc_data");
  return StreamBuilder(
      stream:user1.snapshots(),
      builder:  (context, snapshot) {
        // for(var mess in snapshot.data!.docs){
        //   final messageget=mess.get("image");
        //   //final messagew=Text("$messageget");
        //   image_list.add(messageget);
        // }
        // return SizedBox(height:600,
        //   child:
        //   InkWell(onLongPress:()async{
        //     //await user.doc(snapshot.data!.docs[i].id).collection("mess").doc().delete();
        //   } ,
        //     child:
        //     ListView(reverse:false,
        //         children:
        //         [Container(margin: EdgeInsets.all(10),
        //           decoration:
        //           BoxDecoration(borderRadius:BorderRadiusDirectional.circular(15),color: Colors.teal[700]),
        //           child: Padding(
        //             padding: const EdgeInsets.symmetric(horizontal: 0,vertical: 0),
        //             child: ClipRRect(
        //                 borderRadius: BorderRadius.circular(8),
        //                 child:
        //                 //Text("nenen")
        //                 Image.network(textimage.text)
        //             ),
        //           ),
        //         ),
        //     ]
        //     ),
        //   ),
        // );
        return ListView.builder(
          itemCount:snapshot?.data?.docs?.length ,shrinkWrap: true,physics: ClampingScrollPhysics(),
          itemBuilder: (context, i) {
            DocumentSnapshot data=snapshot!.data!.docs[i];
            return Container(  margin: EdgeInsets.all(10),
              decoration:
              BoxDecoration(borderRadius:BorderRadiusDirectional.circular(15),color: Colors.teal[700]),
              child: InkWell(
                onLongPress:()async{
                 // return showDialog(context: context, builder:(context) {
                 //    return SizedBox(height: 50,width: 200,
                 //      child: AlertDialog(
                 //          shape:UnderlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                 //          title: Text((AppLocalizations.of(context)!.deletee),textAlign: TextAlign.center,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                 //          actions:[
                 //            Column(
                 //              children:[ Text(data['image']),
                 //                Row( mainAxisAlignment: MainAxisAlignment.spaceAround,
                 //                  children: [
                 //                    Container( margin:EdgeInsetsDirectional.only(top: 10,end: 5),child: ElevatedButton(
                 //                        onPressed: (){
                 //                          Navigator.pop(context);
                 //                        },
                 //                        child:Text((AppLocalizations.of(context)!.cancel),textAlign: TextAlign.center,style: TextStyle(fontSize: 20),))),
                 //
                 //                    Container( margin:EdgeInsetsDirectional.only(top: 10,end: 5),child: ElevatedButton(
                 //                        onPressed: () async{
                 //                          //
                 //                          // try{
                 //                          //   await FirebaseStorage.instance.ref().child("files").delete().then((value) async{
                 //                          //     await FirebaseFirestore.instance.collection("acc").doc(Id).collection("acc_data").doc("D").
                 //                          //     update({"user":textuser.text,"pass":textpass.text,"time":t,"note":textnote.text,"image":""});
                 //                          //    Url="";
                 //                          //    (context as Element).markNeedsBuild();
                 //                          //
                 //                          //   });
                 //                          //
                 //                          // }catch(e){
                 //                          //   print("error: $e");
                 //                          // }
                 //                          Navigator.pop(context);
                 //                        },
                 //                        child:Text((AppLocalizations.of(context)!.delete),textAlign: TextAlign.center,style: TextStyle(fontSize: 20),))),
                 //                  ],)],
                 //            ),
                 //          ]
                 //      ),
                 //    );});
                  },
                  child:  Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0,vertical: 0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child:Text(data.id)
                   // Image.network(data['image'])
                  ),
                ),

              ),
            );
          },
        );
      },
    );
  }
}