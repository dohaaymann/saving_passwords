import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:saving_password/add_data.dart';
import 'acc_data.dart';

bool b=true,a=true;
class passwords extends StatelessWidget {
  bool ln;
    passwords({required this.ln}){
      b=true;
      a=true;
       print(ln);
    }
  List l_acc=[];
  var username,pass;
  CollectionReference user=FirebaseFirestore.instance.collection("acc");
  CollectionReference user1=FirebaseFirestore.instance.collection("acc").doc().collection("acc_data");


  void messagestream(var Id) async{
    await for(var snapshot in FirebaseFirestore.instance.collection("acc").doc(Id).collection("acc_data").snapshots()){
      for(var mess in snapshot.docs){
        username=mess.get("user");
        pass=mess.get("pass");
      }
    }
  }

  void getdata(var Id) async{
    var c= await FirebaseFirestore.instance.collection("acc").doc(Id).collection("acc_data").get();
    c.docs.forEach((element) {
      for(var mess in c.docs){
        print(mess.data());
      }
    });
  }
@override

  Widget build(BuildContext context) {
    return
      SafeArea(
        child: Directionality(textDirection: ln?TextDirection.ltr:TextDirection.rtl,
          child: Scaffold(
          resizeToAvoidBottomInset: true,
            appBar: AppBar(backgroundColor: Colors.teal[900],
          centerTitle:true,automaticallyImplyLeading: false,
           actions: [
             Row(mainAxisAlignment: MainAxisAlignment.end,
               children: [
             a?TextButton(onPressed: (){
                   b = !b; a = !a;
                   (context as Element).markNeedsBuild();
                 }, child:Text((AppLocalizations.of(context)!.edit),style: TextStyle(color: Colors.white,fontSize: 18),)):TextButton(onPressed: (){
               a = !a;b = !b;
               (context as Element).markNeedsBuild();
             }, child:Text((AppLocalizations.of(context)!.cancel),style: TextStyle(color: Colors.white,fontSize: 18),))
               ],
             )
          ],
          title:Text(AppLocalizations.of(context)!.passwords,textAlign: TextAlign.center),
            ),
            floatingActionButton: FloatingActionButton(backgroundColor:Colors.teal[700] ,
          onPressed: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
               add_data(user: "", pass: "", app: "", ln: ln)
            ));              },child:Icon(Icons.add,size: 30,) ,),
            body:
            SizedBox(
              child:
              SingleChildScrollView(
                child: Column(
                  children: [
                    StreamBuilder(  stream:user.snapshots(),
                         builder:  (context, snapshot) {
                          for(var mess in snapshot.data!.docs){
                              final messageget=mess.get("account");
                              final messagew=Text("$messageget");
                              l_acc.add(messagew);
                          }
                          return ListView.builder(
                            itemCount:snapshot?.data?.docs?.length ,shrinkWrap: true,physics: ClampingScrollPhysics(),
                            itemBuilder: (context, i) {
                              DocumentSnapshot data=snapshot!.data!.docs[i];
                              return Container(  margin: EdgeInsets.all(10),height: 70,
                                decoration:
                              BoxDecoration(borderRadius:BorderRadiusDirectional.circular(15),color: Colors.teal[700]),
                                child: InkWell(
                                  onLongPress: (){},
                                  onTap: ()async{
                                    var c=await FirebaseFirestore.instance.collection("acc").doc(data.id).collection("acc_data");
                                    print("---------------------");
                                    void getdata(var Id) async{
                                      var c= await FirebaseFirestore.instance.collection("acc").doc(Id).collection("acc_data").get();
                                      c.docs.forEach((element) {
                                        for(var mess in c.docs){
                                          username=mess.data();
                                        }
                                      });
                                    }
                                   print(username);
                                    print(data.id);
                                    Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
                                        acc_data(app:data["account"],Id: data.id,ln:ln
                                        ),));
                                    print("---------------------");
                                  },
                                 child:
                                      Row(
                                        children: [
                                          Container(margin: EdgeInsets.all(0),width: 70,height: 70
                                              ,alignment:Alignment.center,decoration: BoxDecoration(color: Colors.blueGrey[200],
                                                  borderRadius: BorderRadius.only(topRight: Radius.circular(15),
                                                    topLeft: Radius.circular(15),  bottomLeft: Radius.circular(15),
                                                      bottomRight:Radius.circular(15) ))
                                            ,child: 
                                              Icon(Icons.lock,size: 30,color: Colors.teal[900],)
                                          ),
                                          Container( margin: EdgeInsets.only(left: 10,right: 7),
                                            child: Text((data['account']!).toString(),style: TextStyle(color: Colors.white,fontSize: 25,fontWeight: FontWeight.bold),),
                                          ),Expanded(child: Padding(padding: EdgeInsetsDirectional.all(10)))
                                         ,Container(child:b?enter():delete(Id_d: data.id,))
                                        ],
                                      )
                                ),
                              );
                            },
                         );
                            },
                          )
                  ],
                ),
              ),
            )
    ),
        ),
      );

  }
}

class delete extends StatelessWidget {
  @override
  var Id_d;
  delete({required this.Id_d});
  Widget build(BuildContext context) {
    return IconButton(onPressed: ()async{

           return  showDialog(context: context, builder:(context) {
             return SizedBox(height: 50,width: 200,
               child: AlertDialog(
                   shape:UnderlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                   title: Text((AppLocalizations.of(context)!.deletee),textAlign: TextAlign.center,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                   actions:[
                     Column(
                       children:[
                         Row( mainAxisAlignment: MainAxisAlignment.spaceAround,
                           children: [
                             Container( margin:EdgeInsetsDirectional.only(top: 10,end: 5),child: ElevatedButton(
                                 onPressed: (){
                                   Navigator.pop(context);
                                 },
                                 child:Text((AppLocalizations.of(context)!.cancel),textAlign: TextAlign.center,style: TextStyle(fontSize: 20),))),

                             Container( margin:EdgeInsetsDirectional.only(top: 10,end: 5),child: ElevatedButton(
                                 onPressed: () async{
                    var z=await FirebaseFirestore.instance.collection("acc").doc(Id_d).collection("acc_data").doc();

                                 try{ print(Id_d);
                                     await FirebaseFirestore.instance.collection("acc").doc(Id_d).delete();
                          await FirebaseFirestore.instance.collection("acc").doc(Id_d).collection("acc_data").doc("D").delete();
                          print (z.id);
                                   }catch(e){
                                     print("error: $e");
                                   }
                                  Navigator.pop(context);
                                 },
                                 child:Text((AppLocalizations.of(context)!.delete),textAlign: TextAlign.center,style: TextStyle(fontSize: 20),))),
                           ],)],
                     ),
                   ]
               ),
             );});

    }, icon: Icon(Icons.delete,color: Colors.white,));
  }}

class enter extends StatelessWidget {
  @override

  Widget build(BuildContext context) {
    return IconButton(onPressed: (){}, icon: Icon(Icons.arrow_forward_ios,color: Colors.white,));
  }
}