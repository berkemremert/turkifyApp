import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore firebaseInstance = FirebaseFirestore.instance;

int neededWarnsForBan = 2;

Future<bool> checkMessage(String id, String message) async{
  bool spamDetected = await detection(message);
  if(spamDetected){
    incrementWarn(id);
    int warnCount = await getWarnCount(id);
    if(warnCount > neededWarnsForBan) banUser(id);
    return true;
  }
  return false;
}

Future<bool> isUserBanned(String id) async{
  DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(id).get();
  Map<String, dynamic> userData = (userDoc.data() as Map<String, dynamic>);
  return userData["isBanned"];
}

void banUser(String id) async{
  await FirebaseFirestore.instance.collection('users').doc(id).set({
    "isBanned": true,
  }, SetOptions(merge: true));
}

void unbanUser(String id) async{
  await FirebaseFirestore.instance.collection('users').doc(id).set({
    "isBanned": false,
  }, SetOptions(merge: true));
}

Future<int> getWarnCount(String id) async{
  DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(id).get();
  Map<String, dynamic> userData = (userDoc.data() as Map<String, dynamic>);
  return userData["warnCount"];
}

void setWarnCount(String id, int num) async{
  await FirebaseFirestore.instance.collection('users').doc(id).set({
    "warnCount": num,
  }, SetOptions(merge: true));
}

void incrementWarn(String id) async{
  var userDoc = await FirebaseFirestore.instance.collection('users').doc(id);
  Map<String, dynamic> userData = ((await userDoc.get()).data() as Map<String, dynamic>);
  userDoc.set({
    "warnCount": userData["warnCount"]+1,
  }, SetOptions(merge: true));
}

// Future<bool> detection(String message) async{
//   var path = "assets/bannedWords.txt";
//   String control = message.toLowerCase();
//   List<String> words = [];
//   var file = File(path)
//       .openRead()
//       .transform(utf8.decoder)
//       .transform(new LineSplitter())
//       .forEach((l) => words.add(l));
//   for(String word in words){
//     if(control.contains(word)){
//       return true;
//     }
//   }
//   return false;
// }

Future<bool> detection(String message) async{
  String control = message.toLowerCase();
  for(String word in words){
    if(control.contains(word)){
      return true;
    }
  }
  return false;
}

const List<String> words = [
"am",
"amcığı",
"amcığın",
"amcığını",
"amcığınızı",
"amcık",
"amcıklama",
"amcıklandı",
"amcik",
"amck",
"amık",
"amına",
"amınako",
"amınakoyim",
"amına",
"amın",
"amını",
"amısına",
"amısını",
"amina",
"amk",
"amq",
"anan",
"anana",
"anandan",
"ananı",
"ananı",
"ananın",
"ananınki",
"ananısikerim",
"ananısikeyim",
"anani",
"ananin",
"ananisikerim",
"angut",
"anneni",
"annenin",
"annesiz",
"anuna",
"atkafası",
"atmık",
"attırdığım",
"attrrm",
"avrat",
"azdım",
"azdır",
"azdırıcı",
"domal",
"domalan",
"domaldı",
"domaldın",
"domalık",
"domalıyor",
"domalmak",
"domalmış",
"domalsın",
"domalt",
"domaltarak",
"domaltıp",
"domaltır",
"domaltırım",
"domaltip",
"domaltmak",
"dölü",
"dönek",
"düdük",
"eben",
"ebeni",
"ebenin",
"ebeninki",
"fahise",
"fahişe",
"feriştah",
"ferre",
"fuck",
"fucker",
"fuckin",
"fucking",
"gavad",
"gavat",
"geber",
"gerızekalı",
"gerizekalı",
"gerizekali",
"godumun",
"gotelek",
"gotlalesi",
"gotlu",
"gotten",
"gotundeki",
"gotunden",
"gotune",
"gotunu",
"gotveren",
"goyiim",
"goyum",
"goyuyim",
"goyyim",
"göt",
"göt",
"götoş",
"götten",
"götü",
"götün",
"götüne",
"götünekoyim",
"götveren",
"hasiktir",
"hassiktir",
"ibine",
"ibinenin",
"ibne",
"ibnedir",
"ibneleri",
"ibnelik",
"ibnelri",
"ibneni",
"ibnenin",
"ibnerator",
"ibnesi",
"kaltak",
"kancık",
"kancik",
"kappe",
"karhane",
"kaşar",
"kavat",
"kerane",
"kerhane",
"kerhanelerde",
"kevase",
"kevaşe",
"kevvase",
"koduğmun",
"koduğmunun",
"kodumun",
"kodumunun",
"koduumun",
"koyarm",
"koyayım",
"koyiim",
"koyiiym",
"koyim",
"koyum",
"koyyim",
"madafaka",
"mal",
"malafat",
"malak",
"manyak",
"oc",
"ocuu",
"ocuun",
"OÇ",
"oç",
"orosbucocuu",
"orospu",
"orospucocugu",
"orospuçocuğu",
"orospudur",
"orospular",
"orospunun",
"orospuydu",
"orospuyuz",
"orostoban",
"orostopol",
"orrospu",
"oruspu",
"oruspuçocuğu",
"pezevek",
"pezeven",
"pezeveng",
"pezevengi",
"pezevengin",
"pezevenk",
"piç",
"s1kerim",
"s1kerm",
"s1krm",
"sakso",
"salaak",
"salak",
"saxo",
"sıçarım",
"sıçtığım",
"sıecem",
"sicarsin",
"sik",
"sike",
"sikecem",
"sikem",
"siker",
"sikerim",
"sikerler",
"sikeydim",
"sikeyim",
"siki",
"sikicem",
"sikici",
"sikik",
"sikilmis",
"sikilmiş",
"sikilsin",
"sikim",
"sikimde",
"sikimden",
"sikime",
"sikimi",
"sikimiin",
"sikimin",
"sikimle",
"sikimsonik",
"sikimtrak",
"sikin",
"sikinde",
"sikinden",
"sikip",
"sikis",
"sikisek",
"sikismis",
"sikiş",
"sikişen",
"sikişme",
"sikiyim",
"sikiyorum",
"sikleri",
"sikmem",
"sikmisligim",
"siksem",
"sikseydin",
"siksin",
"siktigimin",
"siktigiminin",
"siktiğim",
"siktiğimin",
"siktiğiminin",
"siktiler",
"siktim",
"siktim",
"siktimin",
"siktiminin",
"siktir",
"siktirir",
"siktiririm",
"siktiriyor",
"sokam",
"sokarım",
"sokarim",
"sokarm",
"sokayım",
"sokaym",
"sokiim",
"soktuğumunun",
"sokuk",
"sokum",
"sokuş",
"sokuyum",
"soxum",
"sulaleni",
"sülaleni",
"sülalenizi",
"sürtük",
"şerefsiz",
"şıllık",
"tasak",
"tassak",
"taşak",
"taşşak",
"totoş",
"vajina",
"vajinanı",
"yaraaam",
"yarak",
"yaraksız",
"yaraktr",
"yaram",
"yaraminbasi",
"yaramn",
"yarra",
"yarraaaa",
"yarraak",
"yarraam",
"yarraamı",
"yarragi",
"yarragimi",
"yarragina",
"yarragindan",
"yarragm",
"yarrağ",
"yarrağım",
"yarrağımı",
"yarraimin",
"yarrak",
"yarram",
"yarramin",
"yarraminbaşı",
"yarramn",
"yarran",
"yarrana",
"yarrrak",
"yavak",
"yavş",
"yavşak",
"yavşaktır",
"yavuşak",
"yılışık",
"yilisik",
"yrrak",
"zıkkımım",
"zibidi",
"zigsin",
"zikeyim",
"zikiiim",
"zikiim",
"zikik",
"zikim",
"ziksiiin",
"ziksiin",
"zulliyetini",
"ass",
"asshole",
"bastard",
"bitch",];