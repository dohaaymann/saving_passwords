
import 'dart:async';

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_shake_animated/flutter_shake_animated.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:saving_password/add_data.dart';
import 'package:saving_password/key.dart';
import 'package:saving_password/sql.dart';
import 'acc_data.dart';
import 'dataa.dart';
bool b=true,a=true;
class passwords extends StatefulWidget {
  var ln;
  passwords({required this.ln});
  @override
  State<passwords> createState() => _passwordsState(ln: ln);
}

class _passwordsState extends State<passwords> {
  @override
  late bool ln;
  _passwordsState({required this.ln}){
    b=true;
    a=true;
  }
  @override
  var rt;

  SQLDB sql=SQLDB();
  List l_pass=[];
  List l_user=[];
  List searchlist=[];
  readdata()async{
    var res=await sql.read("spass");
    l_pass.addAll(res);
    if(this.mounted){
      setState(() { });
    }
  }
  List logo=[];

  List<Color> colors = [Color(0xff54192d), Color.fromRGBO(246,156,113,1),Color(0xffa642560),Color(0xff80a3c9),Color(0xffC28EB4),
    Color(0xff223c55),Colors.teal,Color(0xff54192d),Color(0xffe9bcb9),Color(0xffC28EB4),Color.fromRGBO(246,156,113,1),
    Color(0xff80a3c9),Color(0xffa642560),Color(0xff223c55), Color(0xfff4af36),Color(0xff54192d),Color(0xffe9bcb9),Color(0xffC28EB4),Color.fromRGBO(246,156,113,1),
    Color(0xff80a3c9),Color(0xffa642560),Color(0xff223c55), Color(0xfff4af36),Color(0xff54192d),Color(0xffe9bcb9),Color(0xffC28EB4),Color.fromRGBO(246,156,113,1),
    Color(0xff80a3c9),Color(0xffa642560),Color(0xff223c55), Color(0xfff4af36),Color(0xff54192d),Color(0xffe9bcb9),Color(0xffC28EB4),Color.fromRGBO(246,156,113,1),
    Color(0xff80a3c9),Color(0xffa642560),Color(0xff223c55), Color(0xfff4af36),Color(0xff54192d),Color(0xffe9bcb9),Color(0xffC28EB4),Color.fromRGBO(246,156,113,1),
    Color(0xff80a3c9),Color(0xffa642560),Color(0xff223c55),
   ];
  @override

  var play=false;
  List matchQuery=[];
  void search(String enteredKeyword) {
    if (enteredKeyword.isEmpty) {
     l_user = l_pass;
    } else {
     l_user = l_pass
          .where((user) =>
          user['acc'].toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
    }
    setState(() {
      matchQuery=l_user;
    });
  }
  @override
  void initState() {
    readdata();
    super.initState();
  }
  ScrollController ctr = ScrollController();
  TextEditingController _tsearch=TextEditingController();
  bool taped=false;var out='';
  Widget build(BuildContext context) {
   (context as Element).markNeedsBuild();
    var D=Provider.of<dataa>(context);
    return
      WillPopScope(onWillPop: ()async{
       if(out=='') {
         out=Fluttertoast.showToast(msg: 'Press back again to exit',fontSize: 20).toString();
           Timer? timer = Timer(Duration(seconds:3), (){
             out='';
           });
           return false;
      }else{
         SystemNavigator.pop();
         return false;
       }

        },
        child: Directionality(textDirection: !ln?TextDirection.rtl:TextDirection.ltr,
            child: Consumer<dataa>(builder:  (context,D, child) {
              return  Scaffold(
                  // backgroundColor: Color(0xff18604a),
                  // backgroundColor:,
                  resizeToAvoidBottomInset: true,
                  appBar: AppBar(leading: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: _OpenContainerWrapper(
                      transitionType: ContainerTransitionType.fade,
                      closedBuilder: (BuildContext _, VoidCallback openContainer) {
                        return Container(
                            margin:EdgeInsets.all(2),decoration:BoxDecoration(color:Color(0xfff4af36) ,borderRadius: BorderRadius.circular(100)),
                            child:IconButton(onPressed:openContainer, icon:FaIcon(FontAwesomeIcons.userShield,size: 20,))
                        );
                      },
                    ),

                  ),
                    backgroundColor:Color(0xff02182E),elevation:0,scrolledUnderElevation:40,
                    centerTitle:true,automaticallyImplyLeading: false,
                    actions: [
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Container(decoration: BoxDecoration(color: Color(0xfff4af36) ,borderRadius: BorderRadius.circular(300)),
                          child:l_pass.isNotEmpty!=0?(
                            a?TextButton(onPressed: (){
                              // Fluttertoast.showToast(msg: 'Press back again to exit');
                              b = !b; a = !a;
                              (context as Element).markNeedsBuild();
                            }, child:Text((AppLocalizations.of(context)!.edit),style: TextStyle(color: Colors.white,fontSize:20),)):TextButton(onPressed: (){
                              a = !a;b = !b;
                              (context as Element).markNeedsBuild();
                            }, child:Text((AppLocalizations.of(context)!.cancel),style: TextStyle(color: Colors.white,fontSize: 18),))):
                        TextButton(onPressed: null, child:
                        Text((AppLocalizations.of(context)!.edit),style: TextStyle(color: Colors.grey,fontSize: 18),))
                          ,),
                      )
                    ],
                    title:
                    Text(AppLocalizations.of(context)!.passwords,textAlign: TextAlign.center,style: TextStyle(color:Colors.white,fontSize:35,fontFamily: "DMSerifDisplay-Italic")
              )),
                  floatingActionButton:
                  !b?null: OpenContainer(
                    transitionType: ContainerTransitionType.fadeThrough,
                    openBuilder: (BuildContext context, VoidCallback _) {
                      return add_data(ln: D.ln);
                    },
                    closedElevation: 6.0,
                    closedShape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(50),
                      ),
                    ),
                    closedColor: Theme.of(context).colorScheme.secondary,
                    closedBuilder: (BuildContext context, VoidCallback openContainer) {
                      return Container( height: _fabDimension,
                        width: _fabDimension,color: Color(0xfff4af36),
                        child: Icon(
                          Icons.add,size:35,
                          color:Colors.white,
                        ),
                      );
                    },
                  ),
                  body:
                      Container(height: double.infinity,
              decoration: BoxDecoration(
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
              child:ListView(children: [
              l_pass.isEmpty?
              SizedBox(height:MediaQuery.of(context).size.height-20,
                child: Column(children: [
                        SizedBox(height: 150,),

                  Container(padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(shape: BoxShape.circle,
                    color: Color(0xfff4af36),
                  ),alignment: Alignment.center,
                    child: Image.asset("pic/giphy (1).gif",height:200,),
                  ) ,Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text((AppLocalizations.of(context)!.empty),style: TextStyle(color:Colors.white60,fontSize:16,fontWeight: FontWeight.bold)),
                      ),Expanded(child: SizedBox()),
                    ],),
              ):
                  Column(
                    children: [
                      SizedBox(height:5,),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child:Container(
                          decoration: BoxDecoration(color: Colors.white,
                          borderRadius: BorderRadius.circular(15)
                        ),
                            child: TextFormField(onTap: () =>setState(() {
                              taped=true;
                            }),onChanged:(e){ setState(() {
                              search(e);
                            });},
                              controller: _tsearch,onTapOutside: (v){FocusManager.instance.primaryFocus?.unfocus();}
                              ,decoration: InputDecoration(hintStyle: TextStyle(fontSize:18),
                                hintText:(AppLocalizations.of(context)?.search),prefixIcon: Icon(Icons.search),border: InputBorder.none,
                                  suffixIcon:taped?
                                  IconButton(onPressed: () {
                                    setState(() {
                                      FocusManager.instance.primaryFocus?.unfocus();
                                      _tsearch.clear();
                                      taped=false;
                                    });
                                  }, icon:FaIcon(FontAwesomeIcons.xmark,size:20,)):null
                              ),
                            )
                        )),
                      matchQuery.isEmpty?ListView.builder(itemCount:l_pass.length,shrinkWrap: true,physics: ClampingScrollPhysics(),
                                controller: ctr, itemBuilder: (context, i) {
                         return OpenContainer<bool>(
                                     closedColor:Colors.transparent,
                                     transitionType: ContainerTransitionType.fade,
                                     openBuilder: (BuildContext _, VoidCallback openContainer) {
                                       return  acc_data(id:l_pass[i]['id'],title:l_pass[i]['acc']);
                                     },
                                     tappable: false,closedElevation: 0,
                                     closedShape: const RoundedRectangleBorder(),
                                     closedBuilder: (BuildContext _, VoidCallback openContainer) {
                                       return SingleChildScrollView(
                                         child: Container( margin: EdgeInsets.fromLTRB(10,5,10,5),
                                              decoration:
                                              BoxDecoration(borderRadius:BorderRadiusDirectional.circular(25),color:colors[i]),
                                           child: ListTile(
                                             onTap:openContainer,
                                                     leading:Image.asset(l_pass[i]['logo'],fit:BoxFit.cover,height:60,),
                                                     title:Padding(
                                                         padding: const EdgeInsets.only(top:4),
                                                         child: Text(l_pass[i]['acc'].toString(),style: TextStyle(color: Colors.white,fontSize: 25,fontWeight: FontWeight.bold),),
                                                       ),
                                                       subtitle: Text(l_pass[i]['user'].toString(),style: TextStyle(color: Colors.white),),
                                                   // Expanded(child: Padding(padding: EdgeInsetsDirectional.all(10)))
                                                     trailing:b?enter():
                                                      ShakeWidget(autoPlay: true,
                                                          shakeConstant:ShakeLittleConstant1(),child:
                                                          delete(id:l_pass[i]['id'],ln: ln,))
                                         ),
                                         ),
                                       );
                                     },
                                   );
                                 },
                               ):ListView.builder(itemCount:matchQuery.length,shrinkWrap: true,physics: ClampingScrollPhysics(),
                        controller: ctr, itemBuilder: (context, i) {
                          return OpenContainer<bool>(
                            closedColor:Colors.transparent,
                            transitionType: ContainerTransitionType.fade,
                            openBuilder: (BuildContext _, VoidCallback openContainer) {
                              return  acc_data(id:matchQuery[i]['id'],title:matchQuery[i]['acc']);
                            },
                            tappable: false,closedElevation: 0,
                            closedShape: const RoundedRectangleBorder(),
                            closedBuilder: (BuildContext _, VoidCallback openContainer) {
                              return SingleChildScrollView(
                                child: Container(
                                  margin: EdgeInsets.all(12),
                                  decoration:
                                  BoxDecoration(borderRadius:BorderRadiusDirectional.circular(25),color:colors[i]),
                                  child: ListTile(
                                      onTap:openContainer,
                                      leading:Image.asset(matchQuery[i]['logo'],fit:BoxFit.cover,height:60,),title:Padding(
                                    padding: const EdgeInsets.only(top:4),
                                    child: Text(matchQuery[i]['acc'].toString(),style: TextStyle(color: Colors.white,fontSize:22,fontWeight: FontWeight.bold),),
                                  ),
                                      subtitle: Text(matchQuery[i]['user'].toString(),style: TextStyle(color: Colors.white),),
                                      // Expanded(child: Padding(padding: EdgeInsetsDirectional.all(10)))
                                      trailing:b?enter():
                                      ShakeWidget(autoPlay: true,
                                          shakeConstant:ShakeLittleConstant1(),child:
                                          delete(id:matchQuery[i]['id'],ln: ln,))
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      )
                    ])
              ]
              )
              ));
                            },
        ),
        ),
      );
  }
}
class delete extends StatefulWidget {
  var id,ln;
  delete({required this.id,required this.ln});
  @override
  State<delete> createState() => _deleteState();
}

class _deleteState extends State<delete> {
  @override
  SQLDB sql=SQLDB();
  Widget build(BuildContext context) {
    var D=Provider.of<dataa>(context);
    return Consumer<dataa>(builder: (context,D, child) {
      return IconButton(onPressed: ()async{
        return  showDialog(context: context, builder:(context) {
          return SizedBox(height: 40,width: 200,
            child: AlertDialog(
                insetPadding: EdgeInsets.all(7),
                // contentPadding: EdgeInsets.all(1),
                backgroundColor: Color.fromRGBO(0,25,52,1),
                shape:UnderlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                title: Text((AppLocalizations.of(context)!.deletee),textAlign: TextAlign.center,style: TextStyle(color:Colors.white,fontSize:20,fontWeight: FontWeight.bold),),
                actions:[
                  Column(
                    children:[
                      Row( mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(margin:EdgeInsetsDirectional.only(top: 1,end: 5),child: ElevatedButton(style:
                       ElevatedButton.styleFrom(backgroundColor: Color(0xfff4af36)),
                              onPressed: (){
                                // Navigator.pop(context);
                                Fluttertoast.showToast(msg: 'Press back again to exit');
                              },
                              child:Text((AppLocalizations.of(context)!.cancel),textAlign: TextAlign.center,style: TextStyle(color: Colors.white,fontSize: 20),))),


                          Container( margin:EdgeInsetsDirectional.only(top: 1,end: 5),child: ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: Color(0xfff4af36)),
                              onPressed: () async{
                                setState(() {
                                  var res=sql.delete(widget.id);
                                });
                                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => passwords(ln:widget.ln),));
                              },
                              child:Text((AppLocalizations.of(context)!.delete),textAlign: TextAlign.center,style: TextStyle(color: Colors.white,fontSize: 20),))),
                        ],)],
                  ),
                ]
            ),
          );});

      }, icon: Icon(Icons.delete,color: Colors.white,));
    });
  }
}

class enter extends StatelessWidget {
  @override

  Widget build(BuildContext context) {
    return IconButton(onPressed: (){}, icon: Icon(Icons.arrow_forward_ios,color: Colors.white,));
  }
}
class CustomSearchDelegate extends SearchDelegate {
  // Demo list to show querying
  List<String> searchTerms = [
    "Apple",
    "Banana",
    "Mango",
    "Pear",
    "Watermelons",
    "Blueberries",
    "Pineapples",
    "Strawberries"
  ];

  // first overwrite to
  // clear the search text
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: Icon(Icons.clear),
      ),
    ];
  }

  // second overwrite to pop out of search menu
  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: Icon(Icons.arrow_back),
    );
  }

  // third overwrite to show query result
  @override
  Widget buildResults(BuildContext context) {
    List<String> matchQuery = [];
    for (var fruit in searchTerms) {
      if (fruit.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(fruit);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(
          title: Text(result),
        );
      },
    );
  }

  // last overwrite to show the
  // querying process at the runtime
  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> matchQuery = [];
    for (var fruit in searchTerms) {
      if (fruit.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(fruit);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(
          title: Text(result),
        );
      },
    );
  }
}


const double _fabDimension = 56.0;

class _OpenContainerWrapper extends StatelessWidget {
  const _OpenContainerWrapper({
    required this.closedBuilder,
    required this.transitionType,
  });

  final CloseContainerBuilder closedBuilder;
  final ContainerTransitionType transitionType;

  @override
  Widget build(BuildContext context) {
    return OpenContainer<bool>(
      transitionType: transitionType,
      openBuilder: (BuildContext context, VoidCallback _) {
        return key();
      },
      tappable: false,closedColor: Color.fromRGBO(0,25,52,1),closedElevation: 0,
      closedBuilder: closedBuilder,
    );
  }
}