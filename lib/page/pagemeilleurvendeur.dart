// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:gaalguishop/page/notification.dart';
import 'package:intl/intl.dart';
import "../utils/apiservice.dart";
import 'dart:convert' as convert;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';



class PageMeilleurVendeur extends StatefulWidget {
  const PageMeilleurVendeur({super.key});

  @override
  State<PageMeilleurVendeur> createState() => _PageMeilleurVendeurState();
}

class _PageMeilleurVendeurState extends State<PageMeilleurVendeur> {
   late bool load;
 bool allloaded=false;
 bool loaded=false;
 var userid;
 var httpIns=HttpInstance();
ScrollController scrollController=ScrollController();
List<Map<String, dynamic>> items=[] ;
int page=1;
 
 var next;

 var previous;
  static final DateTime now = DateTime.now();
  static final DateFormat formatter = DateFormat('yyyy');
  final String an = formatter.format(now);
Future getfirstlistproduit()async{
  if(previous==null){
    setState(() {
      load=true;
    }); 
    var url=Uri.parse('https://gaalguishop.herokuapp.com/api/produit/pagemeilleurvendeur/',);
    var response= await httpIns.get(url);
    if(response.statusCode==200){
     // print(response.body);
   var jsonResponse = convert.jsonDecode(response.body) as Map<String, dynamic> ;
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
    return;
    // jsonResponse;
}
else {
  return ;
}
  }
else{
  
  return ;
}}
Future getuser() async{
  var url=Uri.parse('https://gaalguishop.herokuapp.com/api/utilisateur/getuser/',);
  var result=await  httpIns.get(url);
 if(result.statusCode==200){
    var response=convert.jsonDecode(result.body);
   setState(()=>{
     userid=response['id'],    
      });
   return response ;
 }
 else{
  return;
 }
}
Future getotherproduit()async{
   setState(() {
      load=true;
    });
var url=Uri.parse('https://gaalguishop.herokuapp.com/api/produit/pagemeilleurvendeur/?page=$page',);
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
   getfirstlistproduit();
   getuser();
  setState(() {
    loaded=true;
  });
   scrollController.addListener(() {
    if(scrollController.position.maxScrollExtent==scrollController.offset && !load){
     if(next!=null){
     getotherproduit();}
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
      appBar:AppBar(
       backgroundColor:const  Color.fromRGBO(200, 104, 28, 1),
       automaticallyImplyLeading: false,
       title: const Text('Les vendeurs '),
       leading: IconButton(
        onPressed: (){
          Navigator.of(context).pop();
        },
       icon: const  Icon(Icons.arrow_back_ios),
       ),
      ),
       body: items.isNotEmpty?
          Stack(
            children: [
              ListView.builder(
                controller: scrollController,
                itemCount: items.length,
                itemBuilder: ((context, index){
                return Container(
                margin: const EdgeInsets.only(top: 20,left: 10),
                child: GestureDetector(
                onTap:userid==items[index]['user']['id']? (){ 
                 Navigator.of(context).pushNamed('/maboutique');
                 }:(){
                Navigator.of(context).pushNamed('/boutiquevu',arguments:items[index]['id'] );
                },
             child: Column(
               children: [
                 ListTile(
                title: Text("${items[index]['user']['prenom']} ${items[index]['user']['nom']}",
                style: const TextStyle(
                  color: Colors.blue
                ),)),
                 Row(
                   children: [
                  CircleAvatar(
                  radius:35,
                  backgroundImage:NetworkImage(items[index]['logo'],
                   ) ),
                  const SizedBox(width: 10,),
                  Container(
                  child: Column(children: [
                  Text(truncateString( items[index]['description'],100)  ) ,
                  const SizedBox(height:10),
                  RatingBarIndicator(
                 rating: double.parse(items[index]['note_vendeur']),
                 itemBuilder: (context, index) => const Icon(
                 Icons.star,
                 color: Color.fromRGBO(200, 104, 28, 1),
                    ),
                itemCount: 5,
               itemSize: 20.0,
                direction: Axis.horizontal,), 
                 ]),  )  ],  ),
               ],
             ),),  );
                })),
              if(load)...const [
                 Positioned(
                left:130,
                bottom: 0,
                child: Center(
                child:  Produitloadanimate(),
              ))
              ] ],
          ):Container(
            margin:const  EdgeInsets.only(left: 130,top:50),
            child: const  Loadinganimate())
    );
    
   } 
  else{
    return Container(
      margin:const  EdgeInsets.only(left: 130,top:50),
      child: const  Loadinganimate(),
    );
  }
  }
}

class Produitloadanimate extends StatelessWidget {
  const Produitloadanimate({super.key});

  @override
  Widget build(BuildContext context) {
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
