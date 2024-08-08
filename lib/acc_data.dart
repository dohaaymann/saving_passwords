import 'dart:async';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:saving_password/main.dart';
import 'package:saving_password/passwords.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:saving_password/sql.dart';
import 'package:url_launcher/url_launcher.dart';

import 'dataa.dart';
bool b=true,a=false,w=true;
var username,password,note,image_get,n=1,url;
String? Url,URL;
String? t;
var textapp=new TextEditingController();
var textuser=new TextEditingController();
var textpass=new TextEditingController();
var textnote=new TextEditingController();
var textimage=new TextEditingController();
var textm=new TextEditingController();
var texturl=new TextEditingController();
class acc_data extends StatefulWidget {
  var id,title;
  acc_data({required this.id, required this.title});
  @override
  State<acc_data> createState() => _acc_dataState(id: id,title: title);
}

class _acc_dataState extends State<acc_data> {
  @override
  SQLDB sql=SQLDB();
  var id,title;
  _acc_dataState({required this.id,required this.title,});
   var l_data=[];
  var isPressed=false;var _image=null;
  List<String> l_images=[];
  List l_test=[];
  var last_m="- \ - \ -";
  readbyid()async{
    var res=await sql.readbyid(id);
    l_data.addAll(res);
    if(l_data[0]['image']==""){
      print("//////////////////");
    }
    if(this.mounted){
    if(this.mounted){
      setState(() {
        textapp.text=l_data[0]['acc'];
        if(l_data[0]['Url']!=null){texturl.text=l_data[0]['Url'];}
        if(l_data[0]['user']!=null){textuser.text=l_data[0]['user'];}
        if(l_data[0]['pass']!=null){textpass.text=l_data[0]['pass'];}
        if(l_data[0]['note']!=null){textnote.text=l_data[0]['note'];}
        if(l_data[0]['time']!=null){last_m=l_data[0]['time'].toString();}
        if(l_data[0]['image']!=null||l_data[0]['image']!=""){textimage.text=l_data[0]['image'];}

      });
      print("__________ read by id done ---------------");
    }
    print(res);
  }}
  select_img()async{
    var x;var res=await sql.selectimg(id);
    var y=res.toList().first;
    for (final e in y.entries) {
      setState(() {
        x=e.value;
        if(l_data[0]['image']==""){
         l_test.clear();
        }else{
       var output=x.split(',');
       print(output);
          l_test.addAll(output);print("########$l_test");print(l_test.isEmpty);
          print(l_test.length);
          for(int i=0;i<l_test.length;i++)
            {
              if(l_test[i][0]==" "){
                l_test[i]=l_test[i].substring(1);
              }
            }
        }
      });
    }
     print(res);
  }
  @override
  clearfields(){
    textuser.clear();
    textpass.clear();
    texturl.clear();
    textnote.clear();
  }
  var edit=true;
  var S_E=true;
  var hide=true;
  void initState() {
    // TODO: implement initState
    edit=true;
    S_E=true;
    hide=true;
   print(ln);
    readbyid();
    print(texturl.text);

    select_img();
    super.initState();
  }
  @override
  Future<bool>_requestPermission(Permission permission) async
  {
    AndroidDeviceInfo build=await DeviceInfoPlugin().androidInfo;
    if(build.version.sdkInt!>=30){
      var re=await Permission.manageExternalStorage.request();
      if(re.isGranted)
      {
        return true;
      }
      else{
        return false;
      }
    }
    else{
      if(await permission.isGranted)
      {
        return true;
      }
      else{
        var result=await permission.request();
        if(result.isGranted)
        {
          return true;
        }
        else{
          return false;
        }
      }
    }
  }
  Widget build(BuildContext context) {
    var D=Provider.of<dataa>(context);
    return Consumer<dataa>(builder: (context, D, child) {
      return Scaffold(resizeToAvoidBottomInset: true,
          appBar: AppBar(backgroundColor:Color(0xff02172C),elevation: 0,
            leading: IconButton(onPressed: (){
              Navigator.of(context).pop();
              clearfields();
            }, icon: Icon(Icons.arrow_back,color: Colors.white,)),
            title: Text(title,style: TextStyle(color:Colors.white,fontSize: 27)),automaticallyImplyLeading: false,
            actions: [
              S_E?
              InkWell(onTap: ()async{
                setState(() {
                  edit=!edit;
                  S_E=!S_E;
                });
              },
                child: Container(alignment: Alignment.center,width:70,
                    decoration: BoxDecoration(color: Color(0xfff4af36),borderRadius: !D.ln?BorderRadius.only(bottomRight: Radius.circular(30)):
                    BorderRadius.only(bottomLeft: Radius.circular(30))),
                    child:Text((AppLocalizations.of(context)!.edit),style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black,fontSize: 20),)),
              ):
              InkWell(onTap: ()async{
                setState(() {
                  edit=!edit;
                  S_E=!S_E;
                });
                t=(DateTime.now().year.toString())+'/'+(DateTime.now().month.toString())+'/'+(DateTime.now().day.toString());
                var res=await sql.update({
                  "user":"${textuser.text}",
                  "pass":"${textpass.text}",
                  "image":"${l_test.toString().replaceAll('[', '').replaceAll(']', '').replaceAll(' ', '')}",
                  "note":"${textnote.text}",
                  "time":"${t}",
                  "Url":"${texturl.text}"
                },"id=$id");
                late BuildContext dialogContext = context;
                if(res>0){
                  Timer? timer = Timer(Duration(milliseconds: 3000), (){
                    Navigator.pop(dialogContext);
                  });
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
                      passwords(ln:D.ln
                      ),));
                  return showDialog(
                      context: context,
                      builder: (BuildContext context) {dialogContext=context;
                      return
                        AlertDialog(insetPadding:EdgeInsets.all(120),
                            titlePadding: EdgeInsets.only(top:10,bottom:10),
                            shape: OutlineInputBorder(
                                borderSide: BorderSide.none),
                            backgroundColor: Color(0xfff4af36),
                          title: Text((AppLocalizations.of(context)!.saved), textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.bold,
                                  fontSize:20,
                                  color: Colors.black),)
                        );
                      });
                }
              },
                child: Container(alignment: Alignment.center,width:70,
                    decoration: BoxDecoration(color: Colors.grey[500],borderRadius: !D.ln?BorderRadius.only(bottomRight: Radius.circular(30)):
                    BorderRadius.only(bottomLeft: Radius.circular(30))),
                  child:Text((AppLocalizations.of(context)!.save),style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black,fontSize: 20),)),
              )
            ],
          ),
          body:Consumer<dataa>(builder: (context, D, child) =>
             Directionality(textDirection:!D.ln?TextDirection.rtl:TextDirection.ltr,
                child: Container(width: double.infinity,height: double.infinity,
                  decoration: BoxDecoration(
                    gradient:LinearGradient(
                        begin: Alignment.bottomCenter,end: Alignment.topCenter,
                        colors: [Colors.black,Color(0xff02182E),]),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
                        children:[
                          //-----------------------
                          Container(width: double.maxFinite,
                            decoration: BoxDecoration(
                                color:edit?Color(0xfff4af36):Colors.grey[500], borderRadius: BorderRadius.circular(10)),
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
                                            ,alignment:Alignment.center,decoration: BoxDecoration(color:Color(0xff001934),
                                                borderRadius: BorderRadius.circular(20)),
                                            child:  Icon(Icons.lock_open_outlined,size: 30,color: Color(0xfff4af36),)
                                        ),
                                        Padding(padding: EdgeInsets.only(left: 10)),
                                        Column(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(title, style: TextStyle(fontSize: 25,color: Colors.black,fontWeight:FontWeight.bold)),
                                            Padding(padding: EdgeInsets.all(2)),
                                            Row(
                                              children: [
                                                Text((AppLocalizations.of(context)!.last_modified), style: TextStyle(fontSize: 12,color: Colors.black)),
                                                Padding(padding: EdgeInsets.only(left: 7)),
                                               Text(last_m)
                                              ],
                                            ),
                                          ],),
                                      ],
                                    )),
                                Divider(height: 7,color: Colors.black54,),
                                Row(
                                  children: [
                                    Container(margin: EdgeInsets.only(left: 8,right: 8),
                                      child: Text((AppLocalizations.of(context)!.user_Name),style: TextStyle(color:Colors.black,
                                          fontWeight:FontWeight.w800,fontSize: 18)),
                                    ),
                                    Expanded(
                                      child: TextField(
                                          onTapOutside: (v){FocusManager.instance.primaryFocus?.unfocus();},
                                          controller: textuser,style: TextStyle(fontSize: 18), readOnly: edit,
                                          decoration: InputDecoration(hintText:(AppLocalizations.of(context)!.add_username),
                                            contentPadding: EdgeInsets.only(left: 10, right: 5),
                                            border:edit?InputBorder.none:UnderlineInputBorder(),
                                          )),
                                    ),
                                  ],
                                ),
                                Divider(color: Colors.black54,),
                                Row(
                                  children: [
                                    Container(margin: EdgeInsets.only(left: 8,right:10),width:90,
                                      child: Text((AppLocalizations.of(context)!.password),style: TextStyle(color:Colors.black,fontWeight:FontWeight.bold,fontSize:18)),
                                    ),
                                    Expanded(
                                      child: TextField( onTapOutside: (v){FocusManager.instance.primaryFocus?.unfocus();},controller: textpass,style: TextStyle(fontSize: 18), readOnly: edit,
                                          onChanged: (value) {
                                            value = password;
                                          },obscureText: hide,
                                          decoration: InputDecoration(hintText:(AppLocalizations.of(context)!.add_password),
                                            contentPadding: EdgeInsets.only(left: 10, right: 5),border:edit?InputBorder.none:UnderlineInputBorder()
                                          )),
                                    ),hide?IconButton(onPressed: (){setState(() {
                                      hide=!hide;
                                    });}, icon:FaIcon(FontAwesomeIcons.eyeSlash,size:20,)):
                                    IconButton(onPressed: (){setState(() {
                                      hide=!hide;
                                    });}, icon:FaIcon(FontAwesomeIcons.eye,size: 20,))
                                  ]
                                ), Divider(height: 7,color: Colors.black54,),

                              ],
                            ),
                          ),
                          //-----------------------
                          Align(alignment:Alignment.topLeft,
                            child: Container(decoration: BoxDecoration(color:edit?Color(0xfff4af36):Colors.grey[500],borderRadius: BorderRadius.only(topRight: Radius.circular(25),topLeft: Radius.circular(25)))
                                ,padding:EdgeInsets.only(left: 16,right: 16,top: 8,bottom:4) ,
                                margin: EdgeInsets.only(left: 20,top:15,right: 20),
                                child: Text((AppLocalizations.of(context)!.website),style: TextStyle(color:Colors.black,fontWeight: FontWeight.bold,fontSize: 20),)),
                          ),Container(
                            decoration: BoxDecoration(color:Colors.white,borderRadius: BorderRadius.circular(10)),
                            margin: EdgeInsets.only(left: 10,bottom: 10,right: 10),
                            child:
                            TextFormField( style:TextStyle(fontSize:19,color:texturl.text.isEmpty?null:Colors.blue),onTapOutside: (v){FocusManager.instance.primaryFocus?.unfocus();},
                                controller: texturl,readOnly: edit,
                                decoration:InputDecoration(floatingLabelBehavior: FloatingLabelBehavior.never,hintStyle: TextStyle(fontSize: 19),
                                    suffixIcon:IconButton(onPressed:
                                          ()async{
                                        var url = "${texturl.text}";
                                        if (await canLaunchUrl(Uri.parse(url))) {
                                          await launchUrl(Uri.parse(url));
                                        } else {
                                          throw 'Could not launch $url';
                                        }
                                    }, icon:FaIcon(FontAwesomeIcons.chrome,color: texturl.text.length>0?Colors.blue:null,)),
                                    border: OutlineInputBorder(borderRadius:BorderRadius.circular(10)),
                                    hintText:"example.com",disabledBorder:edit?InputBorder.none:UnderlineInputBorder()
                                )),
                          ),
                          Column(
                            children: [
                              Align(alignment:Alignment.topLeft,
                                child: Container(decoration: BoxDecoration(color:edit?Color(0xfff4af36):Colors.grey[500],borderRadius: BorderRadius.only(topRight: Radius.circular(25),topLeft: Radius.circular(25)))
                                    ,padding:EdgeInsets.only(left: 16,right: 16,top: 8,bottom:4) ,
                                    margin: EdgeInsets.only(left: 20,top:7,right: 20),
                                    child: Text((AppLocalizations.of(context)!.notes),style: TextStyle(color:Colors.black,fontWeight: FontWeight.bold,fontSize: 20),)),
                              ),
                              Container(
                                decoration: BoxDecoration(color:Colors.white,borderRadius: BorderRadius.circular(10)),height: 100,
                                margin: EdgeInsets.only(left: 10,bottom: 10,right: 10),
                                child:
                                TextFormField(controller: textnote,onTapOutside: (v){FocusManager.instance.primaryFocus?.unfocus();},
                                    expands: true,maxLines: null,minLines: null,style: TextStyle(fontSize:16),readOnly: edit,
                                    decoration:InputDecoration(floatingLabelBehavior:FloatingLabelBehavior.never,border: OutlineInputBorder(borderRadius:BorderRadius.circular(10)),
                                        hintText:(AppLocalizations.of(context)!.add_a_note),disabledBorder:InputBorder.none
                                    )),
                              ),Row(
                                children: [Expanded(child: SizedBox()),
                                  Expanded(
                                    child: InkWell(splashColor: Colors.grey,
                                      overlayColor: WidgetStateProperty.resolveWith<Color?>(
                                            (Set<WidgetState> states) {
                                          if (states.contains(WidgetState.pressed))
                                            return Colors.redAccent; //<-- SEE HERE
                                          return null; // Defer to the widget's default.
                                        },
                                      ),
                                      highlightColor: Colors.transparent,
                                      onHighlightChanged: (param){
                                        setState((){
                                          isPressed = param;
                                        });
                                      },
                                      onTap:()async{
                                        showDialog(context: context, builder:(context) {
                                          return SizedBox(height: 40,width: 200,
                                            child: AlertDialog( backgroundColor: Color(0xff02182E),contentPadding: EdgeInsets.all(0),
                                                shape:UnderlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                                                title: Text((AppLocalizations.of(context)!.choose),
                                                  textAlign: TextAlign.center,style:
                                                TextStyle(color:Colors.white,fontSize: 22,fontWeight: FontWeight.bold),),
                                                actions:[
                                                  Column(
                                                    children:[
                                                      Column(
                                                        children: [
                                                          Row( mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                            children: [
                                                              Expanded(
                                                                child: InkWell(
                                                                    onTap:()async{
                                                                      // Timer? timer = Timer(Duration(milliseconds: 3000), (){
                                                                      //   CircularProgressIndicator();
                                                                      //   Navigator.pop(dialogContext);
                                                                      //
                                                                      // });
                                                                      var status = await Permission.storage.status;
                                                                      debugPrint("storage permission " + status.toString());
                                                                      if (await Permission.storage.isDenied) {

                                                                        debugPrint("sorage permission ===" + status.toString());

                                                                        await Permission.storage.request();
                                                                      } else {
                                                                        debugPrint("permission storage " + status.toString());
                                                                        // do something with storage like file picker
                                                                      }
                                                                      // //------------------
                                                                      try{
                                                                        await _requestPermission(Permission.storage).catchError((e){print("---------$e");
                                                                        return "===$e";});
                                                                        if(await _requestPermission(Permission.storage)==true){
                                                                          print("Permission is granted");
                                                                          File? image;
                                                                          try {
                                                                            final image = await ImagePicker().pickImage(source: ImageSource.camera);
                                                                            if(image == null) return;
                                                                            if(this.mounted){
                                                                              setState(() { });
                                                                            }
                                                                            String str="";
                                                                            var imageTemp = File(image.path);
                                                                            setState(() {
                                                                              str="File: '${image.path}'";
                                                                              l_test.add(image.path);
                                                                            });
                                                                            setState(() => _image =imageTemp);
                                                                            Navigator.of(context).pop();
                                                                          } on PlatformException catch(e) {
                                                                          }
                                                                          setState(() {
                                                                            edit=!edit;
                                                                            S_E=!S_E;
                                                                          });
                                                                        }
                                                                        else{

                                                                        }}catch(e){print("================$e");}
                                                                      Navigator.of(context).pop();
                                                                    },
                                                                    child: Container(alignment: Alignment.center,
                                                                      margin:EdgeInsetsDirectional.only(bottom: 8),child:
                                                                      Column(
                                                                        children: [
                                                                          FaIcon(FontAwesomeIcons.camera,size:80,color: Colors.white,),
                                                                          Text((AppLocalizations.of(context)!.camera),style: TextStyle(color: Colors.white,fontSize: 25),textAlign: TextAlign.center,)
                                                                        ],
                                                                      ), )
                                                                ),
                                                              ),Expanded(
                                                                child: InkWell(
                                                                    onTap:()async{
                                                                      var status = await Permission.storage.status;
                                                                      debugPrint("storage permission " + status.toString());
                                                                      if (await Permission.storage.isDenied) {

                                                                        debugPrint("sorage permission ===" + status.toString());

                                                                        await Permission.storage.request();
                                                                      } else {
                                                                        debugPrint("permission storage " + status.toString());
                                                                        // do something with storage like file picker
                                                                      }
                                                                      // //------------------
                                                                      try{
                                                                        await _requestPermission(Permission.storage).catchError((e){
                                                                          Fluttertoast.showToast(
                                                                              msg: "$e",
                                                                              toastLength: Toast.LENGTH_SHORT,
                                                                              gravity: ToastGravity.CENTER,
                                                                              timeInSecForIosWeb: 1,
                                                                              backgroundColor:Color(0xfff4af36),
                                                                              textColor: Colors.white,
                                                                              fontSize: 16.0
                                                                          );
                                                                        return "===$e";});
                                                                        if(await _requestPermission(Permission.storage)==true){
                                                                          File? image;
                                                                          try {
                                                                            final image = await ImagePicker().pickImage(source: ImageSource.gallery);
                                                                            if(image == null) return;
                                                                            if(this.mounted){
                                                                              setState(() { });
                                                                            }
                                                                            String str="";
                                                                            var imageTemp = File(image.path);
                                                                            setState(() {
                                                                              str="File: '${image.path}'";
                                                                              l_test.add(image.path);
                                                                            });
                                                                            setState(() {
                                                                              // edit=!edit;
                                                                              S_E=!S_E;
                                                                            });
                                                                            Navigator.of(context).pop();
                                                                            setState(() => _image =imageTemp);
                                                                          } on PlatformException catch(e) {
                                                                            Fluttertoast.showToast(
                                                                                msg: "Failed to pick image: $e",
                                                                                toastLength: Toast.LENGTH_SHORT,
                                                                                gravity: ToastGravity.CENTER,
                                                                                timeInSecForIosWeb: 1,
                                                                                backgroundColor:Color(0xfff4af36),
                                                                                textColor: Colors.white,
                                                                                fontSize: 16.0
                                                                            );
                                                                          }

                                                                        }
                                                                        else{
                                                                          Fluttertoast.showToast(
                                                                              msg: "permission is not granted",
                                                                              toastLength: Toast.LENGTH_SHORT,
                                                                              gravity: ToastGravity.CENTER,
                                                                              timeInSecForIosWeb: 1,
                                                                              backgroundColor:Color(0xfff4af36),
                                                                              textColor: Colors.white,
                                                                              fontSize: 16.0
                                                                          );
                                                                        }}catch(e){print("================$e");}
                                                                      Navigator.of(context).pop();
                                                                    },
                                                                    child: Container(alignment: Alignment.center,margin:EdgeInsetsDirectional.only(bottom: 8),child:
                                                                    Column(
                                                                      children: [
                                                                        FaIcon(FontAwesomeIcons.images,size:80,color: Colors.white,),
                                                                        Text((AppLocalizations.of(context)!.gallery),style: TextStyle(color: Colors.white,fontSize: 25),textAlign: TextAlign.center,),
                                                                      ],
                                                                    ), )
                                                                ),
                                                              ),

                                                            ],),
                                                        ],
                                                      )],
                                                  ),
                                                ]
                                            ),
                                          );});
                                    },focusColor: Colors.red,
                                      child: Row(
                                        children: [
                                          Expanded(child: SizedBox()),
                                          Container(margin: EdgeInsets.only(right: 0),
                                          height: 50,padding: EdgeInsets.all(10),alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            border: Border.all(color: Colors.black ,width:1),
                                                color:isPressed?Colors.grey:edit?Color(0xfff4af36):Colors.grey[500],
                                            borderRadius: D.ln?BorderRadius.only(bottomLeft: Radius.circular(20),topLeft:Radius.circular(20)):
                                            BorderRadius.only(bottomRight: Radius.circular(20),topRight:Radius.circular(20) )),
                                          child: Row(
                                            children: [
                                              Text((AppLocalizations.of(context)!.upload),style: TextStyle(fontSize:16,fontWeight: FontWeight.bold),),
                                           FaIcon(FontAwesomeIcons.solidImages,size: 20,)
                                            ],
                                          ),),
                                        ],
                                      ),),
                                  ),
                                ],
                              ),
                            ],)
                          ,l_test.isNotEmpty?
                  ListView.builder(shrinkWrap: true,physics: ClampingScrollPhysics(),
                    itemCount: l_test.length,itemBuilder: (context, i) {
                    var f=File(l_test[i]);
                     return InkWell(onLongPress:()async{
                       return  showDialog(context: context, builder:(context) {
                           return SizedBox(height: 40,width: 200,
                           child: AlertDialog(insetPadding: EdgeInsets.all(4),contentPadding: EdgeInsets.all(13),shape: OutlineInputBorder(borderSide: BorderSide.none),
                               backgroundColor: Color(0xff02182E),
                      title: Text((AppLocalizations.of(context)!.deleteee),textAlign: TextAlign.center,style: TextStyle(color:Colors.white,fontSize: 20,fontWeight: FontWeight.bold),),
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
                      setState(() {
                        l_test.removeAt(i);
                      });
                      t=(DateTime.now().year.toString())+'/'+(DateTime.now().month.toString())+'/'+(DateTime.now().day.toString());
                      var res=await sql.update({
                        "user":"${textuser.text}",
                        "pass":"${textpass.text}",
                        "image":"${l_test.toString().replaceAll('[', '').replaceAll(']', '').replaceAll(' ', '')}",
                        "note":"${textnote.text}",
                        "time":"${t}",
                        "Url":"${texturl.text}"
                      },"id=$id");
                      print(res);
                      late BuildContext dialogContext = context;
                        Timer? timer = Timer(Duration(milliseconds: 3000), (){
                          Navigator.pop(dialogContext);
                        });
                        Navigator.of(context).pop();
                      Fluttertoast.showToast(
                          msg: "${AppLocalizations.of(context)!.deleted}",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor:Color(0xfff4af36),
                          textColor: Colors.white,
                          fontSize: 16.0
                      );
                    },
                      child:Text((AppLocalizations.of(context)!.delete),textAlign: TextAlign.center,style: TextStyle(color:Colors.white,fontSize: 20),))),
                        ],)],
          ),
                  ]
                    ),
                  );
                    });},
                       child: ListView(reverse:false,shrinkWrap: true,physics: ClampingScrollPhysics(),
                          children:
                          [Container(margin: EdgeInsets.all(10),
                            decoration:
                            BoxDecoration(borderRadius:BorderRadiusDirectional.circular(15),color: Colors.teal[700]),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 0,vertical: 0),
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child:Image.file(f)
                              ),
                            ),
                          ),
                          ]),
                     );}
                  )
                              :Text(""),
                        ] ),
                  ),
                ),
              ),)
      );   },);
  }
}
