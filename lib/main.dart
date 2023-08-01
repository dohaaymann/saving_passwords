import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
//import 'package:image_picker/image_picker.dart';
import 'package:saving_password/acc_data.dart';
import 'package:saving_password/add_data.dart';
import 'package:flutter/material.dart';
import 'package:saving_password/passwords.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
void main()async {
  WidgetsFlutterBinding.ensureInitialized();
   await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}
bool ln=true;
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override

  Widget build(BuildContext context) {
    return MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
     // locale: Locale("en"),
      title: 'Flutter Demo',debugShowCheckedModeBanner: false,color: Colors.white,
      theme: ThemeData(
        primarySwatch: Colors.teal,textTheme: TextTheme(headline2: TextStyle(color: Colors.red))
      ),
      home:MyHomePage(),
      routes: {
      "passwords":(context)=>passwords(ln:ln),
        "add_data":(context) =>add_data (user: "",pass: "",app: "",ln:ln),
      "acc_data":(context)=> acc_data(app: "",Id: "",ln:ln),
      }
    );
  }
}
class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}


class _MyHomePageState extends State<MyHomePage> {
  @override
 //XFile? image;

  // final ImagePicker picker = ImagePicker();
  //
  // //we can upload image from camera or from gallery based on parameter
  // Future getImage(ImageSource media) async {
  //   //final  image =  await  _picker.pickImage(source: ImageSource.camera,maxHeight: 200, maxWidth: 200);
  //   var img = await picker.pickImage(source: media,maxHeight: 200, maxWidth: 200);
  //
  //   setState(() {
  //     image = img;
  //   });
  // }
var image;
   _pickFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);

    // if no file is picked
    if (result == null) return;
    print(result.files.first.name);
    print(result.files.first.size);
    setState(() {
      image=result.files.first.path;
        });

    print(result.files.first.path);
  }
  Widget build(BuildContext context) {
    return
      Scaffold(backgroundColor: Colors.teal[900],
          body:
    // Center(
    //         child: Column(
    //           mainAxisAlignment: MainAxisAlignment.center,
    //           children: [
    //             ElevatedButton(
    //               onPressed: () async{
    //                 await _pickFile();
    //               },
    //               child: Text('Upload Photo'),
    //             ),
    //             SizedBox(
    //               height: 10,
    //             ),
    //             image != null
    //                 ? Padding(
    //               padding: const EdgeInsets.symmetric(horizontal: 20),
    //               child: ClipRRect(
    //                 borderRadius: BorderRadius.circular(8),
    //                 child: Image.file(
    //                   //to show image, you type like this.
    //                   File(image),
    //                   fit: BoxFit.cover,
    //                   width: MediaQuery.of(context).size.width,
    //                   height: 300,
    //                 ),
    //               ),
    //             )
    //                 : Text(
    //               "No Image",
    //               style: TextStyle(fontSize: 20),
    //             )
    //           ],
    //         ),
    //       ),
          Center(child:
          Container(height: 100,width: 100,
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(color:Colors.teal,
                borderRadius: BorderRadius.circular(100)),
            child: IconButton(onPressed: () {
              //upload();
              var L = Localizations.localeOf(context);
              var s=L;
              bool m;
              if (s.toString() == "en") {
                  m = true;
                  (context as Element).markNeedsBuild();

              } else {
                m = false;
                (context as Element).markNeedsBuild();
              }
              print(L);
              print("$s:$m");
              Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
                  passwords(ln: m)
              ));
            }, icon: Icon(Icons.lock, size: 50 ,color: Colors.white,
            )
            ),
          ),)
      );
  }
}
