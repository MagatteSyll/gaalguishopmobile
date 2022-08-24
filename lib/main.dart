import 'package:flutter/material.dart';
import './page/accueil.dart';
import './utils/route.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import './utils/apiservice.dart';
import '../utils/notificationservice.dart';
import 'dart:convert' as convert;
import 'package:flutter/services.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';



 const platform =  MethodChannel("gaalguishop.native.com/auth");
deconnexion() async{
  await platform.invokeMethod("deconnexion");
} 
 Future getislog() async{
  var url=Uri.parse('https://gaalguishop.herokuapp.com/api/utilisateur/isauthenticated/',);
  var result=await  httpIns.get(url);
 if(result.statusCode!=200){
    deconnexion();
   return false ;
 }
 else{
 var response=convert.jsonDecode(result.body);
  return response;
 }
}

var httpIns=HttpInstance();
Future managetokenapp(token) async{
  var islog=await getislog();
  if(islog==true){
   var url=Uri.parse('https://gaalguishop.herokuapp.com/api/utilisateur/getdeviceapp/',);
  var result=await  httpIns.post(url,body: {
    "registration_id": token,
    "type": 'android',
  });
 if(result.statusCode==200){
   print(result.body);
 }
 else{
print(result.statusCode);
 }
  }
else{
  return;
}
  
}

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message ${message.data}');
   LocalNotificationService().showNotification(
      body: message.data['body'],
      title: message.data['titre'], 
      id: 5,
      payload: "payload"
      );
}

 
 Future <void> main() async {
   WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    return;
  } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
   print('User granted provisional permission');
  } else {
  print('User declined or has not accepted permission');
  }
  final token = await messaging.getToken();
  await managetokenapp(token);
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  runApp( MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
 

@override
  void initState() {
    super.initState();
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message != null) {
        Navigator.pushNamed(
          context,
          '/notification',
         );}});
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      LocalNotificationService().showNotification(
      body: message.data['body'],
      title: message.data['titre'], 
      id: 5,
      payload: "payload"
      );
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      Navigator.pushNamed(
        context,
        '/notification',
      );
    });
  
  }
@override
Widget build(BuildContext context) {
  return const  MaterialApp(
      home: Accueil(),
      onGenerateRoute:RouteGenerator.generateRoute,
);
  
  }
}


/*
  void _addBadge() {
    FlutterAppBadger.updateBadgeCount(1);
  }

  void _removeBadge() {
    FlutterAppBadger.removeBadge();
  }*/