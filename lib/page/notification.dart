// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import "../utils/apiservice.dart";
import 'dart:convert' as convert;
import 'package:flutter_spinkit/flutter_spinkit.dart';



class Notif extends StatefulWidget {
  const Notif({super.key});

  @override
  State<Notif> createState() => _NotifState();
}

class _NotifState extends State<Notif> {
late bool load;
 bool allloaded=false;
 bool loaded=false;
 var httpIns=HttpInstance();
ScrollController scrollController=ScrollController();
List<Map<String, dynamic>> items=[] ;
int page=1;
 var next;
 var previous;
 Future getfirstnotif()async{
  if(previous==null){
    setState(() {
      load=true;
    });
    
    var url=Uri.parse('https://gaalguishop.herokuapp.com/api/utilisateur/getnotification/',);
    var response= await httpIns.get(url);
    if(response.statusCode==200){
    var jsonResponse = convert.jsonDecode(response.body) as Map<String, dynamic>;
   // print(response.body);
 // print(jsonResponse['results'].length);
    setState(() {
  if(jsonResponse['results'].length>0){
   for(var i=0;i<jsonResponse['results'].length;i++){
     items.add(jsonResponse['results'][i]);}
     next=jsonResponse['next']; 
     page++;
     previous=jsonResponse['previous'];
     load=false;
   }
  });
    return jsonResponse;
}
else {
  return;
}
  }
else{
  return;
}
    
}
Future getothernotif()async{
   setState(() {
      load=true;
    });
   
    var url=Uri.parse('https://gaalguishop.herokuapp.com/api/utilisateur/getnotification/?page=${page}',);
    var response= await httpIns.get(url);
    if(response.statusCode==200){
    var jsonResponse = convert.jsonDecode(response.body) as Map<String, dynamic>; 
   setState(() {
  for(var i=0;i<jsonResponse['results'].length;i++){
     items.add(jsonResponse['results'][i]);
      }
    next=jsonResponse['next'];
     page++;
     previous=jsonResponse['previous'];
    load=false;
    });
   return ;
 }
}
 @override
  void initState() {
   getfirstnotif();
  setState(() {
    loaded=true;
  });
   scrollController.addListener(() {
    if(scrollController.position.maxScrollExtent==scrollController.offset && !load){
     if(next!=null){
     getothernotif();}
     else{
       setState(() {
         allloaded=true;
         load=false;
       });
     }
     }});

   super.initState();
}

  @override
  Widget build(BuildContext context) {
   if(loaded){
    return Scaffold(
      appBar: AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      automaticallyImplyLeading: false,
      leading: IconButton(onPressed: (() {
        Navigator.of(context).pop();
      }),
     icon:const  Icon(Icons.arrow_back_ios,color: Colors.black,),), ),
     body:items.isNotEmpty?  Stack(
       children: [
         ListView.builder(
            controller: scrollController,
            itemCount: items.length ,
            itemBuilder: ((context, index){
              var item=items[index];
              String date=item['created'];
             final  formattedDate =DateTime.parse(date);
            final DateFormat formatter = DateFormat('dd-MM-yyyy');
           final heure=DateFormat('HH:mm');
        final String formatted = formatter.format(formattedDate);
         String heuresting=heure.format(formattedDate);
        handleTap(){
        if(items[index]['nature_notification']=='avertissement'){
        Navigator.of(context).pushNamed('/notifavertissement',arguments:items[index]['id']);
        }
       if(items[index]['nature_notification']=='etat commande'){
       Navigator.of(context).pushNamed('/notifetatcommande',arguments:items[index]['id']);
       }
      if(items[index]['nature_notification']=='vente'){
      Navigator.of(context).pushNamed('/notifvente',arguments:items[index]['id']);
      }
     if(items[index]['nature_notification']=='annulation d achat'){
     Navigator.of(context).pushNamed('/notifannulationachat',arguments:items[index]['id']);
      }
     if(items[index]['nature_notification']=='pour follower'){
     Navigator.of(context).pushNamed('/notifollower',arguments:items[index]['id']);
     }
    if(items[index]['nature_notification']=='reactivation boutique'){
     Navigator.of(context).pushNamed('/notifreactivation',arguments:items[index]['id']); 
    }
    if(items[index]['nature_notification']=='note vendeur'){
    Navigator.of(context).pushNamed('/notifnotevendeur',arguments:items[index]['id']); 
    }
     if(items[index]['nature_notification']=="annulation de vente"){
      Navigator.of(context).pushNamed('/notifannulationvente',arguments:items[index]['id']); 
      }
    if(items[index]['nature_notification']=="desactivation boutique"){
      Navigator.of(context).pushNamed('/notifdesactivation',arguments:items[index]['id']);
      }
}
              return Card(
                elevation: 8,
                child: GestureDetector(
                  onTap: () {
                   handleTap(); 
                  },
                 child:ListTile(
                  contentPadding:const  EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  title: Text(
                  item['message'],
                //truncateString(item['message'], 50)  ,
                  style:const  TextStyle(color: Colors.black, fontWeight: FontWeight.bold), ),
                   subtitle: Row(
                 children: <Widget>[
                 const Icon(Icons.alarm,color: Color.fromRGBO(200, 104, 28, 1),),
                 Text("$formatted,$heuresting",
                style:const  TextStyle(color: Colors.black, fontWeight: FontWeight.bold))
              ],
            ),
                 )

                ),
                );
            }
           ),
         ),
       if(load)...const [
                 Positioned(
                left:130,
                bottom: 0,
                child: Center(
                child:  Loadinganimate(),
              ))
              ]
      
       ],
     ):
     
     Container()
     
     
     );
   } 
  else{
   return Container(
     decoration: const BoxDecoration(color: Colors.white),
     child: const  SpinKitFadingCircle(
     color: Color.fromARGB(137, 18, 35, 92),
     size: 30.0,
     duration: Duration(milliseconds: 1000),
)
    );
  }
  }
}

truncateString(str, int num) {
    if (str.length > num) {
      String  subStr = str.substring(0, num);
        return "$subStr...";
    } else {
        return str;
    }
  }



class Loadinganimate extends StatelessWidget {
  const Loadinganimate({super.key});

  @override
  Widget build(BuildContext context) {
     return Container(
     decoration: const BoxDecoration(color: Colors.white),
     child: const  SpinKitCircle(
     color: Color.fromARGB(137, 18, 35, 92),
     size: 50.0,
     duration: Duration(milliseconds: 1000),
)
    );
    
  }
}