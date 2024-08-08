import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:passcode_screen/circle.dart';
import 'package:passcode_screen/keyboard.dart';
import 'package:passcode_screen/passcode_screen.dart';
import 'package:provider/provider.dart';
import 'package:saving_password/acc_data.dart';
import 'package:saving_password/add_data.dart';
import 'package:flutter/material.dart';
import 'package:saving_password/passwords.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:saving_password/reset.dart';
import 'package:saving_password/key.dart';
import 'package:saving_password/sql.dart';
import 'Ver_ph.dart';
import 'animations/container_transition.dart';
import 'animations/fade_through_transition.dart';
import 'ch_phone.dart';
import 'dataa.dart';
import 'firebase_options.dart';
import 'lock.dart';
var xlxx;
var tok="";
bool ln=true;
var language='en';
var xlx;var x='en';
late Locale _locale;
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
BuildContext? Context = navigatorKey.currentContext;
String storedpass="",phnum="";
@override
void main()async {
  WidgetsFlutterBinding.ensureInitialized();
   await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  WidgetsFlutterBinding.ensureInitialized();
  runApp(ChangeNotifierProvider(create: (context) => dataa(),child: MyApp(),));
  WidgetsBinding.instance.addObserver(MyApp());
}
class MyApp extends StatefulWidget  with WidgetsBindingObserver{
  const MyApp({Key? key}) : super(key: key);

  @override
  static void setLocale(BuildContext context, Locale newLocale) async {
    _MyHomePageState? state = context.findAncestorStateOfType<_MyHomePageState>();
    state?.changeLanguage(newLocale);
  }
  _showLockScreenpass(BuildContext context,
      {required bool opaque,required var d,
        required CircleUIConfig circleUIConfig,
        required KeyboardUIConfig keyboardUIConfig,
        required Widget cancelButton,
        required List<String> digits}) {
    final StreamController<bool> _verificationNotifier = StreamController<bool>.broadcast();
    bool isAuthenticated = false;
    // selectstored();
    Navigator.push(
        context,
        PageRouteBuilder(
          opaque: opaque,
          pageBuilder: (context, animation, secondaryAnimation) =>WillPopScope(onWillPop: ()async{
            return false;
          },
            child: PasscodeScreen(
              title: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  (AppLocalizations.of(context)!.entermain) ,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize:22),
                ),
              ),
              circleUIConfig: circleUIConfig,
              keyboardUIConfig: keyboardUIConfig,
              passwordEnteredCallback:(String enteredPasscode) {
                bool isValid=storedpass.toString()==enteredPasscode.toString();
                if(isValid){
                  Navigator.of(context).pop();
                  var D=Provider.of<dataa>(Context!);
                  D.ch_lock(true);
                }
                _verificationNotifier.add(isValid);
              },
              cancelButton: cancelButton,
              deleteButton: Text(
                (AppLocalizations.of(context)!.delete),
                style: const TextStyle(fontSize:20, color: Colors.white),
                semanticsLabel: (AppLocalizations.of(context)!.delete),
              ),
              shouldTriggerVerification: _verificationNotifier.stream,
              backgroundColor: Colors.black,
              cancelCallback:(){ SystemNavigator.pop();},
              digits: digits,
              passwordDigits:5,
              bottomWidget: _passcodeRestoreButton(),
            ),
          ),
        ));
  }
  _passcodeRestoreButton() => Align(
    alignment: Alignment.bottomCenter,
    child: Container(
      margin: const EdgeInsets.only(bottom: 10.0, top: 20.0),
      child: ElevatedButton(style: ElevatedButton.styleFrom(shape:StadiumBorder(),backgroundColor: Color(0xfff8c520)),
        // splashColor: Colors.white.withOpacity(0.4),
        // highlightColor: Colors.white.withOpacity(0.2),
        child: Text(
          (AppLocalizations.of(Context!)!.resetpass),
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize:20, color: Colors.black, fontWeight: FontWeight.bold),
        ),

        onPressed: _resetApplicationPassword,
      ),
    ),
  );
  _resetApplicationPassword() {
    Navigator.maybePop(Context!).then((result) {
      if (!result) {
        return;
      }
      _restoreDialog(() {
        Navigator.maybePop(Context!);
      });
    });
  }
  _restoreDialog(VoidCallback onAccepted) {
    BuildContext dialogContext;
    showDialog(
      context: Context!,
      builder: (BuildContext context) {dialogContext=context;
        return AlertDialog(
          insetPadding: EdgeInsets.all(4),
          contentPadding: EdgeInsets.all(12),
          shape: OutlineInputBorder(
              borderSide: BorderSide.none),
          backgroundColor: Color(0xfff4af36),
          // backgroundColor:Colors.white,
          title: Text(
            (AppLocalizations.of(context)!.resetpass),
            style: const TextStyle(fontSize:22,color: Colors.black,fontWeight: FontWeight.bold),
          ),
          content: Text(
            (AppLocalizations.of(context)!.passreset),
            style: const TextStyle(fontSize:18,color:Colors.white),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            ElevatedButton(style: ElevatedButton.styleFrom(shape:StadiumBorder(),backgroundColor: Color.fromRGBO(0,25,52,1)),
              child: Text(
                (AppLocalizations.of(context)!.cancel),
                style: const TextStyle(color:Colors.white,fontSize: 18),
              ),
              onPressed: () {
              Navigator.of(context).pop(dialogContext);
              },
            ),
            ElevatedButton(style: ElevatedButton.styleFrom(shape:StadiumBorder(),backgroundColor:Color.fromRGBO(0,25,52,1)),
              child: Text(
                (AppLocalizations.of(context)!.proceed),
                style: const TextStyle(fontSize: 18,color:Colors.white,),
            ),
              onPressed:()async{
                late BuildContext dialogContext = context;
                late BuildContext sdialogContext = context;
                late BuildContext cdialogContext = context;
                try {
                  await FirebaseAuth.instance.verifyPhoneNumber(
                    phoneNumber: "$phnum",
                    timeout: Duration(seconds: 30),
                    verificationCompleted:(PhoneAuthCredential credential) async {print("done");},
                    verificationFailed: (FirebaseAuthException e) {
                      Timer? timer = Timer(Duration(milliseconds: 3000), (){
                        Navigator.pop(dialogContext);
                      });
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
                                (AppLocalizations.of(context)!.error),
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
                        Navigator.of(context).pop();
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => reset(
                            ver_id: verificationId.toString(),
                            phone: "$phnum",),));
                      });
                    },
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
                  );}
              },
            ),
          ],
        );
      },
    );}
  @override
 // var showlock=false;
  void didChangeAppLifecycleState(AppLifecycleState state){
      if (state == AppLifecycleState.resumed) {
        var D=Provider.of<dataa>(Context!,listen: false);;
        D.ch_lock(true);
        storedpass.length>0?
        _showLockScreenpass(d:true,
          Context!,
          opaque: false,
          cancelButton: Text(
            (AppLocalizations.of(Context!)!.cancel),
            style: const TextStyle(fontSize: 16, color: Colors.white,),
            semanticsLabel: (AppLocalizations.of(Context!)!.cancel),
          ), circleUIConfig:CircleUIConfig(), keyboardUIConfig:KeyboardUIConfig(), digits: [],) :null;
      }
    else  if (state == AppLifecycleState.paused) {
      print("paused");
    }
  }
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  changeLanguage(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }
  Widget build(BuildContext context) {
    return Consumer<dataa>(builder: (context, D, child){
      return
        MaterialApp(
              supportedLocales: [
                Locale('en', 'US'),
                Locale('ar')
              ],
              // locale: _locale,
              localeResolutionCallback: (locale, supportedLocales) {
                for (var supportedLocale in supportedLocales) {
                  if (supportedLocale.languageCode == locale?.languageCode &&
                      supportedLocale.countryCode == locale?.countryCode) {
                    return supportedLocale;
                  }
                }
                return supportedLocales.first;
              },
              localizationsDelegates: AppLocalizations.localizationsDelegates,

              locale:Locale(D.language),
            navigatorKey: navigatorKey,
              title: 'Flutter Demo',debugShowCheckedModeBanner: false,color: Colors.white,
              theme: ThemeData(
                  fontFamily: "Arimo-VariableFont_wght",
                    textTheme: Theme.of(context).textTheme.apply(
                      bodyColor: Colors.black,
                      displayColor:Colors.white,

                  )
              ),home:MyHomePage(),
              routes: {
                "passwords":(context)=>passwords(ln:ln),
                "add_data":(context) =>add_data (ln:ln),
                "reset":(context) =>reset(phone: "",ver_id: ""),
                "key":(context) =>key(),
                "verified":(context) =>verified(),
                "ch_phone":(context) =>ch_phone(),
                "ver_ph":(context) =>ver_ph(ver_id: "",phone: ""),
                "acc_data":(context)=> acc_data(id: "",title:""),
                "container_transition":(context)=> OpenContainerTransformDemo(),
                "fade":(context)=> FadeThroughTransitionDemo(),
              }
          );},
    );
  }
}


class MyHomePage extends StatefulWidget {
  @override

  State<MyHomePage> createState() => _MyHomePageState();
}
class _MyHomePageState extends State<MyHomePage> {
  @override
  SQLDB sql=SQLDB();
  @override

  changeLanguage(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }
  List l_pass=[];

  final StreamController<bool> _verificationNotifier = StreamController<bool>.broadcast();
  bool isAuthenticated = false;
  selectstored()async{
    var res=await sql.selectstored();
    var y=res.toList().first;
    for (final e in y.entries) {
      setState(() {
        storedpass=e.value.toString();});
    }
  }selectphone()async{
    var res=await sql.selectphone();
    var y=res.toList().first;
    for (final e in y.entries) {
      setState(() {
        phnum=e.value.toString();});
    }
  }
  @override
  void dispose() {
    _verificationNotifier.close();
    super.dispose();
  }
  readdata()async{
    var re=await sql.initialdb();
  }
  void initState() {
    // TODO: implement initState
    _locale=Locale('en');
    readdata();
    selectphone();
    selectstored();
    super.initState();
  }
  CollectionReference user=FirebaseFirestore.instance.collection("$xlxx");
  _showLockScreenpass(BuildContext context,
      {required bool opaque,required var d,
        required CircleUIConfig circleUIConfig,
        required KeyboardUIConfig keyboardUIConfig,
        required Widget cancelButton,
        required List<String> digits}) {
    selectstored();
    Navigator.push(
        context,
        PageRouteBuilder(
          opaque: opaque,
          pageBuilder: (context, animation, secondaryAnimation) => PasscodeScreen(
            title: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                (AppLocalizations.of(context)!.entermain) ,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize:22),
              ),
            ),
            circleUIConfig: circleUIConfig,
            keyboardUIConfig: keyboardUIConfig,
            passwordEnteredCallback:(String enteredPasscode) {
              bool isValid=storedpass.toString()==enteredPasscode.toString();
              if(isValid){
                Navigator.of(context).pop();
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) =>
                        passwords(ln:d)));
              }
              _verificationNotifier.add(isValid);
            },
            cancelButton: cancelButton,
            deleteButton: Text(
              (AppLocalizations.of(context)!.delete),
              style: const TextStyle(fontSize:20, color: Colors.white),
              semanticsLabel: (AppLocalizations.of(context)!.delete),
            ),
            shouldTriggerVerification: _verificationNotifier.stream,
            backgroundColor: Colors.black.withOpacity(0.8),
            cancelCallback:(){ Navigator.maybePop(context);},
            digits: digits,
            passwordDigits:5,
            bottomWidget: _passcodeRestoreButton(),
          ),
        ));
  }
  _passcodeRestoreButton() => Align(
    alignment: Alignment.bottomCenter,
    child: Container(
      margin: const EdgeInsets.only(bottom: 10.0, top: 20.0),
      child: ElevatedButton(style: ElevatedButton.styleFrom(shape:StadiumBorder(),backgroundColor: Color(0xfff8c520)),
        // splashColor: Colors.white.withOpacity(0.4),
        // highlightColor: Colors.white.withOpacity(0.2),
        child: Text(
          (AppLocalizations.of(context)!.resetpass),
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize:20, color: Colors.black, fontWeight: FontWeight.bold),
        ),

        onPressed: _resetApplicationPassword,
      ),
    ),
  );
  _resetApplicationPassword() {
    Navigator.maybePop(context).then((result) {
      if (!result) {
        return;
      }
      _restoreDialog(() {
        Navigator.maybePop(context);
      });
    });
  }
  _restoreDialog(VoidCallback onAccepted) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: EdgeInsets.all(4),
          contentPadding: EdgeInsets.all(12),
          shape: OutlineInputBorder(
              borderSide: BorderSide.none),
          backgroundColor: Color(0xfff4af36),
          // backgroundColor:Colors.white,
          title: Text(
            (AppLocalizations.of(context)!.resetpass),
            style: const TextStyle(fontSize:22,color: Colors.black,fontWeight: FontWeight.bold),
          ),
          content: Text(
            (AppLocalizations.of(context)!.passreset),
            style: const TextStyle(fontSize:18,color: Colors.black87),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            ElevatedButton(style: ElevatedButton.styleFrom(shape:StadiumBorder(),backgroundColor: Color.fromRGBO(0,25,52,1)),
              child: Text(
        (AppLocalizations.of(context)!.cancel),
                style: const TextStyle(fontSize: 18,color: Colors.white),
              ),
              onPressed: () {
                Navigator.maybePop(context);
              },
            ),
            ElevatedButton(style: ElevatedButton.styleFrom(shape:StadiumBorder(),backgroundColor:Color.fromRGBO(0,25,52,1)),
              child: Text(
                (AppLocalizations.of(context)!.proceed),
                style: const TextStyle(fontSize: 18,color: Colors.white),
              ),
              onPressed:()async{
                late BuildContext dialogContext = context;
        late BuildContext sdialogContext = context;
        late BuildContext cdialogContext = context;
        try {
        await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: "$phnum",
        timeout: Duration(seconds: 30),
        verificationCompleted:(PhoneAuthCredential credential) async {print("done");},
        verificationFailed: (FirebaseAuthException e) {
        Timer? timer = Timer(Duration(milliseconds: 3000), (){
        Navigator.pop(dialogContext);
        });
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
          (AppLocalizations.of(context)!.error),
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
        Navigator.of(context).pop();
        Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => reset(
        ver_id: verificationId.toString(),
        phone: "$phnum",),));
        });
        },
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
          );}
              },
            ),
          ],
        );
      },
    );}
  Widget build(BuildContext context) {
    var D=Provider.of<dataa>(context);
    var lan="";
    return Scaffold(
          body:Consumer<dataa>(builder: (context, D, child){
            // D.c_ln(true);
            return Container(width: double.infinity,height: double.infinity,
              decoration:
              BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("pic/bg.jpeg"),
                  fit: BoxFit.cover,colorFilter: ColorFilter.mode(Colors.black12, BlendMode.color),
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  gradient:LinearGradient(
                      begin:Alignment.topCenter,end: Alignment.bottomLeft,
                      colors: [Color(0xff02182E),Colors.black]),
                ),
                child: Column(
                  children: [
                    Align(alignment:!D.ln?Alignment.topRight:Alignment.topLeft,
                      child: Container(height: 200,width: MediaQuery.of(context).size.width-50,
                        decoration: BoxDecoration(color:Color(0xfff4af36),borderRadius: !D.ln?
                        BorderRadius.only(bottomLeft:Radius.circular(250)):BorderRadius.only(bottomRight:Radius.circular(250))
                        ),
                        child:Column(
                        children: [
                          SizedBox(height:25,),
                        SizedBox(
                          child: Align(alignment: Alignment.center,
                            child: PopupMenuButton(color:Color.fromRGBO(0,25,52,1),initialValue:D.language,
                                child:
                                Row(mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Icon(Icons.arrow_drop_down_sharp,color:Color.fromRGBO(0,25,52,1),size:35,),
                                    // FaIcon(FontAwesomeIcons.globe)
                                    Text( (AppLocalizations.of(context)!.language),style: TextStyle(fontWeight:FontWeight.bold,fontSize:22,fontFamily: "Amiri"),),
                                  ],
                                )
                                ,
                                itemBuilder: (context) {
                                  return [
                                    PopupMenuItem(
                                        value:  (AppLocalizations.of(context)!.english),
                                        child: InkWell(
                                            onTap: () async {
                                              setState(() {
                                                var e='en';
                                                x=e.toString();
                                                _locale=Locale(e.toString());

                                                MyApp.setLocale(context,Locale(e.toString()));
                                                D.ch_lan(e.toString());
                                                D.c_ln(true);
                                              });
                                              Navigator.of(context)
                                                  .pushReplacement(MaterialPageRoute(
                                                builder: (context) => MyHomePage(),));
                                            },
                                            child: Align(alignment: Alignment.center,child:Text( (AppLocalizations.of(context)!.english),style: TextStyle(color:Colors.white,fontSize:18,fontFamily: "Amiri"),)))
                                    ),
                                    PopupMenuItem(
                                        value:  (AppLocalizations.of(context)!.arabic),
                                        child: InkWell(
                                            onTap: () {
                                              setState(() {
                                                var e='ar';
                                                x=e.toString();
                                                _locale=Locale(e.toString());

                                                MyApp.setLocale(context,Locale(e.toString()));
                                                D.ch_lan(e.toString());
                                                D.c_ln(false);
                                              });
                                              Navigator.pop(context);
                                            },
                                            child: Align(alignment: Alignment.center,child:Text( (AppLocalizations.of(context)!.arabic),style: TextStyle(color:Colors.white,fontSize:18,fontFamily: "Amiri"),)))
                                    )];}),
                          ),
                        ),
                        ],
                      ),),
                    ) ,
                    SizedBox(height: 200,),
                    Container(height: 100,
                      width: 100,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(color:Color(0xfff4af36),
                      // decoration: BoxDecoration(color:Color(0xff001934),
                          borderRadius: BorderRadius.circular(100)),
                      child:
                      IconButton(onPressed: () async{
                        selectstored();
                        selectphone();
                        storedpass.length>0?
                        _showLockScreenpass(d:D.ln,
                          context,
                          opaque: false,
                          cancelButton: Text(
                            (AppLocalizations.of(context)!.cancel),
                            style: const TextStyle(fontSize: 16, color: Colors.white,),
                            semanticsLabel: (AppLocalizations.of(context)!.cancel),
                          ), circleUIConfig:CircleUIConfig(), keyboardUIConfig:KeyboardUIConfig(), digits: [],
                        ): Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) =>
                                passwords(ln:D.ln)));
                                    }, icon: Icon(Icons.lock, size: 50,color: Colors.white,
                      )
                      ),
                    ),Expanded(child: SizedBox()),
                    Align(alignment:D.ln?Alignment.topRight:Alignment.topLeft,
                      child: Container(height:80,width:80,decoration: BoxDecoration(color:Color(0xfff4af36),borderRadius:!D.ln?
                      BorderRadius.only(topRight: Radius.circular(150)):BorderRadius.only(topLeft: Radius.circular(150))),)
                    )
                  ],
                ),
              ),
            );
    }));
  }
}
