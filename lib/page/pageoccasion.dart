// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import "../utils/apiservice.dart";
import 'dart:convert' as convert;
import 'package:flutter_spinkit/flutter_spinkit.dart';



class PageOccasion extends StatefulWidget {
  const PageOccasion({super.key});

  @override
  State<PageOccasion> createState() => _PageOccasionState();
}

class _PageOccasionState extends State<PageOccasion> {
 
 late bool load;
 bool allloaded=false;
 bool loaded=false;
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
    var url=Uri.parse('https://gaalguishop.herokuapp.com/api/produit/pageproduitoccasion/',);
    var response= await httpIns.get(url);
    if(response.statusCode==200){
   //  print(response.body);
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
 // print(response.statusCode);
  return ;
}
  }
else{
  
  return ;
}
    
}
Future getotherproduit()async{
   setState(() {
      load=true;
    });
var url=Uri.parse('https://gaalguishop.herokuapp.com/api/produit/pageproduitoccasion/?page=$page',);
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
       title: const Text('Occasions'),
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
               child: Card(
              child: Row(
               children: [
              TextButton(
              onPressed: (){
             Navigator.of(context).pushNamed('/detail',arguments:items[index]['slug'] );
            },
            child: ClipRRect(
           borderRadius: const  BorderRadius.all(Radius.circular(15.0)),
          child:Image.network(items[index]['thumbnail'], 
         width:150.0,height: 120,
         fit: BoxFit.fitWidth,),), ),
        Container(child: Column(children: [TextButton(
          onPressed: (){
          Navigator.of(context).pushNamed('/detail',arguments:items[index]['slug'] );
        },
        child: Text(items[index]['nom'],style: const  TextStyle(fontWeight: FontWeight.bold,
        color: Colors.black,
        decoration: TextDecoration.underline,
         textBaseline: TextBaseline.ideographic),), ),
         TextButton(
          onPressed: (){
          Navigator.of(context).pushNamed('/detail',arguments:items[index]['slug'] );
                          },
                          // ignore: prefer_interpolation_to_compose_strings
         child: Text("${items[index]['prix']}" ""+items[index]['devise']['devise'] ,style: const  TextStyle(fontWeight: FontWeight.bold,
          color: Colors.pink,
          decoration: TextDecoration.underline,
          textBaseline: TextBaseline.ideographic),), ),
           ]), )
            ],
           ),));
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

