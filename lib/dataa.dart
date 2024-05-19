import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
class dataa extends ChangeNotifier{
  var image="";
  var num=0,c=0;
  var image_n="",tokenn;
   bool bapp=true;
   bool buser=true;
   bool bpass=true;
  var ver_ph,T_error=false,ver;
  var counter=0,time=false,load=false,ph;
  var dtextapp="",dtextuser, dtextpass, dtextnote;
  var storedpass="";
  var language="language";
  var showlock=false;
  List l_acc=[];
  var ln=true;
  ch_lock(var x) {
    showlock=x;
    notifyListeners();
  } ch_lan(var x) {
    language=x;
    notifyListeners();
  }ch_store(var x) {
    storedpass=x;
    notifyListeners();
  } ch_ph(var x) {
    ph=x;
    notifyListeners();
  } ch_ver1(var x){
    ver=x;
    notifyListeners();
  }
  void c_ln(bool x){
    ln=x;
    notifyListeners();
  }void addl(var x){
    l_acc.add(x);
    notifyListeners();
  }
  void Str_num(var x){
    x.toString();
    notifyListeners();
  }
  int numm(var x){
    num=x;
    print(num);
    notifyListeners();
    return num;
  }
  void count(var x){
    c=x;
    notifyListeners();
  }
  void adtokenn(var x){
    tokenn=x;
    notifyListeners();
    return tokenn;
  }
  int get num1{
    return num;
  }
  void im(var Url){
    image=Url;
    notifyListeners();
  }
  void im1(var Url){
    image_n=Url;
    notifyListeners();
  }
  void dapp(var x){
    dtextapp=x;
    notifyListeners();
  }
}