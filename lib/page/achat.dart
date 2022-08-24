// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import '../utils/trunfunction.dart';
import "../utils/apiservice.dart";
import 'dart:convert' as convert;
import 'package:flutter_spinkit/flutter_spinkit.dart';



class Achat extends StatefulWidget {
  const Achat({super.key});

  @override
  State<Achat> createState() => _AchatState();
}

class _AchatState extends State<Achat> {
   ScrollController scrollController=ScrollController();
  List<Map<String, dynamic>> items=[] ;
  bool allloaded=false;
  bool loaded=false;
  late bool load;
  var httpIns=HttpInstance();
  int page=1;
  var next;
  var previous;

Future getcommande() async{
    setState(() {
      load=true;
    });
    var url=Uri.parse('https://gaalguishop.herokuapp.com/api/produit/historiquedachat/',);
    var result=await  httpIns.get(url);
    if(result.statusCode==200){
  var jsonResponse = convert.jsonDecode(result.body) as Map<String, dynamic>; 
 // print(result.body); 
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
Future getothercommande() async{
 setState(() {
  load=true;
    });
    var url=Uri.parse('https://gaalguishop.herokuapp.com/api/produit/historiquedachat/?page=${page}',);
    var result=await  httpIns.get(url);
    if(result.statusCode==200){
  var jsonResponse = convert.jsonDecode(result.body) as Map<String, dynamic>; 
  //print(result.body); 
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
void initState(){
  getcommande();
   setState((){
   loaded=true;
  });
  scrollController.addListener(() {
    if(scrollController.position.maxScrollExtent==scrollController.offset && !load){
     if(next!=null){
     getothercommande();}
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
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        elevation: 0,
        leading: IconButton(icon:const  Icon(Icons.arrow_back_ios,color: Colors.brown,),
        onPressed: (){
       Navigator.of(context).pop();
        },),
        title: Row(children:const [
       Text('Produits achetés ',
       style:  TextStyle(color: Colors.black,fontWeight: FontWeight.bold,),),
         ],), ), 
      body: Container(
      margin: const EdgeInsets.only(top: 20),
      child: 
      Column(
        children: [
          const SizedBox(height: 25,),
          items.isNotEmpty?
          Expanded(
          child: GridView.builder(
          shrinkWrap: true,
          gridDelegate:const  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
          controller: scrollController,
           itemCount: items.length ,
          itemBuilder: ((context, index){
          var item=items[index];
         return Container(
          margin: const EdgeInsets.only(bottom: 5),
          child:  Card(
          elevation: 1.5,
          child: Column(
          children: [
          item['produitcommande']['product']['variation']?
          Image.network(item['produitcommande']['imageproduct']['image'],
          width: 150, height: 120,):
         Image.network(item['produitcommande']['product']['thumbnail'],
         width: 150, height: 120,),
          TextButton(
          onPressed: (){
           Navigator.of(context).pushNamed('/detailcommande',arguments: item['id']);  },
          child: Text(truncateString(item['produitcommande']['product']['nom'],25) ,
          style:const  TextStyle(fontWeight: FontWeight.bold),),  ), 
           ],  ), )
           ); }
          )
          ),
            )
            :Container(
            child: Center(child: Column(
              children: [
              const Text("Vous n avez encore rien acheté,"),
              TextButton(onPressed:(){} , 
              child: const Text("Commencez vos Shoppings"))
              ],
            )),
          )
            
        ],)
        
        )  );
  } 
else{
  return  Container(
     decoration: const BoxDecoration(color: Colors.white),
     child: const  SpinKitCircle(
     color: Color.fromARGB(137, 18, 35, 92),
     size: 50.0,
     duration: Duration(milliseconds: 1000),
)
    );
} 
  }
}