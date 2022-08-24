// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import "../utils/apiservice.dart";
import 'dart:convert' as convert;
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../utils/trunfunction.dart';



class Recherche extends StatefulWidget {
  final dynamic mot;
   const Recherche(this.mot, {super.key});

  @override
  State<Recherche> createState() => _RechercheState();
}

class _RechercheState extends State<Recherche> {
  var httpIns=HttpInstance();
   ScrollController scrollController=ScrollController();
   List<Map<String, dynamic>> items=[] ;
    bool allloaded=false;
  bool loaded=false;
  int page=1;
 var next;
 var previous;
 late bool load;
 Future getresult()async{
  setState(() {
    load=true;
  });
  var url=Uri.parse('https://gaalguishop.herokuapp.com/api/produit/search/?search=${widget.mot}',);
    var response= await httpIns.get(url);
    if(response.statusCode==200){
    var jsonResponse = convert.jsonDecode(response.body) as Map<String, dynamic>;
   // print(response.body);
    setState(() {
      for(var i=0;i<jsonResponse['results'].length;i++){
     items.add(jsonResponse['results'][i]);
      }
    next=jsonResponse['next'];
     page++;
     previous=jsonResponse['previous'];
    load=false;
      }); 
    return jsonResponse;
     
    }
  else{
    return;
    //print(response.statusCode);
  }
 }
 Future getother() async{
    setState(() {
      load=true;
    });
    var url=Uri.parse('https://gaalguishop.herokuapp.com/api/produit/search/?search=${widget.mot}/?page=${page}',);
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
 else{
 
  return ;
 }  
 }
 @override
  void initState() {
    getresult();
    setState((){
   loaded=true;
  });
  scrollController.addListener(() {
    if(scrollController.position.maxScrollExtent==scrollController.offset && !load){
     if(next!=null){
     getother();}
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
        backgroundColor:const  Color.fromRGBO(200, 104, 28, 1),
        automaticallyImplyLeading:false,
        leading:IconButton(icon: const Icon(Icons.arrow_back_ios,color: Colors.white),
          onPressed: (() {
            Navigator.of(context).pop();
          }), ),
        title:Text(widget.mot,style:const  TextStyle(color: Colors.white),),
        ),
      body: items.isNotEmpty?Container(
        margin:const EdgeInsets.only(top: 30,left: 2,right: 2),
        child: GridView.builder(
          gridDelegate:const  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
          controller: scrollController,
          itemCount: items.length ,
           itemBuilder: ((context, index){
            var item=items[index];
            return Container(
              child: Card(
                elevation: 5,
                child: Column(children: [
                  Image.network(item['thumbnail'],
                width: 150,
                height: 120,),
                const SizedBox(width: 5,),
                 TextButton(
                  onPressed: (){
                  Navigator.of(context).pushNamed('/detail',arguments: item['slug']);
                    },
                    child: Text(truncateString(item['nom'],20) ,
                    style:const  TextStyle(fontWeight: FontWeight.bold),),
                  ),
                ]),
              ),
            );
            
            
          })
        ),
      ):
    Container(
      child:const Center(child: 
      ListTile(title: Text("Oups aucun resultat pour cette recherche ",
      style: TextStyle(fontWeight: FontWeight.bold,color: Colors.brown),),)),
    )
  ); } 
  else{
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
}



