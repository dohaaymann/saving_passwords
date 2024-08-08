import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
class SQLDB{
  static Database? _db;
  Future<Database?> get db async{
    if(_db==null){
      _db=await initialdb();
      return _db;
    }else{
      return _db;
    }
  }
  var path;
  initialdb()async{
    var database=await getDatabasesPath();
    path=join(database,"passwords.db");
    var mydb=await openDatabase(path,onCreate: create,version:1,onUpgrade: upgrade);
    print("database created");
    return mydb;
  }
  upgrade(Database db,int oldversion,int newversion)async{
    print("------------ upgrade -----------");
  }
  create(Database db,int version)async{
    await db.execute('''
     CREATE TABLE 'spass'(
     'id' INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL ,
     'acc' TEXT,
     'user' TEXT,
     'pass' TEXT,
     'image' TEXT,
     'logo' TEXT,
     'note' TEXT,
     'Url' Text,
     'time' TEXT,
      'phone' Text,
      'stored' Text)
     ''');
    await db.execute('''
     CREATE TABLE 'lock'(
      'phone' Text,
      'stored' Text)
     ''');
    insertlock();
    // inserttable();

  }
  insertlock()async{
    Database? mydb=await db;
    var res= await mydb?.insert('lock', {
      'phone':"",
      'stored':""
    });}
  inserttable()async{
    Database? mydb=await db;
    var res= await mydb?.insert('spass', {
      "id":null,
      'acc': "Facebook",
      'user': null,
      'pass' :null,
      'image' :null,
      'logo':null,
      'note': null,
      'Url':null,
        'time' :"- / - / -",
      'phone':"",
      'stored':""
    });await mydb?.insert('spass', {
      "id":null,
      'acc': "Instagram",
      'user': null,
      'pass' :null,
      'image' :null,
      'logo':null,
       'note': null,
      'Url':null,
        'time' :"- / - / -",
      'phone':"",
      'stored':""
    });await mydb?.insert('spass', {
      "id":null,
      'acc': "Twitter",
      'user': null,
      'pass' :null,
      'image' :null,
      'logo':null,
       'note': null,
      'Url':null,
        'time' :"- / - / -",
      'phone':"",
      'stored':""
    });await mydb?.insert('spass', {
      "id":null,
      'acc': "Snapchat",
      'user': null,
      'pass' :null,
      'image' :null,
      'logo':null,
       'note': null,
      'Url':null,
        'time' :"- / - / -",
      'phone':"",
      'stored':""
    });await mydb?.insert('spass', {
      "id":null,
      'acc': "Gmail",
      'user': null,
      'pass' :null,
      'image' :null,
      'logo':null,
       'note': null,
      'Url':null,
        'time' :"- / - / -",
      'phone':"",
      'stored':""
    });
    return res;
  }
  insert(String acc,String user,String pass,String note,String url,String logo)async{
    Database? mydb=await db;
    var res= await mydb?.insert('spass', {
      "id":null,
      'acc': acc,
      'user': user,
      'pass' :pass,
      'image' :null,
      'logo':logo,
      'note': note,
      'Url':url,
      'time' :null,
      'phone':"",
      'stored':""
    });
    return res;
  }
  read(String table)async{
    Database? mydb=await db;
    var res= await mydb?.query(table);
     
    return res;
  }readbyid(int id)async{
    Database? mydb=await db;
    var res= await mydb?.rawQuery("SELECT * FROM spass WHERE id=$id");
     
    return res;
  }selectimg(int id)async{
    Database? mydb=await db;
    var res= await mydb?.rawQuery("SELECT image FROM spass WHERE id=$id");
     
    return res;
  }selectuser()async{
    Database? mydb=await db;
    var res= await mydb?.rawQuery("SELECT user FROM spass");
     
    return res;
  }selectphone()async{
    Database? mydb=await db;
    var res= await mydb?.rawQuery("SELECT phone FROM lock");
    return res;
  }selectstored()async{
    Database? mydb=await db;
    var res= await mydb?.rawQuery("SELECT stored FROM lock");
    return res;
  }
  update(var value,var mywhere)async{
    Database? mydb=await db;
    var res= await mydb?.update('spass',value,where:mywhere );
    // var res= await mydb?.rawUpdate(sql);
      
    return res;
  } updatetoall(var value)async{
    Database? mydb=await db;
    var res= await mydb?.update('spass',value,);
    // var res= await mydb?.rawUpdate(sql);
      
    return res;
  } updatelock(var value)async{
    Database? mydb=await db;
    var res= await mydb?.update('lock',value,);
    // var res= await mydb?.rawUpdate(sql);
      
    return res;
  }
  delete(int id)async{
    Database? mydb=await db;
    var res= await mydb?.delete("spass",where: "id=$id");
    return res;
  }
  mydeletedatabase()async{
    var database=await getDatabasesPath();
    path=join(database,"untitle3.db");
    await deleteDatabase(path);
  }
}